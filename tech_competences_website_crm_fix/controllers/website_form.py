from odoo import SUPERUSER_ID, _, tools
from odoo.addons.base.models.ir_qweb_fields import nl2br, nl2br_enclose
from odoo.addons.website_crm.controllers.website_form import WebsiteForm as WebsiteCrmWebsiteForm


class WebsiteForm(WebsiteCrmWebsiteForm):
    def insert_record(self, request, model_sudo, values, custom, meta=None):
        is_lead_model = model_sudo.model == "crm.lead"
        visitor_sudo = False

        if is_lead_model:
            values_email_normalized = tools.email_normalize(values.get("email_from"))
            visitor_sudo = request.env["website.visitor"]._get_visitor_from_request(force_create=True)
            visitor_partner = visitor_sudo.partner_id
            if values_email_normalized and visitor_partner and visitor_partner.email_normalized == values_email_normalized:
                values_phone = values.get("phone")
                if values_phone and visitor_partner.phone:
                    if values_phone == visitor_partner.phone:
                        values["partner_id"] = visitor_partner.id
                    elif (visitor_partner._phone_format("phone") or visitor_partner.phone) == values_phone:
                        values["partner_id"] = visitor_partner.id
                else:
                    values["partner_id"] = visitor_partner.id
            if "company_id" not in values:
                values["company_id"] = request.website.company_id.id
            lang = request.env.context.get("lang", False)
            values["lang_id"] = values.get("lang_id") or request.env["res.lang"]._get_data(code=lang).id

        model_name = model_sudo.model
        if model_name == "mail.mail":
            email_from = _(
                '"%(company)s form submission" <%(email)s>',
                company=request.env.company.name,
                email=request.env.company.email,
            )
            values.update({"reply_to": values.get("email_from"), "email_from": email_from})

        create_context = {"mail_create_nosubscribe": True}
        if is_lead_model:
            # Website leads should create the CRM record without sending the
            # internal salesperson assignment email. The confirmation email
            # is handled separately by the configured CRM automation.
            create_context["tracking_disable"] = True

        record = request.env[model_name].with_user(SUPERUSER_ID).with_context(**create_context).create(values)

        if custom or meta:
            custom_label = "%s\n___________\n\n" % _("Other Information:")
            if model_name == "mail.mail":
                custom_label = "%s\n___________\n\n" % _("This message has been posted on your website!")
            default_field = model_sudo.website_form_default_field_id
            default_field_data = values.get(default_field.name, "")
            custom_content = (
                (default_field_data + "\n\n" if default_field_data else "")
                + (custom_label + custom + "\n\n" if custom else "")
                + (self._meta_label + "\n________\n\n" + meta if meta else "")
            )

            if default_field.name:
                if default_field.ttype == "html" or model_name == "mail.mail":
                    custom_content = nl2br(custom_content)
                record.update({default_field.name: custom_content})
            elif hasattr(record, "_message_log"):
                record._message_log(
                    body=nl2br_enclose(custom_content, "p"),
                    message_type="comment",
                )

        if is_lead_model and visitor_sudo:
            lead_sudo = request.env["crm.lead"].browse(record.id).sudo()
            if lead_sudo.exists():
                vals = {"lead_ids": [(4, record.id)]}
                if not visitor_sudo.lead_ids and not visitor_sudo.partner_id:
                    vals["name"] = lead_sudo.contact_name
                visitor_sudo.write(vals)

        return record.id

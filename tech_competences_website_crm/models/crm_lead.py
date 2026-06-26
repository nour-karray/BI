import logging

from odoo import _, api, fields, models
from odoo.tools import email_normalize


_logger = logging.getLogger(__name__)


class CrmLead(models.Model):
    _inherit = "crm.lead"

    website_request_type = fields.Selection(
        selection=[
            ("contact", "Contact"),
            ("demo", "Demande de demo"),
        ],
        string="Type de demande site web",
        copy=False,
    )
    website_form_email = fields.Char(
        string="Email saisi sur le site",
        copy=False,
        readonly=True,
    )

    @api.model
    def create_from_website_form(self, form_values, request_type="contact"):
        cleaned = self._normalize_website_form_values(form_values)
        errors = self._validate_website_form_values(cleaned, request_type)
        if errors:
            return {
                "errors": errors,
                "form_values": cleaned,
                "lead": self.env["crm.lead"],
            }

        lead_values = self._prepare_website_lead_values(cleaned, request_type)
        lead = self.sudo().create(lead_values)

        if not self.env.context.get("skip_website_confirmation"):
            lead._send_website_confirmation_email()

        return {
            "errors": {},
            "form_values": cleaned,
            "lead": lead,
        }

    @api.model
    def _normalize_website_form_values(self, form_values):
        cleaned = {}
        for key, value in (form_values or {}).items():
            cleaned[key] = value.strip() if isinstance(value, str) else value

        return {
            "contact_name": self._pick_first_value(cleaned, "contact_name", "name", "nom"),
            "email": self._pick_first_value(cleaned, "email", "email_from", "courriel", "mail"),
            "phone": self._pick_first_value(cleaned, "phone", "telephone", "mobile", "phone_number"),
            "company": self._pick_first_value(
                cleaned,
                "company",
                "company_name",
                "partner_name",
                "societe",
            ),
            "subject": self._pick_first_value(cleaned, "subject", "name", "sujet", "objet"),
            "message": self._pick_first_value(cleaned, "message", "description", "details", "comment"),
            "service_interest": self._pick_first_value(
                cleaned,
                "service_interest",
                "service",
                "besoin",
                "solution",
            ),
            "company_size": self._pick_first_value(
                cleaned,
                "company_size",
                "taille_entreprise",
            ),
            "demo_goal": self._pick_first_value(
                cleaned,
                "demo_goal",
                "demo_objective",
                "objectif_demo",
            ),
        }

    @api.model
    def _pick_first_value(self, values, *keys):
        for key in keys:
            value = values.get(key)
            if value:
                return value
        return ""

    @api.model
    def _validate_website_form_values(self, values, request_type):
        errors = {}
        required_fields = {
            "contact_name": _("Veuillez saisir votre nom."),
            "email": _("Veuillez saisir votre adresse e-mail."),
            "message": _("Veuillez saisir votre message."),
        }
        if request_type == "demo":
            required_fields["company"] = _("Veuillez saisir le nom de votre entreprise.")

        for field_name, message in required_fields.items():
            if not values.get(field_name):
                errors[field_name] = message

        email = values.get("email")
        if email and not email_normalize(email):
            errors["email"] = _("L'adresse e-mail saisie n'est pas valide.")

        return errors

    @api.model
    def _prepare_website_lead_values(self, values, request_type):
        request_label = {
            "contact": _("Demande de contact"),
            "demo": _("Demande de demo"),
        }.get(request_type, _("Demande site web"))

        source_xmlid = {
            "contact": "tech_competences_website_crm.utm_source_website_contact",
            "demo": "tech_competences_website_crm.utm_source_website_demo",
        }.get(request_type)
        source = self.env.ref(source_xmlid, raise_if_not_found=False) if source_xmlid else False

        lead_name = values["subject"] or "%s - %s" % (
            request_label,
            values["company"] or values["contact_name"],
        )

        description_lines = [
            values["message"],
        ]
        if values["service_interest"]:
            description_lines.append(_("Service souhaite : %s") % values["service_interest"])
        if values["company_size"]:
            description_lines.append(_("Taille de l'entreprise : %s") % values["company_size"])
        if values["demo_goal"]:
            description_lines.append(_("Objectif de la demo : %s") % values["demo_goal"])

        lead_values = {
            "name": lead_name,
            "type": "lead",
            "contact_name": values["contact_name"],
            "partner_name": values["company"],
            "email_from": values["email"],
            "website_form_email": values["email"],
            "phone": values["phone"],
            "description": "\n".join(line for line in description_lines if line),
            "website_request_type": request_type,
        }
        if source:
            lead_values["source_id"] = source.id
        return lead_values

    def _send_website_confirmation_email(self):
        template = self.env.ref(
            "tech_competences_website_crm.mail_template_website_lead_confirmation",
            raise_if_not_found=False,
        )
        if not template:
            return

        for lead in self:
            if not lead.website_form_email:
                continue
            try:
                template.sudo().send_mail(
                    lead.id,
                    force_send=True,
                    raise_exception=False,
                )
            except Exception:
                _logger.exception(
                    "Unable to send confirmation email for website lead %s",
                    lead.id,
                )

from odoo import fields, models


class CrmLead(models.Model):
    _inherit = "crm.lead"

    website_confirmation_sent = fields.Boolean(
        string="Website confirmation sent",
        default=False,
        copy=False,
    )

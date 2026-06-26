{
    "name": "Tech Competences Website CRM",
    "summary": "Website contact and demo requests routed into Odoo CRM",
    "version": "19.0.1.0.0",
    "category": "Website/Website",
    "author": "OpenAI",
    "license": "LGPL-3",
    "depends": ["website", "crm", "mail"],
    "data": [
        "data/utm_source_data.xml",
        "data/mail_template.xml",
        "views/website_templates.xml",
    ],
    "installable": True,
    "application": False,
}

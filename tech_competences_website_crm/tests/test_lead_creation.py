from odoo.tests.common import TransactionCase


class TestWebsiteLeadCreation(TransactionCase):
    def setUp(self):
        super().setUp()
        self.lead_model = self.env["crm.lead"].with_context(skip_website_confirmation=True)

    def test_contact_form_uses_submitted_email(self):
        result = self.lead_model.create_from_website_form(
            {
                "contact_name": "Jean Prospect",
                "name": "Projet CRM",
                "email_from": "jean.prospect@example.com",
                "phone_number": "+33 6 00 00 00 00",
                "partner_name": "Acme",
                "description": "Je souhaite etre contacte pour une mise en place CRM.",
            },
            request_type="contact",
        )

        self.assertFalse(result["errors"])
        self.assertEqual(result["lead"].email_from, "jean.prospect@example.com")
        self.assertEqual(result["lead"].website_form_email, "jean.prospect@example.com")
        self.assertEqual(result["lead"].contact_name, "Jean Prospect")
        self.assertEqual(result["lead"].name, "Projet CRM")
        self.assertEqual(result["lead"].phone, "+33 6 00 00 00 00")
        self.assertEqual(result["lead"].partner_name, "Acme")
        self.assertIn("Je souhaite etre contacte", result["lead"].description)

    def test_demo_form_requires_company(self):
        result = self.lead_model.create_from_website_form(
            {
                "name": "Sophie Demo",
                "email": "sophie.demo@example.com",
                "message": "Nous voulons une demonstration ERP.",
            },
            request_type="demo",
        )

        self.assertIn("company", result["errors"])

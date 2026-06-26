from odoo import http
from odoo.http import request


class TechCompetencesWebsiteCRMController(http.Controller):
    def _page_values(self, form_values=None, errors=None, success=False):
        return {
            "form_values": form_values or {},
            "errors": errors or {},
            "success": success,
        }

    @http.route(
        ["/contactus"],
        type="http",
        auth="public",
        website=True,
        sitemap=True,
    )
    def contact_page(self, **kwargs):
        submitted = kwargs.get("submitted") == "1"
        values = self._page_values(
            form_values={},
            success=submitted,
        )
        return request.render("tech_competences_website_crm.contact_page", values)

    @http.route(
        ["/demande-de-demo"],
        type="http",
        auth="public",
        website=True,
        sitemap=True,
    )
    def demo_page(self, **kwargs):
        submitted = kwargs.get("submitted") == "1"
        values = self._page_values(
            form_values={},
            success=submitted,
        )
        return request.render("tech_competences_website_crm.demo_page", values)

    @http.route(
        ["/contactus/submit"],
        type="http",
        auth="public",
        website=True,
        methods=["POST"],
        csrf=True,
    )
    def submit_contact(self, **post):
        return self._handle_submission(
            template="tech_competences_website_crm.contact_page",
            request_type="contact",
            success_url="/contactus-thank-you",
            post=post,
        )

    @http.route(
        ["/demande-de-demo/submit"],
        type="http",
        auth="public",
        website=True,
        methods=["POST"],
        csrf=True,
    )
    def submit_demo(self, **post):
        return self._handle_submission(
            template="tech_competences_website_crm.demo_page",
            request_type="demo",
            success_url="/demande-de-demo?submitted=1",
            post=post,
        )

    def _handle_submission(self, template, request_type, success_url, post):
        result = request.env["crm.lead"].sudo().create_from_website_form(
            post,
            request_type=request_type,
        )
        if result["errors"]:
            values = self._page_values(
                form_values=result["form_values"],
                errors=result["errors"],
            )
            return request.render(template, values)
        return request.redirect(success_url)

# Tech Competences Website CRM

Addon Odoo minimal pour relier les pages website existantes a `crm.lead` sans toucher au pipeline CRM existant.

## Ce que l'addon corrige

- l'email saisi par le prospect est force dans `crm.lead.email_from`
- l'email d'origine est aussi conserve dans `crm.lead.website_form_email`
- le mapping du formulaire vers le lead couvre `email_from`, `phone`, `partner_name` et `description`
- le pre-remplissage des pages publiques est neutralise
- les URLs reelles `/contactus` et `/demande-de-demo` sont gerees par l'addon
- une page `Demande de demo` est exposee et cree aussi des leads CRM
- le template d'email de confirmation cible l'adresse du prospect

## Routes

- `/contactus`
- `/demande-de-demo`

## Procedure de test

1. Installer l'addon dans Odoo avec les dependances `website`, `crm`, `mail`.
2. Ouvrir `/contactus`.
3. Verifier que `Nom`, `Telephone` et `Adresse e-mail` ne sont pas pre-remplis a l'ouverture.
4. Envoyer un formulaire de contact avec un email de test.
5. Dans le CRM, ouvrir la piste creee et verifier :
   - `email_from` = email saisi
   - `website_form_email` = email saisi
   - `phone` = telephone saisi
   - `partner_name` = entreprise saisie
   - `description` contient le message saisi
6. Verifier la reception de l'email de confirmation sur l'adresse du prospect.
7. Ouvrir `/demande-de-demo` puis refaire le test avec une demande de demo.
8. Verifier qu'aucune etape du pipeline CRM existant n'a ete modifiee.

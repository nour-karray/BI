# Rapport De Projet

## Mise En Place D'Un Site Web De Services Intégré Au CRM Et Au Module Ventes Sous Odoo Pour Tech-Competences

**Entreprise :** Tech-Competences  
**Plateforme :** Odoo  
**Base de travail :** `IIT1_Test`  
**Date :** 3 mai 2026

---

## 1. Introduction

Ce projet consiste à concevoir et mettre en place une solution complète sous Odoo pour l'entreprise Tech-Competences, spécialisée dans les solutions CRM, ERP et la transformation digitale. L'objectif principal n'est pas seulement de réaliser un site web vitrine, mais de construire une chaîne commerciale intégrée allant de la visite du site jusqu'au traitement du prospect dans le CRM, puis à la création d'un devis et au suivi de la vente.

Le projet répond à un besoin concret : permettre à l'entreprise de présenter ses services en ligne, de capter les demandes des visiteurs à travers des formulaires professionnels, de transformer automatiquement ces demandes en pistes commerciales dans Odoo CRM, puis de structurer leur traitement par l'équipe commerciale.

Ainsi, la solution réalisée couvre plusieurs dimensions complémentaires :

- la présence digitale de l'entreprise à travers un site web professionnel ;
- la génération automatique de leads depuis le site ;
- l'organisation du pipeline commercial dans le CRM ;
- l'automatisation des confirmations par e-mail ;
- l'intégration avec le module Ventes pour la création de devis ;
- la préparation d'un processus commercial cohérent, traçable et exploitable.

---

## 2. Contexte Et Problématique

Tech-Competences a besoin d'une solution capable de relier sa communication digitale à son activité commerciale. Dans un fonctionnement classique, un simple site web de présentation ne suffit pas : les visiteurs consultent les pages, mais leurs demandes ne sont pas toujours bien suivies ni transformées en opportunités.

La problématique du projet peut être formulée ainsi :

**Comment mettre en place, sous Odoo, une solution intégrée permettant de présenter les services de Tech-Competences, de collecter les demandes des prospects, de les transformer automatiquement en pistes CRM, puis de les faire évoluer jusqu'au devis et à la vente ?**

Ce projet répond à cette problématique en combinant trois modules principaux :

- `Site Web` pour la présentation et les formulaires ;
- `CRM` pour la gestion des pistes et opportunités ;
- `Ventes` pour la création et le suivi des devis.

---

## 3. Objectifs Du Projet

### 3.1 Objectif Général

Mettre en place sous Odoo une solution intégrée de gestion commerciale reliant un site web de services à un CRM et au module Ventes afin de couvrir le cycle commercial depuis la génération du prospect jusqu'au devis et au suivi des opportunités.

### 3.2 Objectifs Spécifiques

- créer un site web professionnel adapté à l'image de Tech-Competences ;
- personnaliser les pages clés : accueil, à propos, services, contact et demande de démo ;
- connecter les formulaires du site au module CRM ;
- créer automatiquement une piste commerciale à chaque soumission de formulaire ;
- assurer le bon mapping des données du formulaire vers `crm.lead` ;
- envoyer automatiquement un e-mail de confirmation au prospect ;
- envoyer également une notification interne à l'entreprise lors de la création d'un nouveau lead ;
- structurer le pipeline commercial dans Odoo CRM ;
- permettre la création de devis depuis les opportunités ;
- vérifier que le processus global est fonctionnel, cohérent et démontrable.

---

## 4. Environnement Technique

La solution a été mise en œuvre dans un environnement Odoo local, avec une base de démonstration appelée `IIT1_Test`.

Les principaux modules concernés sont :

- `website`
- `website_crm`
- `crm`
- `sale_management`
- `contacts`
- `mass_mailing`
- `account`

L'infrastructure fonctionnelle repose également sur :

- un formulaire web Odoo relié au modèle `crm.lead` ;
- un serveur SMTP Gmail pour l'envoi des e-mails ;
- des automatisations Odoo pour l'envoi des confirmations ;
- des produits de type service dans le module Ventes pour la création des devis.

---

## 5. Démarche Et Processus De Travail

Le travail a été mené de manière progressive, en partant du front office vers le back office, puis en consolidant l'intégration entre les modules.

### 5.1 Étape 1 : Construction Du Site Web

La première phase a consisté à mettre en place les pages principales du site web :

- page d'accueil ;
- page `À propos` ;
- page `Services` ;
- page `Contact` ;
- page `Demande de démo`.

L'objectif était d'obtenir un site web vitrine cohérent avec l'activité de Tech-Competences, avec un contenu orienté CRM, ERP, automatisation commerciale et transformation digitale.

### 5.2 Étape 2 : Connexion Des Formulaires Au CRM

La deuxième phase a porté sur la mise en relation du site avec le CRM. Les formulaires `Contact` et `Demande de démo` ont été reliés à `crm.lead` afin que chaque soumission crée automatiquement une piste commerciale.

Un travail particulier a été effectué sur le mapping des champs, notamment :

- `contact_name`
- `email_from`
- `phone`
- `partner_name`
- `description`

### 5.3 Étape 3 : Correction Du Comportement Des Données

Une anomalie importante avait été identifiée : l'adresse e-mail utilisée dans la piste CRM ne correspondait pas toujours à celle saisie par l'utilisateur. Le comportement du formulaire a donc été corrigé afin de garantir que l'e-mail du prospect soit correctement enregistré et utilisé dans les automatisations.

Un autre point a également été traité : la suppression du préremplissage indésirable de certains champs comme le nom, le téléphone et l'e-mail.

### 5.4 Étape 4 : Automatisation Des E-Mails

Une fois la création des leads stabilisée, le travail s'est poursuivi sur l'envoi automatique des e-mails. Deux logiques ont été mises en place :

- un e-mail de confirmation au prospect ;
- une notification interne vers l'adresse de l'entreprise `karraynour2002@gmail.com` lorsqu'un nouveau lead est créé.

La configuration SMTP Gmail a été ajustée, ainsi que le traitement de la file d'attente des e-mails, pour permettre un envoi automatique réel et non plus un envoi manuel.

### 5.5 Étape 5 : Intégration Du Processus CRM Et Ventes

Enfin, le projet a été complété par l'intégration du flux commercial :

- lead ;
- opportunité ;
- activité de suivi ;
- devis ;
- vente.

Un exemple concret a été préparé dans Odoo afin de démontrer le passage d'une opportunité à un devis en brouillon dans le module Ventes.

---

## 6. Réalisation Du Site Web

### 6.1 Page D'Accueil

La page d'accueil a été retravaillée pour présenter clairement la proposition de valeur de Tech-Competences. Elle met en avant :

- l'accompagnement en transformation digitale ;
- l'intégration de solutions CRM ;
- l'automatisation commerciale ;
- la structuration des ventes.

Des boutons d'appel à l'action permettent au visiteur :

- de demander une démo ;
- de consulter la page des services.

Les cartes de contenu ont également été harmonisées pour remplacer les textes anglais génériques par des messages adaptés au contexte du projet.

### 6.2 Page À Propos

La page `À propos` a été complètement réécrite afin de supprimer le contenu par défaut en anglais. Elle présente désormais :

- la mission de Tech-Competences ;
- sa valeur ajoutée ;
- sa vision métier ;
- son approche d'intégration pragmatique ;
- ses objectifs de performance commerciale.

### 6.3 Page Services

La page `Services` présente les principales offres de l'entreprise :

- intégration CRM ;
- mise en place ERP ;
- formation ;
- support ;
- accompagnement digital.

Les boutons qui renvoyaient auparavant vers des liens vides ont été redirigés vers les pages utiles du site, notamment la demande de démo.

### 6.4 Page Contact

La page `Contact` contient un formulaire relié au CRM. Son introduction a été clarifiée pour mieux orienter le visiteur et l'inviter à décrire son besoin.

Les champs ont été vérifiés afin d'éviter les comportements parasites, notamment :

- préremplissage indésirable ;
- mauvaise remontée de l'e-mail dans le CRM ;
- mauvaise exploitation des informations soumises.

### 6.5 Page Demande De Démo

La page `Demande de démo` a été finalisée pour constituer un second point d'entrée commercial. Elle permet de collecter une demande plus qualifiée, centrée sur un besoin de présentation ou de démonstration d'une solution.

Une page de remerciement spécifique a également été ajoutée pour cette page, afin d'améliorer l'expérience utilisateur et la cohérence du parcours.

---

## 7. Intégration Avec Le CRM

Le cœur du projet réside dans l'intégration du site avec le module CRM.

### 7.1 Création Automatique Des Leads

Lorsqu'un visiteur soumet un formulaire depuis le site :

- une piste est automatiquement créée dans Odoo CRM ;
- les données du prospect sont stockées dans `crm.lead` ;
- le lead est affecté au bon contexte commercial.

### 7.2 Champs Mappés

Les principaux champs utilisés sont :

- `contact_name` : nom du prospect ;
- `email_from` : e-mail saisi dans le formulaire ;
- `phone` : téléphone ;
- `partner_name` : société ;
- `description` : besoin exprimé ou message.

Une attention particulière a été accordée à `email_from`, car ce champ conditionne à la fois :

- la qualité des données CRM ;
- l'envoi des e-mails au bon destinataire ;
- la traçabilité du lead.

### 7.3 Pipeline Commercial

Le projet s'appuie sur un pipeline CRM structuré autour des étapes suivantes :

- Nouveau
- Qualifié
- Proposition
- Négociation
- Gagné
- Perdu

Ce pipeline permet à l'équipe commerciale de suivre l'évolution des demandes, de la première prise de contact jusqu'à la conclusion.

---

## 8. Automatisation Des E-Mails

### 8.1 E-Mail De Confirmation Au Prospect

Un modèle d'e-mail a été préparé afin d'envoyer automatiquement un message de confirmation au prospect après soumission du formulaire.

L'objectif est double :

- rassurer le visiteur en confirmant la prise en compte de sa demande ;
- professionnaliser l'image de l'entreprise dès le premier contact.

### 8.2 Notification Interne

En parallèle, une notification interne est envoyée automatiquement à l'entreprise à l'adresse :

`karraynour2002@gmail.com`

Cela permet à l'équipe de savoir immédiatement qu'un nouveau lead a été généré depuis le site.

### 8.3 Configuration Technique

Pour rendre cela possible, les points suivants ont été traités :

- configuration du serveur SMTP Gmail ;
- correction de l'adresse `email_from` utilisée par les modèles ;
- ajustement des automatisations Odoo ;
- traitement automatique de la file d'attente des e-mails.

Des tests réels ont confirmé l'envoi correct :

- vers le prospect ;
- vers l'adresse interne de l'entreprise.

---

## 9. Intégration Avec Le Module Ventes

Le projet ne s'arrête pas à la création du lead. Il a été prolongé jusqu'au module Ventes pour couvrir une suite logique du processus commercial.

### 9.1 Principe

Une fois une demande qualifiée dans le CRM :

- elle peut être convertie ou suivie en tant qu'opportunité ;
- un devis peut être créé depuis cette opportunité ;
- les lignes de services peuvent être ajoutées au devis ;
- le devis peut ensuite être confirmé pour simuler une vente.

### 9.2 Services Utilisés Dans Les Devis

Des produits de type service ont été préparés dans Odoo afin d'être utilisés dans les devis :

- `TC-CRM-INT` : Intégration CRM Odoo
- `TC-ERP-IMP` : Mise en place ERP
- `TC-TRAIN` : Formation utilisateurs
- `TC-SUPPORT` : Support technique
- `TC-DIGITAL` : Accompagnement digital

Ces services ne sont pas destinés à être achetés directement sur le site web. Ils servent de lignes commerciales dans les devis du module Ventes.

### 9.3 Exemple Préparé

Un cas démonstratif a été mis en place dans Odoo :

- une opportunité issue du site ;
- une activité de démonstration planifiée ;
- un devis en brouillon lié à cette opportunité.

Cette préparation permet de démontrer facilement le passage :

**site web -> lead -> opportunité -> devis**

---

## 10. Processus Fonctionnel Global

Le processus global mis en place dans le projet peut être décrit comme suit :

### 10.1 Visite Du Site

Le visiteur accède au site web de Tech-Competences et consulte les pages :

- accueil ;
- à propos ;
- services ;
- contact ;
- demande de démo.

### 10.2 Soumission D'Un Formulaire

Le visiteur remplit un formulaire, par exemple :

- formulaire de contact ;
- formulaire de demande de démo.

### 10.3 Création D'Une Piste Dans Le CRM

La soumission provoque la création automatique d'une piste dans Odoo CRM.

### 10.4 Qualification Commerciale

L'équipe commerciale examine la demande et évalue :

- le niveau de maturité du besoin ;
- le type de solution recherchée ;
- le potentiel commercial ;
- la nécessité d'une démonstration ou d'un rendez-vous.

### 10.5 Transformation En Opportunité

Si la demande est sérieuse, elle entre dans le pipeline CRM comme opportunité.

### 10.6 Suivi Commercial

Le commercial peut ajouter :

- appels ;
- réunions ;
- e-mails ;
- notes ;
- relances.

### 10.7 Création D'Un Devis

Depuis l'opportunité, un devis est créé dans le module Ventes, avec les services correspondant au besoin du client.

### 10.8 Validation Et Vente

Si le devis est accepté :

- il peut être confirmé ;
- l'opportunité peut être marquée comme gagnée.

---

## 11. Difficultés Rencontrées Et Corrections Apportées

Plusieurs difficultés ont été rencontrées pendant le projet.

### 11.1 Mauvais E-Mail Dans Le Lead

Le champ e-mail du lead ne correspondait pas toujours à l'adresse saisie par l'utilisateur. Ce problème a été corrigé en stabilisant le mapping du formulaire vers `crm.lead`.

### 11.2 Envoi D'E-Mail Vers Le Mauvais Destinataire

Au départ, les messages pouvaient partir vers une adresse interne ou rester en attente. Le système a été corrigé pour :

- envoyer le mail de confirmation au prospect ;
- envoyer la notification interne à l'entreprise ;
- éviter l'envoi manuel.

### 11.3 File D'Attente Des E-Mails

Les e-mails restaient parfois en file d'attente au lieu de partir immédiatement. La configuration de la file Odoo a été revue pour permettre un envoi plus réactif et cohérent avec les tests du projet.

### 11.4 Interfaces Génériques Ou En Anglais

Certaines pages Odoo par défaut contenaient encore du contenu anglais ou des appels à l'action peu adaptés. Elles ont été retravaillées pour correspondre au projet et à l'identité de Tech-Competences.

### 11.5 Lien Entre Opportunité Et Devis

Le champ d'association entre le devis et l'opportunité n'était pas assez visible dans l'interface `Ventes`. Une amélioration d'interface a été apportée pour rendre ce champ plus accessible.

---

## 12. Tests Et Validation

Des tests ont été réalisés sur la base `IIT1_Test` afin de valider le comportement de la solution.

### 12.1 Tests Réalisés

- vérification de l'ouverture des pages du site ;
- vérification de la cohérence des contenus ;
- test de soumission du formulaire `Contact` ;
- test de soumission du formulaire `Demande de démo` ;
- vérification de la création des leads dans le CRM ;
- contrôle du bon enregistrement de l'e-mail, du téléphone, de la société et de la description ;
- vérification de l'envoi du mail de confirmation au prospect ;
- vérification de la notification interne ;
- validation du flux opportunité -> devis.

### 12.2 Résultats

Les résultats obtenus montrent que :

- les formulaires créent bien des pistes CRM ;
- les données sont correctement remontées dans `crm.lead` ;
- les e-mails automatiques sont fonctionnels ;
- le parcours commercial est démontrable jusqu'au devis ;
- les interfaces principales du site sont cohérentes et adaptées à l'entreprise.

---

## 13. Résultats Finaux Du Projet

À l'issue de ce travail, Tech-Competences dispose d'une solution Odoo cohérente et fonctionnelle qui permet :

- de présenter ses services sur un site web professionnel ;
- de collecter les demandes des prospects ;
- de créer automatiquement des pistes commerciales ;
- de suivre les leads dans le CRM ;
- d'automatiser une partie de la communication commerciale ;
- de préparer des devis depuis les opportunités ;
- de rendre visible le cycle commercial complet.

Le projet ne se limite donc pas à une simple personnalisation visuelle du site. Il constitue une base solide de digitalisation du processus commercial.

---

## 14. Limites Et Perspectives D'Amélioration

Bien que le projet soit fonctionnel et complet sur son périmètre principal, plusieurs améliorations peuvent être envisagées :

- enrichir les tableaux de bord CRM ;
- ajouter des scénarios de relance commerciale avancés ;
- connecter davantage `Contacts`, `Documents` ou `Facturation` ;
- améliorer encore le design visuel avec des visuels métier spécifiques ;
- ajouter des statistiques de conversion plus détaillées ;
- préparer un processus après-vente via `Helpdesk` si nécessaire.

À plus long terme, la solution peut évoluer vers une plateforme commerciale plus large intégrant l'avant-vente, la vente, le support et l'analyse de performance.

---

## 15. Conclusion

Ce projet a permis de mettre en place sous Odoo une solution intégrée couvrant plusieurs besoins majeurs de Tech-Competences : communication digitale, génération de leads, gestion CRM, suivi commercial et préparation des devis.

La valeur du projet réside dans l'intégration entre les modules. Le site web n'est pas isolé : il alimente directement le CRM. Le CRM ne reste pas théorique : il prépare le travail commercial réel. Et le module Ventes prolonge logiquement ce processus jusqu'au devis.

La solution obtenue est donc à la fois technique, fonctionnelle et métier. Elle constitue une base robuste pour démontrer comment Odoo peut soutenir un processus commercial complet dans une entreprise de services spécialisée dans les solutions CRM, ERP et la transformation digitale.

---

## 16. Annexe : Résumé Très Court Du Processus

**Site web -> formulaire -> piste CRM -> qualification -> opportunité -> devis -> vente**

---

## 17. Annexe : Procédure De Démonstration Rapide

1. Ouvrir le site web et montrer les pages principales.
2. Soumettre un formulaire `Contact` ou `Demande de démo`.
3. Aller dans `CRM` et montrer la piste créée.
4. Ouvrir le pipeline et montrer l'opportunité.
5. Ajouter une activité de suivi.
6. Créer un devis depuis l'opportunité.
7. Ajouter les lignes de services.
8. Montrer l'e-mail de confirmation et la notification interne.


---
name: cdc-technique
description: Rédige un cahier des charges technique (stack, architecture, modèle de données si pertinent, intégrations, découpage technique) à partir d'un PRD déjà détaillé, rédigé pour être directement consommable par une IA codante (Antigravity/Claude Code). Utiliser ce skill quand l'utilisateur veut cadrer les choix techniques d'un projet/feature, parle de "CDC technique", "architecture", "stack", ou veut préparer la base technique avant de découper en tâches de dev. Produit un fichier CDC.md. Quatrième étape du pipeline idée → dev (suit brainstorm, product-brief et prd, précède dev-loop, dev-memory).
---

# CDC Technique

Quatrième maillon du pipeline "idée → dev". Traduit le comportement fonctionnel défini dans `PRD.md` en **choix techniques** : stack, architecture, modèle de données (si pertinent), intégrations. C'est le "comment c'est construit" — base directe pour `dev-loop`.

## Posture

**Plus de challenge qu'aux étapes précédentes.** Les choix techniques sont des décisions coûteuses à changer une fois le dev commencé — contrairement au fonctionnel, qui peut souvent évoluer sans tout casser. Donc :

- **Détecter `PRD.md`.** S'il existe, partir de chaque brique fonctionnelle pour en déduire les besoins techniques. S'il n'existe pas, le signaler et proposer `prd` d'abord (sans imposer) ; si l'utilisateur décline, demander un minimum de cadrage fonctionnel.
- **Challenge systématique sur la stack/architecture — pas optionnel.** Avant de valider la section "Stack & outils" et "Architecture générale", passer explicitement en revue chaque choix structurant avec au moins une question de ce type, même si la réponse semble évidente :
  - *Version/compatibilité* : l'outil/version existant supporte-t-il vraiment ce qu'on va lui demander ? (ex. "n8n v2.3.4 — le node Anthropic natif existe-t-il dans cette version, ou faut-il une alternative HTTP Request ?")
  - *Adéquation* : est-ce le bon outil pour CE besoin, ou une habitude reprise par défaut ? (ex. "Notion comme interface de validation — un simple statut + email suffirait-il, ou Notion apporte une vraie valeur ici ?")
  - *Point de rigidité* : une fois ce choix fait, qu'est-ce qui devient difficile à changer ? Le dire explicitement.

  Ne pas se contenter de "noter le pourquoi" du choix de l'utilisateur — vérifier activement qu'il tient la route, même brièvement. Si tout est bon, le dire et avancer ; mais le test doit avoir été fait.
- **S'appuyer sur le contexte de l'utilisateur.** Stack habituelle connue (PHP/PostgreSQL/vanilla JS sur o2switch pour Zébra Tools, n8n pour l'automatisation, Flutter/Firebase pour le mobile...) — proposer en cohérence avec l'existant sauf raison contraire, mais le dire explicitement si un autre choix serait objectivement meilleur pour ce cas précis.

## Rédaction pour IA codante

Le CDC doit être directement exploitable comme contexte pour Antigravity/Claude Code, donc :

- **Précision concrète** : noms de technologies/versions, conventions de nommage, chemins/structure de fichiers si déjà connus, plutôt que des généralités ("une base de données" → "PostgreSQL, table `veille_items`").
- **Référencer le PRD** : pour chaque brique technique, indiquer à quelle section du PRD elle correspond, pour que l'IA codante puisse croiser les deux documents sans ambiguïté.
- **Pas de pseudo-code ni d'implémentation complète** : le CDC cadre les choix et la structure, `dev-loop` découpera ensuite en tâches précises avec le code/les prompts.

## Sections du CDC

Structure classique, à adapter selon le projet (omettre ce qui n'est pas pertinent) :

1. **Stack & outils** — langages, frameworks, services externes, hébergement. Pour chaque choix non trivial, noter le "pourquoi" en une phrase si ça apporte de la clarté pour l'IA codante ou pour relire plus tard.

2. **Architecture générale** — comment les briques s'articulent (ex. "n8n orchestre le pipeline, déclenché par cron + webhooks Notion ; Notion sert d'interface de validation et de stockage"). Un schéma textuel simple (liste, flux) suffit ; pas besoin de diagramme pour un projet simple.

3. **Modèle de données** — uniquement si le projet a plusieurs entités/relations clairement identifiables (ex. tables PostgreSQL avec relations, ou base Notion avec plusieurs types d'items liés). Pour une automatisation n8n simple avec une seule base/liste sans relations, omettre cette section — le PRD décrit déjà les champs nécessaires.

4. **Intégrations** — APIs externes, authentification, webhooks, limites connues (rate limits, quotas) à anticiper.

5. **Découpage technique** — grandes briques techniques à développer (peut préfigurer les futurs tickets de `dev-loop`), avec dépendances entre elles si pertinent (ex. "la base Notion doit exister avant le workflow n8n de génération").

6. **Points à trancher / risques techniques** — décisions encore ouvertes nécessitant un choix avant de commencer le dev, ou risques techniques identifiés (ex. "n8n en v2.3.4, vérifier compatibilité avec tel node avant de s'engager sur cette approche").

## Déroulé

1. **Vérifier le contexte.** Chercher `PRD.md` (et `BRIEF.md`/`BRAINSTORM.md` pour le contexte global si besoin).
   - Présent → parcourir les briques fonctionnelles et identifier, pour chacune, les besoins techniques sous-jacents.
   - Absent → proposer `prd` d'abord ; si refus, demander les briques fonctionnelles clés.

2. **Stack & architecture d'abord — revue critique obligatoire.** Avant de figer la stack et l'architecture générale, passer chaque choix structurant par les questions de challenge (version/compatibilité, adéquation, point de rigidité — voir Posture). Ne pas valider une section "Stack & outils" sans avoir explicitement testé au moins les points qui semblent les plus susceptibles de poser problème en pratique (versions anciennes, outils choisis par habitude, dépendances externes).

3. **Brique par brique (découpage technique).** Pour chaque brique fonctionnelle du PRD, déterminer comment elle se traduit techniquement, en référençant la section PRD correspondante.

4. **Modèle de données — évaluer la pertinence.** Si plusieurs entités/relations émergent naturellement, documenter le modèle. Sinon, passer directement.

5. **Risques et points ouverts.** Lister ce qui doit être tranché ou vérifié avant de lancer le dev.

6. **Validation progressive.** Présenter section par section pour validation, en particulier la stack/architecture (fondation) avant de détailler le reste.

## Format de CDC.md

```markdown
# CDC technique — [Nom du projet/feature]

Date : [date]

## Stack & outils

- [Techno/outil] — [usage, pourquoi si pertinent]

## Architecture générale

[Description du flux/articulation des briques, schéma textuel si utile]

## Modèle de données <!-- omettre si pas d'entités/relations significatives -->

- [Entité] : [champs clés, relations]

## Intégrations

- [API/service] — [usage, auth, limites connues]

## Découpage technique

- [Brique technique 1] — [réf. PRD section X] — [dépendances si pertinent]
- [Brique technique 2] — [...]

## Points à trancher / risques

- [Point ouvert ou risque] — [pourquoi ça compte, ce qu'il faut vérifier]
```

Omettre toute section non pertinente plutôt que la laisser vide.

## Emplacement des fichiers

Tous les documents du pipeline vivent dans `.idea-to-dev/` à la racine du projet — `PRD.md` et `CDC.md` désignent `.idea-to-dev/PRD.md` et `.idea-to-dev/CDC.md`.

- **Avec accès au système de fichiers** : chercher `.idea-to-dev/PRD.md`, écrire `.idea-to-dev/CDC.md` dans ce même dossier.
- **En chat sans accès fichiers** : demander à l'utilisateur de coller/uploader `PRD.md` si disponible, puis indiquer d'enregistrer `CDC.md` dans `.idea-to-dev/CDC.md`.

## Fin de session

Une fois `CDC.md` créé et confirmé :

- Proposer optionnellement de passer à `dev-loop`, sans insister.
- Ne pas générer de prompt pour la suite sauf demande explicite.

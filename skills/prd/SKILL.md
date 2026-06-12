---
name: prd
description: Rédige un PRD (Product Requirements Document) détaillant le comportement fonctionnel de chaque brique du périmètre MVP — entrées/sorties, règles, cas limites, statuts/états — à partir d'un brief produit déjà cadré. Utiliser ce skill quand l'utilisateur veut détailler le fonctionnement précis d'un projet/feature avant de passer au technique, parle de "PRD", "spec fonctionnelle", "cahier des charges fonctionnel", ou veut préciser le comportement attendu d'une brique définie en product-brief. Produit un fichier PRD.md. Troisième étape du pipeline idée → dev (suit brainstorm et product-brief, précède cdc-technique, dev-loop, dev-memory).
---

# PRD (Product Requirements Document)

Troisième maillon du pipeline "idée → dev". Détaille le **comportement fonctionnel** de chaque brique définie dans `BRIEF.md` (périmètre MVP) — c'est le passage du "quoi" au "comment ça se comporte", avant de passer au "comment c'est construit" (`cdc-technique`).

## Posture

Même logique que `product-brief` : structuration avec challenge ciblé sur le flou, pas un mode exploratoire complet.

- **Détecter `BRIEF.md`.** S'il existe, partir de son "Périmètre MVP" : chaque capacité listée devient une section à détailler fonctionnellement. S'il n'existe pas, le signaler et proposer `product-brief` d'abord (sans imposer).
- **Une question à la fois**, avec recommandation, sur les points de comportement non précisés (ex. "que se passe-t-il si la génération du draft échoue — on retente, on notifie, on laisse en attente ?").
- **Pragmatique.** Ne pas spéculer sur des cas limites improbables pour un petit outil interne. Si une question de comportement n'a clairement aucun enjeu pour ce projet, ne pas la poser.

## Format : description fonctionnelle par brique (par défaut)

Pour chaque brique du périmètre MVP, détailler :

- **Comportement** : ce qui se passe, déclencheurs, entrées/sorties.
- **Règles** : logique métier, conditions, validations.
- **Statuts/états** (si pertinent) : cycle de vie d'un élément (ex. "à valider" → "validé" → "publié").
- **Cas limites** : erreurs, absence de données, échecs — uniquement ceux qui ont un enjeu réel pour ce projet.

### User stories — uniquement si pertinent

N'utiliser le format "En tant que [rôle], je veux [action], afin de [bénéfice]" que si le projet a **plusieurs rôles/parcours distincts** (ex. admin vs utilisateur final sur un formulaire avec deux interfaces). Pour un outil à un seul type d'utilisateur (la plupart des projets internes Zébra Tools, automatisations n8n, outils perso), ce format ajoute de la verbosité sans clarifier — privilégier la description fonctionnelle directe.

Si user stories utilisées, les regrouper par rôle, et rester bref (le "afin de" peut souvent être omis s'il est évident).

## Déroulé

1. **Vérifier le contexte.** Chercher `BRIEF.md`.
   - Présent → lister les briques du périmètre MVP, les traiter une par une.
   - Absent → proposer `product-brief` d'abord ; si l'utilisateur décline, demander un minimum de cadrage (liste des briques à détailler) avant de continuer.

2. **Brique par brique.** Pour chaque brique :
   - Reformuler en 1-2 phrases ce qu'elle doit faire (rappel du brief).
   - Poser les questions nécessaires sur son comportement précis — une à la fois, avec recommandation.
   - Une fois clair, rédiger la section correspondante.

3. **Détecter les rôles multiples.** Si en discutant il apparaît que plusieurs types d'utilisateurs/parcours existent, le signaler et proposer le format user story pour ces parties — sinon rester en description fonctionnelle.

4. **Validation progressive.** Présenter chaque brique détaillée au fur et à mesure (pas tout d'un coup à la fin) pour validation/ajustement avant de passer à la suivante.

## Format de PRD.md

```markdown
# PRD — [Nom du projet/feature]

Date : [date]

## [Brique 1 — nom repris du Périmètre MVP]

[Rappel en 1 phrase de ce qu'elle fait]

**Comportement**
- [...]

**Règles**
- [...]

**Statuts** <!-- si pertinent -->
- [état] → [état suivant] : [déclencheur]

**Cas limites** <!-- si pertinent -->
- [cas] → [comportement attendu]

## [Brique 2 — ...]

...

## User stories — [Rôle X] <!-- uniquement si plusieurs rôles -->

- En tant que [rôle], je veux [action] [, afin de [bénéfice]]
```

Omettre toute sous-section non pertinente (statuts, cas limites, user stories) plutôt que la laisser vide.

## Emplacement des fichiers

Tous les documents du pipeline vivent dans `.idea-to-dev/` à la racine du projet — `BRIEF.md` et `PRD.md` désignent `.idea-to-dev/BRIEF.md` et `.idea-to-dev/PRD.md`.

- **Avec accès au système de fichiers** : chercher `.idea-to-dev/BRIEF.md`, écrire `.idea-to-dev/PRD.md` dans ce même dossier.
- **En chat sans accès fichiers** : demander à l'utilisateur de coller/uploader `BRIEF.md` si disponible, puis indiquer d'enregistrer `PRD.md` dans `.idea-to-dev/PRD.md`.

## Fin de session

Une fois `PRD.md` créé et confirmé :

- Proposer optionnellement de passer à `cdc-technique`, sans insister.
- Ne pas générer de prompt pour la suite sauf demande explicite.

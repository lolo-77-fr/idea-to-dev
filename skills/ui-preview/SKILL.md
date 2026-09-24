---
name: ui-preview
description: Génère un rendu visuel réel des écrans définis dans SCREENS.md, en respectant les tokens/composants de DESIGN.md, via Stitch (Google Labs — MCP si connecté, sinon prompts prêts à coller sur stitch.withgoogle.com). Étape optionnelle du pipeline idée → dev, à utiliser quand l'utilisateur veut visualiser concrètement les écrans avant de passer au technique, parle de "Stitch", "aperçu visuel", "maquette", "à quoi ça ressemble vraiment". Ne bloque jamais l'enchaînement du pipeline si Stitch n'est pas configuré ou si l'utilisateur ne le souhaite pas.
---

# UI Preview (Stitch)

Étape **optionnelle** du pipeline "idée → dev", entre `ui-design` et `cdc-technique`. `ui-screens` et `ui-design` restent volontairement textuels (voir leurs skills respectifs) — ce skill comble l'écart en générant un vrai rendu visuel via Stitch, pour ceux qui veulent voir les écrans avant de passer au technique, sans changer la nature des deux skills précédents.

**Ce skill n'est jamais obligatoire.** S'il n'est pas invoqué, ou si Stitch n'est pas disponible, le pipeline continue normalement vers `cdc-technique` avec `SCREENS.md`/`DESIGN.md` textuels seuls.

## Prérequis

- `SCREENS.md` (description des écrans) — sans lui, il n'y a rien à visualiser. Le signaler et proposer `ui-screens` d'abord si absent.
- `DESIGN.md` (tokens/composants) — sert de contrainte de style pour la génération, pour que le rendu Stitch respecte la direction déjà validée plutôt que d'improviser une esthétique différente. Si absent, prévenir que Stitch va définir son propre style et proposer de le documenter ensuite dans `DESIGN.md` (voir Répercussion des changements).

## Deux modes selon l'environnement

### Mode MCP (Stitch connecté)

Si un connecteur Stitch est disponible :

- Stitch est un service tiers : avant le premier appel, annoncer à l'utilisateur ce qui va lui être envoyé (descriptions d'écrans, tokens) et obtenir son accord — sauf s'il vient lui-même de demander une génération via Stitch.
- Pour chaque écran à visualiser, construire une consigne de génération combinant : la description de l'écran (`SCREENS.md` — objectif, éléments, actions) + les tokens/composants pertinents de `DESIGN.md` (couleurs, typo, style des composants) — pour que Stitch génère un écran cohérent avec la direction déjà actée, pas une esthétique nouvelle.
- Présenter le résultat, itérer avec l'utilisateur si besoin (ajustements de style, de layout).
- Traiter les écrans un par un plutôt que de tout générer d'un coup, pour permettre l'ajustement au fur et à mesure.

### Mode manuel (Stitch non connecté)

Si aucun connecteur Stitch n'est disponible et que l'utilisateur veut quand même avancer :

- Générer, pour chaque écran, un **prompt prêt à coller** sur stitch.withgoogle.com — reprenant la même logique (description de l'écran + contraintes de style issues de `DESIGN.md`).
- Indiquer à l'utilisateur de coller ce prompt sur Stitch, récupérer le résultat (capture d'écran ou export), et le rapporter dans la conversation s'il veut un avis ou un ajustement du reste du pipeline.

## Répercussion des changements (règle transverse)

Le rendu Stitch peut faire émerger des ajustements de style non prévus dans `DESIGN.md` (Stitch peut affiner ou dévier légèrement la palette/les composants en générant). Si le rendu final diverge de `DESIGN.md`, le signaler explicitement et proposer de mettre à jour `DESIGN.md` en conséquence une fois confirmé, pour que `cdc-technique` s'appuie sur un design system à jour. Règle détaillée portée par l'orchestrateur `idea-to-dev`.

## Export vers le code (si pertinent)

Stitch peut exporter les écrans générés en HTML/CSS, React, Vue, Flutter, SwiftUI ou Figma. Si l'utilisateur souhaite exploiter cet export comme base de code réelle (plutôt qu'un simple aperçu), le signaler à `cdc-technique` : l'architecture front peut alors partir de ce code exporté plutôt que d'être conçue de zéro — à mentionner explicitement dans le CDC (section Architecture générale) pour que `dev-loop` en tienne compte dans le découpage des tâches.

## Emplacement des fichiers

- Chercher `SCREENS.md` et `DESIGN.md` dans `.idea-to-dev/` (ou `.idea-to-dev/[nom-feature]/`).
- Si un export de code est récupéré et que l'utilisateur veut le conserver comme référence, proposer de l'enregistrer dans `.idea-to-dev/stitch-exports/` plutôt qu'à la racine du projet, pour ne pas le confondre avec le code final produit par `dev-loop`.

## Fin de session

- Si `DESIGN.md` a été mis à jour suite à un écart constaté, le signaler clairement.
- Proposer optionnellement de passer à `cdc-technique`, sans insister.
- Ne pas générer de prompt pour la suite sauf demande explicite.

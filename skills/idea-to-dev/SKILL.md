---
name: idea-to-dev
description: Orchestre le pipeline complet "idée → dev" en enchaînant automatiquement brainstorm, product-brief, prd, ui-screens, ui-design, cdc-technique, dev-loop et dev-memory sur un même projet, en proposant de passer à l'étape suivante à la fin de chacune. Gère aussi le démarrage sur un projet existant (code sans docs, nouvelle feature sur projet déjà passé par le pipeline, ou projet ayant évolué hors-pipeline) et la répercussion d'un changement de scope sur les docs déjà produits. Utiliser ce skill quand l'utilisateur veut lancer un nouveau projet/feature de bout en bout, dit "lance le pipeline complet", "on part de zéro sur ce projet", ou veut une vue d'ensemble de l'avancement dans le pipeline idée → dev. À la fin du pipeline, adapte la suite selon le contexte d'exécution (chat vs agent codant avec accès au code).
---

# Idea to Dev — Orchestrateur de pipeline

Chef d'orchestre des 8 skills du pipeline "idée → dev" : `brainstorm` → `product-brief` → `prd` → `ui-screens` → `ui-design` → `cdc-technique` → `dev-loop` → `dev-memory`. Enchaîne les étapes sur un même projet, sans relancer chaque skill manuellement. `mvp-check` complète le pipeline mais n'est pas une étape séquentielle — il est invocable à tout moment (voir plus bas).

## Rôle

Ce skill ne refait pas le travail des skills qu'il orchestre — il les invoque dans l'ordre, gère la transition entre eux, détecte dans quel cas de figure démarre le projet, porte la règle de répercussion des changements, et adapte la fin de pipeline selon le contexte d'exécution.

## Démarrage

1. **Déterminer le cas de figure.** Avant de chercher les docs du pipeline, évaluer la situation du projet :

   - **Cas A — code existant, aucun doc `.idea-to-dev/`.** Le projet a déjà du code mais n'est jamais passé par ce pipeline. Avant `brainstorm`, inventorier brièvement les contraintes imposées par l'existant (stack, archi, conventions déjà en place) — elles doivent être traitées comme des contraintes non négociables dès `brainstorm`, pas explorées comme des options. `brainstorm` gère cet inventaire (voir sa section Posture) ; l'orchestrateur s'assure juste qu'il ne saute pas cette étape.

   - **Cas B — nouvelle feature sur un projet déjà passé par le pipeline.** Un `.idea-to-dev/` existe déjà avec des docs "clos" pour une feature précédente. Demander le nom de la nouvelle feature et créer/utiliser un sous-dossier dédié : `.idea-to-dev/[nom-feature]/` (au lieu d'écrire à la racine de `.idea-to-dev/`). Chaque skill du pipeline cherche/écrit alors dans ce sous-dossier plutôt qu'à la racine.

   - **Cas C — projet ayant évolué hors-pipeline.** Le projet a bouclé le pipeline (ou une partie) une fois, puis a reçu des ajouts/corrections faits directement dans le code, sans passer par les skills (donc non reflétés dans `MEMORY.md`/`TASKS.md`/`CDC.md`). Avant de reprendre le développement ou de démarrer une nouvelle feature (cas B), proposer une **réconciliation** :
     - Avec accès au code (agent codant) : scanner le code pour reconstruire l'état réel, façon `/init` — structure, fonctionnalités présentes, écarts avec les docs existants.
     - Sans accès au code (chat) : demander à l'utilisateur un résumé des changements hors-pipeline, en signalant que c'est moins fiable qu'un scan direct.
     - Une fois l'état réel établi, mettre à jour `MEMORY.md` (et `TASKS.md`/`CDC.md` si les écarts le justifient) avant de considérer la base fiable pour la suite. `dev-memory` est le skill qui porte cette mise à jour (voir sa section dédiée).

   Ces trois cas ne sont pas exclusifs entre eux (ex. cas B + cas C : nouvelle feature sur un projet qui a aussi dérivé hors-pipeline sur l'ancienne). Si le contexte est ambigu, demander à l'utilisateur plutôt que de supposer.

2. **Détecter l'état du projet (dans le sous-dossier concerné si cas B).** Chercher les docs existants dans `.idea-to-dev/` (ou `.idea-to-dev/[nom-feature]/`) : `BRAINSTORM.md`, `BRIEF.md`, `PRD.md`, `SCREENS.md`, `DESIGN.md`, `CDC.md`, `TASKS.md`, `MEMORY.md`.
   - Aucun doc / dossier absent → démarrer à `brainstorm` (en tenant compte du cas A si applicable). Le dossier sera créé par le premier skill qui écrit un fichier.
   - Certains docs présents → reprendre à la première étape manquante (ex. `BRAINSTORM.md` + `BRIEF.md` présents → reprendre à `prd`).
   - Tous présents → le projet est déjà passé par tout le pipeline ; informer l'utilisateur et demander ce qu'il souhaite faire (relancer une étape spécifique, passer directement à l'exécution dev via `dev-loop`/`dev-memory`, ou lancer un `mvp-check`).

3. **Annoncer le point de départ** brièvement avant de commencer, en mentionnant le cas de figure détecté si pertinent (ex. "Je vois `.idea-to-dev/BRAINSTORM.md` et `.idea-to-dev/BRIEF.md` — on reprend à `prd`." ou "Le projet a déjà du code mais pas de `.idea-to-dev/` — on démarre à `brainstorm` en tenant compte de l'existant.").

## Enchaînement

Pour chaque étape (`brainstorm`, `product-brief`, `prd`, `ui-screens`, `ui-design`, `cdc-technique`, `dev-loop`, `dev-memory`, dans cet ordre) :

1. Suivre intégralement les instructions du skill correspondant (posture, déroulé, format de sortie, validation progressive — rien n'est raccourci ou simplifié sous prétexte d'orchestration). Chaque skill porte sa propre exigence de complétude (en particulier `cdc-technique`, qui ne se clôture qu'après sa checklist dédiée) — l'orchestrateur ne doit pas la contourner en pressant la transition.
2. Une fois le doc de l'étape produit et confirmé, **proposer explicitement de passer à l'étape suivante** plutôt que d'enchaîner automatiquement sans accord — l'utilisateur peut vouloir s'arrêter, faire une pause, ou retravailler l'étape courante.
3. Si l'utilisateur décline ou veut s'arrêter, arrêter l'orchestration là — les docs déjà produits restent utilisables indépendamment.

`ui-screens` et `ui-design` sont **obligatoires**, y compris pour un projet à interface minimale — ne jamais les sauter ni les proposer comme optionnels.

`dev-loop` et `dev-memory` peuvent être traités comme un duo final : une fois `TASKS.md` créé par `dev-loop`, proposer `dev-memory` pour initialiser `MEMORY.md` avant de conclure.

## Répercussion des changements (règle transverse)

À n'importe quelle étape du pipeline, un besoin peut apparaître qui dépasse ou contredit ce qu'un doc amont déjà produit avait défini (le scope évolue naturellement au fil de la réflexion — ce n'est pas un problème en soi). Le problème, c'est quand cette évolution reste silencieuse et que les docs amont ne sont pas mis à jour : les étapes suivantes (et un futur agent codant) travaillent alors sur une base obsolète.

Mécanique, applicable par chaque skill quel qu'il soit (et rappelée dans chacun) :

1. **Signaler.** Dès qu'un skill détecte qu'il introduit ou nécessite quelque chose qui dépasse le périmètre défini par un doc amont (`BRIEF.md`, `PRD.md`, `SCREENS.md`, `DESIGN.md`, `CDC.md`), le dire explicitement — quel changement, quel(s) doc(s) amont concernés — plutôt que de l'absorber silencieusement.
2. **Confirmer.** Demander à l'utilisateur si c'est une évolution volontaire ou s'il faut recadrer pour rester dans le périmètre initial.
3. **Répercuter.** Si volontaire, mettre à jour le(s) doc(s) amont concernés en conséquence (pas seulement noter le changement dans le doc courant) — quel que soit à quelle étape on se trouve, la mise à jour remonte jusqu'au doc le plus en amont concerné (potentiellement jusqu'à `BRIEF.md`).
4. **Vérifier l'impact sur `TASKS.md`.** Si le changement survient après que `dev-loop` a produit des tâches, signaler nommément les tâches potentiellement concernées (déjà faites ou à faire) — sans les marquer automatiquement à revoir. C'est à l'utilisateur de trancher au cas par cas.

Cette règle s'applique aussi bien pendant l'enchaînement séquentiel que sur un projet en reprise (cas B/C ci-dessus), et peut être déclenchée par un `mvp-check` qui révèle un écart.

## Fin de pipeline — adapter selon le contexte

Une fois `dev-memory` complété (ou si l'utilisateur arrête le pipeline avant le dev), la suite dépend de **où tourne cette conversation** :

### Contexte chat (claude.ai), sans accès au code du projet

L'utilisateur n'a pas d'agent codant connecté à ce projet dans cette conversation — il devra transférer le travail vers Antigravity/Claude Code séparément.

- Proposer de générer un **prompt de transfert** : un prompt structuré, prêt à coller dans l'agent codant, qui :
  - pointe vers les fichiers du pipeline (`.idea-to-dev/CDC.md`, `.idea-to-dev/PRD.md`, `.idea-to-dev/SCREENS.md`, `.idea-to-dev/DESIGN.md`, `.idea-to-dev/TASKS.md`, `.idea-to-dev/MEMORY.md`) comme sources de vérité — sans en recopier le contenu intégral ;
  - inline en clair, de façon courte : l'état courant (depuis `MEMORY.md`), les contraintes/pièges actifs identifiés, et la ou les prochaines tâches de `TASKS.md` avec leur critère de vérification ;
  - indique à l'agent de lire `MEMORY.md` avant de commencer, et de le tenir à jour au fil du travail (cf. skill `dev-memory`).
- Ne générer ce prompt que sur confirmation — ne pas le produire automatiquement en fin de pipeline.

### Contexte agent codant (Claude Code / Antigravity) avec accès au code

L'utilisateur a lancé ce pipeline directement dans son environnement de dev, avec accès aux fichiers du projet.

- Le développement est la suite logique directe — pas besoin de prompt de transfert.
- Proposer d'enchaîner sur le développement : lire `TASKS.md` et `MEMORY.md`, et commencer la première tâche non faite, en respectant les conventions du skill `dev-loop` (mise à jour des statuts) et `dev-memory` (consigner décisions/pièges au fil de l'eau).

Si le contexte n'est pas clair, demander à l'utilisateur plutôt que de supposer.

## Vérification de conformité à tout moment — `mvp-check`

`mvp-check` n'est pas une étape séquentielle du pipeline — il peut être invoqué à tout moment (pendant `dev-loop`, en fin de pipeline, ou sur demande explicite de l'utilisateur) pour vérifier que l'état réel du projet correspond au périmètre défini dans `BRIEF.md`/`PRD.md`/`SCREENS.md`/`DESIGN.md`, fonctionnalité par fonctionnalité et écran par écran (pas seulement le statut des tâches). Le proposer :

- Une fois `TASKS.md` entièrement complété, avant de considérer le projet/feature livré.
- Sur demande explicite de l'utilisateur à tout autre moment.

Si `mvp-check` révèle un écart, appliquer la règle de répercussion des changements ci-dessus pour le traiter.

## Reprise d'un projet en cours

Si l'utilisateur invoque ce skill sur un projet où `.idea-to-dev/TASKS.md` et `.idea-to-dev/MEMORY.md` existent déjà (pipeline de docs terminé, dev en cours) :

- Vérifier d'abord si une réconciliation (cas C) est nécessaire avant de repartir — voir Démarrage.
- Lire `.idea-to-dev/MEMORY.md` puis `.idea-to-dev/TASKS.md` pour le contexte.
- Résumer brièvement l'état courant et proposer de continuer le développement (pas de repasser par brainstorm/brief/etc., qui sont déjà faits) — sauf si l'utilisateur signale explicitement vouloir revoir une étape antérieure (ex. un changement de périmètre nécessitant de retoucher le PRD, à traiter via la règle de répercussion des changements).

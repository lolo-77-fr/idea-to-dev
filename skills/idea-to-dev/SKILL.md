---
name: idea-to-dev
description: Orchestre le pipeline complet "idée → dev" en enchaînant automatiquement brainstorm, product-brief, prd, cdc-technique, dev-loop et dev-memory sur un même projet, en proposant de passer à l'étape suivante à la fin de chacune. Utiliser ce skill quand l'utilisateur veut lancer un nouveau projet/feature de bout en bout, dit "lance le pipeline complet", "on part de zéro sur ce projet", ou veut une vue d'ensemble de l'avancement dans le pipeline idée → dev. À la fin du pipeline, adapte la suite selon le contexte d'exécution (chat vs agent codant avec accès au code).
---

# Idea to Dev — Orchestrateur de pipeline

Chef d'orchestre des 6 skills du pipeline "idée → dev" : `brainstorm` → `product-brief` → `prd` → `cdc-technique` → `dev-loop` → `dev-memory`. Enchaîne les étapes sur un même projet, sans relancer chaque skill manuellement.

## Rôle

Ce skill ne refait pas le travail des 6 skills — il les invoque dans l'ordre, gère la transition entre eux, et adapte la fin de pipeline selon le contexte d'exécution.

## Démarrage

1. **Détecter l'état du projet.** Chercher les docs existants dans `.idea-to-dev/` à la racine du projet (ou demander à l'utilisateur de les fournir si pas d'accès fichiers) : `BRAINSTORM.md`, `BRIEF.md`, `PRD.md`, `CDC.md`, `TASKS.md`, `MEMORY.md`.
   - Aucun doc / dossier absent → démarrer à `brainstorm`. Le dossier `.idea-to-dev/` sera créé par le premier skill qui écrit un fichier.
   - Certains docs présents → reprendre à la première étape manquante (ex. `BRAINSTORM.md` + `BRIEF.md` présents → reprendre à `prd`).
   - Tous présents → le projet est déjà passé par tout le pipeline ; informer l'utilisateur et demander ce qu'il souhaite faire (relancer une étape spécifique, passer directement à l'exécution dev via `dev-loop`/`dev-memory`).

2. **Annoncer le point de départ** brièvement avant de commencer (ex. "Je vois `.idea-to-dev/BRAINSTORM.md` et `.idea-to-dev/BRIEF.md` — on reprend à `prd`.").

## Enchaînement

Pour chaque étape (`brainstorm`, `product-brief`, `prd`, `cdc-technique`, `dev-loop`, `dev-memory`, dans cet ordre) :

1. Suivre intégralement les instructions du skill correspondant (posture, déroulé, format de sortie, validation progressive — rien n'est raccourci ou simplifié sous prétexte d'orchestration).
2. Une fois le doc de l'étape produit et confirmé, **proposer explicitement de passer à l'étape suivante** plutôt que d'enchaîner automatiquement sans accord — l'utilisateur peut vouloir s'arrêter, faire une pause, ou retravailler l'étape courante.
3. Si l'utilisateur décline ou veut s'arrêter, arrêter l'orchestration là — les docs déjà produits restent utilisables indépendamment.

`dev-loop` et `dev-memory` peuvent être traités comme un duo final : une fois `TASKS.md` créé par `dev-loop`, proposer `dev-memory` pour initialiser `MEMORY.md` avant de conclure.

## Fin de pipeline — adapter selon le contexte

Une fois `dev-memory` complété (ou si l'utilisateur arrête le pipeline avant le dev), la suite dépend de **où tourne cette conversation** :

### Contexte chat (claude.ai), sans accès au code du projet

L'utilisateur n'a pas d'agent codant connecté à ce projet dans cette conversation — il devra transférer le travail vers Antigravity/Claude Code séparément.

- Proposer de générer un **prompt de transfert** : un prompt structuré, prêt à coller dans l'agent codant, qui :
  - pointe vers les fichiers du pipeline (`.idea-to-dev/CDC.md`, `.idea-to-dev/PRD.md`, `.idea-to-dev/TASKS.md`, `.idea-to-dev/MEMORY.md`) comme sources de vérité — sans en recopier le contenu intégral ;
  - inline en clair, de façon courte : l'état courant (depuis `MEMORY.md`), les contraintes/pièges actifs identifiés, et la ou les prochaines tâches de `TASKS.md` avec leur critère de vérification ;
  - indique à l'agent de lire `MEMORY.md` avant de commencer, et de le tenir à jour au fil du travail (cf. skill `dev-memory`).
- Ne générer ce prompt que sur confirmation — ne pas le produire automatiquement en fin de pipeline.

### Contexte agent codant (Claude Code / Antigravity) avec accès au code

L'utilisateur a lancé ce pipeline directement dans son environnement de dev, avec accès aux fichiers du projet.

- Le développement est la suite logique directe — pas besoin de prompt de transfert.
- Proposer d'enchaîner sur le développement : lire `TASKS.md` et `MEMORY.md`, et commencer la première tâche non faite, en respectant les conventions du skill `dev-loop` (mise à jour des statuts) et `dev-memory` (consigner décisions/pièges au fil de l'eau).

Si le contexte n'est pas clair, demander à l'utilisateur plutôt que de supposer.

## Reprise d'un projet en cours

Si l'utilisateur invoque ce skill sur un projet où `.idea-to-dev/TASKS.md` et `.idea-to-dev/MEMORY.md` existent déjà (pipeline de docs terminé, dev en cours) :

- Lire `.idea-to-dev/MEMORY.md` puis `.idea-to-dev/TASKS.md` pour le contexte.
- Résumer brièvement l'état courant et proposer de continuer le développement (pas de repasser par brainstorm/brief/etc., qui sont déjà faits) — sauf si l'utilisateur signale explicitement vouloir revoir une étape antérieure (ex. un changement de périmètre nécessitant de retoucher le PRD).

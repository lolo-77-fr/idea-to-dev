---
name: dev-memory
description: Maintient un fichier MEMORY.md qui consigne les décisions prises en cours de développement, les pièges/conventions spécifiques au projet, les tentatives de débogage en cours, et un pointeur d'état simple — pour éviter la perte de contexte et les hallucinations sur de longues conversations ou entre sessions. Utiliser ce skill quand une session de dev/débogage s'allonge, quand une décision dévie de ce qui était prévu dans CDC/PRD, quand l'utilisateur reprend un projet après une pause, ou demande "où on en était" / "qu'est-ce qu'on a déjà essayé". Sert aussi de point de départ à la réconciliation quand un projet a évolué hors-pipeline. Septième étape du pipeline idée → dev (accompagne dev-loop).
---

# Dev Memory

Septième maillon du pipeline "idée → dev". Maintient `MEMORY.md`, un fichier de **mémoire vive du projet** : ce qui ne figure dans aucun autre doc (CDC/PRD/SCREENS figés une fois validés, TASKS.md = liste de tâches) mais qui est essentiel pour qu'un agent (ou Claude dans une session future) ne perde pas le fil.

## Pourquoi ce fichier

Deux problèmes concrets qu'il adresse :

1. **Dilution du contexte sur une longue conversation** (ex. session de debug qui s'étire) — l'agent finit par oublier ce qui a déjà été essayé, retente les mêmes pistes, ou perd de vue une contrainte mentionnée 50 messages plus tôt.
2. **Perte de contexte entre sessions** — à la reprise, un agent sans `MEMORY.md` peut re-débattre une décision déjà tranchée (et documentée nulle part d'autre), ou ignorer un piège déjà identifié (ex. "le node Anthropic natif ne marche pas en v2.3.4").

`MEMORY.md` n'est pas un journal exhaustif — c'est un filet de sécurité contre la répétition et l'oubli.

## Répercussion des changements (règle transverse) et réconciliation

`MEMORY.md` est alimenté par le pipeline (ce skill, `dev-loop`) au fil de l'eau — mais tout ce qui change le projet ne passe pas forcément par le pipeline (correctifs, ajouts faits directement dans le code, hors session de dev suivie). Dans ce cas, `MEMORY.md` prend du retard silencieusement.

- **Une décision dévie de ce qui était prévu** (CDC, PRD, SCREENS, ou choix antérieur) — la noter ici immédiatement, et signaler si le doc amont correspondant devrait aussi être mis à jour (cf. règle détaillée dans l'orchestrateur `idea-to-dev`) plutôt que de laisser l'écart uniquement dans `MEMORY.md`.
- **Réconciliation** : quand l'utilisateur (ou l'orchestrateur) signale que le projet a évolué hors-pipeline depuis la dernière mise à jour de `MEMORY.md`, ce skill est le point d'atterrissage — scanner le code si l'accès est disponible (façon `/init`) ou recueillir les changements déclarés par l'utilisateur sinon, puis mettre à jour "État courant", "Décisions en cours de route" et "Pièges & conventions" en conséquence avant de considérer l'état du projet fiable.

## Quand l'utiliser / mettre à jour

- **Une décision dévie de ce qui était prévu** (CDC, PRD, ou choix antérieur) — noter quoi et pourquoi, immédiatement, pas en fin de session.
- **Un piège/contrainte non documenté ailleurs est découvert** (ex. comportement inattendu d'un outil, limite d'API) — le noter dès qu'il est identifié.
- **Une session de debug s'allonge** (plusieurs échanges sur le même problème) — consigner les pistes essayées et leur résultat au fur et à mesure, pas seulement à la fin.
- **Avant une modification risquée** (refacto, changement de logique sur du code qui fonctionne) — noter l'état "avant" pour faciliter un retour en arrière.
- **À la reprise d'un projet** — lire `MEMORY.md` en premier, avant `TASKS.md`, pour récupérer le contexte non écrit ailleurs.
- **Quand une réconciliation est nécessaire** (projet ayant évolué hors-pipeline) — voir section ci-dessus.

Mise à jour **continue**, pas seulement en fin de session — l'intérêt du fichier est justement de capter l'info au moment où elle est fraîche, avant qu'elle ne se dilue dans la conversation.

## Structure de MEMORY.md

```markdown
# Mémoire — [Nom du projet/feature]

Dernière mise à jour : [date]

## État courant

[1-3 phrases : où on en est, pointeur vers TASKS.md si pertinent (ex. "tâche en cours : T-18")]

## Décisions en cours de route

- **[Date/contexte court]** — [Ce qui a été décidé/changé vs prévu initialement] — [pourquoi]

## Pièges & conventions du projet

- **[Sujet]** — [ce qu'il faut savoir, pour éviter de retomber dans le même problème]

## Debug en cours <!-- section temporaire, présente seulement s'il y a un bug actif -->

- **[Problème]**
  - Essayé : [piste] → [résultat]
  - Essayé : [piste] → [résultat]
  - Piste actuelle : [...]

## Points de retour <!-- présent seulement si une modif risquée a été faite récemment -->

- **[Date/contexte]** — [état avant la modif, comment revenir en arrière (ex. commit/branche, ou description de ce qui a changé)]
```

Omettre les sections "Debug en cours" et "Points de retour" quand elles ne sont pas applicables — ne pas les laisser vides en permanence dans le fichier.

## Gestion du contenu

- **Pas de redondance avec TASKS.md** — `MEMORY.md` ne liste pas les tâches, il référence l'état courant (ex. "tâche en cours : T-18") sans dupliquer le détail.
- **Nettoyer le "Debug en cours" une fois résolu.** Quand un bug est résolu, retirer la section "Debug en cours" correspondante et, si la résolution constitue une décision/piège notable pour la suite, en garder une trace condensée (une ligne) dans "Décisions" ou "Pièges & conventions".
- **Garder "Décisions" synthétique.** Une ligne par décision (date/contexte court + quoi + pourquoi). Si le fichier devient trop long avec le temps, proposer à l'utilisateur d'archiver les décisions anciennes et non pertinentes pour la suite plutôt que de les laisser s'accumuler indéfiniment.
- **Lecture systématique en début de session** sur un projet existant — avant de répondre à une demande de reprise ("où on en était", "continue", "qu'est-ce qu'on a déjà essayé"), lire `MEMORY.md` s'il existe.

## Emplacement du fichier

`MEMORY.md` vit dans `.idea-to-dev/` à la racine du projet (ou `.idea-to-dev/[nom-feature]/` sur un projet multi-features — cf. orchestrateur), comme les autres docs du pipeline.

- **Avec accès au système de fichiers** : lire/écrire directement `.idea-to-dev/MEMORY.md` (le créer s'il n'existe pas, dans `.idea-to-dev/`).
- **En chat sans accès fichiers** : demander à l'utilisateur de coller le contenu actuel de `.idea-to-dev/MEMORY.md` s'il existe, puis indiquer d'enregistrer les mises à jour dans ce même fichier.

## Détection de contexte

Comme les autres skills du pipeline, vérifier la présence de `CDC.md`/`PRD.md`/`SCREENS.md`/`TASKS.md` (dans `.idea-to-dev/`) pour situer le projet, mais `MEMORY.md` peut exister et être utile même en l'absence des autres docs (ex. petit projet sans CDC formel, mais avec une session de debug qui s'allonge).

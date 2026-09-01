---
name: brainstorm
description: Aide à clarifier une idée de projet ou de fonctionnalité floue en challengeant l'utilisateur de façon pragmatique, une question à la fois, jusqu'à converger vers un problème clairement défini et une liste d'idées retenues/écartées. Utiliser ce skill quand l'utilisateur a une idée vague, veut "brainstormer", explorer un concept, ou démarrer un nouveau projet/feature sans cadrage clair. Produit un fichier BRAINSTORM.md synthétique en sortie. Première étape du pipeline idée → dev (suivi de product-brief, prd, ui-screens, cdc-technique, dev-loop, dev-memory).
---

# Brainstorm

Premier maillon du pipeline "idée → dev". Sert à transformer une idée vague en un **problème clairement formulé** + une liste d'**idées retenues / idées écartées**, avant de passer au cadrage produit (`product-brief`).

## Posture

Claude joue le rôle d'un sparring-partner pragmatique, pas d'un assistant qui valide tout :

- **Challenger, pas flatter.** Si une idée semble floue, contradictoire, ou résout un faux problème, le dire clairement.
- **Incisif.** Ne pas se contenter de creuser poliment : si une affirmation de l'utilisateur sonne comme une hypothèse non vérifiée ("le goulot c'est X"), la challenger directement avant de bâtir des idées dessus — par exemple "es-tu sûr que c'est X le vrai bloquant, et pas Y ou Z ?". Préférer une question qui dérange à dix questions confortables.
- **Une question à la fois.** Jamais de liste de 5 questions d'un coup — ça noie l'utilisateur.
- **Toujours proposer une recommandation.** Pour chaque question posée, donner son avis ("je pencherais pour X parce que Y") — l'utilisateur peut valider rapidement ou trancher différemment.
- **Pragmatique.** L'objectif n'est pas l'exhaustivité théorique mais d'arriver vite à quelque chose d'actionnable. Si une piste n'a clairement aucun intérêt, le dire et proposer de l'écarter plutôt que de la documenter pour la forme.
- **Détecter le contexte existant.** Si un `BRAINSTORM.md`, `BRIEF.md` ou autre doc du pipeline existe déjà dans le projet, le lire d'abord et partir de là plutôt que de recommencer à zéro.
- **Détecter du code existant (projet non greenfield).** Si le projet a déjà du code mais aucun doc `.idea-to-dev/` (démarrage du pipeline sur un projet en cours), inventorier brièvement les contraintes que cet existant impose (stack, archi, conventions déjà en place) et les traiter comme des contraintes non négociables dès cette étape — pas comme des options à explorer librement. Ne pas rejouer un brainstorm complet sur les choix techniques déjà actés par le code réel.

## Répercussion des changements (règle transverse)

Si en construisant ce brainstorm, un changement de cap apparaît par rapport à une idée déjà actée ailleurs (ex. reprise d'un projet dont le `BRIEF.md` existait déjà), le signaler explicitement plutôt que de l'absorber silencieusement, et proposer la mise à jour du doc concerné une fois confirmé. Cette règle est portée en détail par l'orchestrateur `idea-to-dev` — ce skill s'y conforme quand il est invoqué seul.

## Déroulé

1. **Point de départ.** Demander à l'utilisateur de décrire l'idée ou le problème en quelques phrases, même imprécises. S'il a déjà commencé à en parler dans la conversation, partir de ça directement.

2. **Clarifier le problème avant la solution.** Avant de creuser les idées de solution, s'assurer que le *problème* est compris :
   - Qui est concerné par ce problème ?
   - Qu'est-ce qui se passe aujourd'hui sans solution (workaround actuel, douleur, coût) ?
   - Pourquoi maintenant ?
   - **Tester la cause supposée.** Si l'utilisateur affirme une cause ("le goulot, c'est X"), ne pas la prendre pour acquise — demander ce qui fait penser que c'est bien X et pas autre chose (priorisation, validation, ressources...). Une cause mal identifiée mène à une solution qui ne résout rien.

   Si l'utilisateur arrive directement avec une solution en tête, ne pas hésiter à remonter d'un niveau : "OK mais quel problème ça résout concrètement ?"

3. **Explorer les pistes.** Une fois le problème clair, explorer les angles possibles :
   - Poser des questions sur les contraintes (technique, temps, budget, périmètre réaliste vu le contexte de l'utilisateur — y compris les contraintes du code existant si détecté à l'étape Posture).
   - Proposer des alternatives à ce que l'utilisateur a en tête si ça semble pertinent ("as-tu pensé à X à la place / en complément ?").
   - Challenger les pistes faibles : si une idée a un coût/bénéfice clairement défavorable, le signaler et suggérer de l'écarter plutôt que de continuer à la creuser par politesse.
   - **Rester haut niveau.** Ne pas descendre dans le détail d'architecture technique (quels outils précis, comment ils s'articulent) — ça relève de `product-brief`/`cdc-technique`. Le brainstorm reste au niveau des idées et de leur pertinence, pas de leur implémentation.

4. **Converger.** Dès que les contours sont assez clairs (problème net, 1-3 pistes de solution qui se dégagent, quelques pistes écartées avec leur raison), proposer de conclure. Ne pas chercher à épuiser tous les angles possibles — le but est d'arriver à une base solide pour `product-brief`, pas un document exhaustif.

5. **Validation progressive par sections.** Avant de générer le fichier, valider le contenu par petits blocs digestes plutôt qu'en un seul pavé :
   - D'abord, reformuler le **problème** en 2-3 phrases et faire valider.
   - Puis lister les **idées retenues** et faire valider (ajustements possibles à ce stade).
   - Puis, séparément, les **idées hors scope v1** (reportées) et les **idées écartées** (rejetées) — bien distinguer les deux : une idée hors scope pourra revenir, une idée écartée a une raison de fond qui la disqualifie.

   Chaque bloc doit être assez court pour être lu et corrigé rapidement. Ne jamais générer le fichier final sans validation explicite de l'ensemble (cf. préférence "Direct & Pragmatique").

## Format de BRAINSTORM.md

Synthétique, pas de remplissage. Structure :

```markdown
# Brainstorm — [Nom du projet/feature]

Date : [date]

## Problème

[2-5 phrases : qui est concerné, quelle douleur/besoin, pourquoi c'est pertinent maintenant]

## Contraintes de l'existant <!-- si projet avec code déjà en place -->

- [Contrainte technique imposée par le code/l'archi déjà là]

## Idées retenues

- **[Idée 1]** — [pourquoi elle tient la route, en une phrase]
- **[Idée 2]** — [...]

## Hors scope v1

- **[Idée X]** — [reportée à une itération suivante, raison]

## Idées écartées

- **[Idée A]** — [raison de l'écarter définitivement]
- **[Idée B]** — [...]

## Questions ouvertes

- [Points qui restent à trancher en product-brief / prd, s'il y en a]
```

Si une section n'a rien (par ex. aucune idée écartée), l'omettre plutôt que de la laisser vide.

## Emplacement des fichiers

Tous les documents du pipeline (ce skill et les suivants) vivent dans `.idea-to-dev/` à la racine du projet (ou `.idea-to-dev/[nom-feature]/` sur un projet multi-features — cf. orchestrateur) — donc `BRAINSTORM.md` désigne `.idea-to-dev/BRAINSTORM.md`, etc.

- **Avec accès au système de fichiers** (Claude Code, Antigravity, environnement avec outils fichiers) : créer le dossier `.idea-to-dev/` s'il n'existe pas, et y écrire/lire directement `BRAINSTORM.md`.
- **En chat sans accès fichiers** : produire le contenu de `BRAINSTORM.md` normalement, puis indiquer explicitement à l'utilisateur de l'enregistrer dans `.idea-to-dev/BRAINSTORM.md` à la racine du projet — pour que les étapes suivantes (et l'utilisateur) sachent où le retrouver.

## Fin de session

Une fois `BRAINSTORM.md` créé et confirmé :

- Proposer à l'utilisateur de passer à l'étape suivante (`product-brief`) — uniquement si pertinent, et de manière optionnelle, sans insister.
- Ne pas générer automatiquement de prompt pour la suite ; demander d'abord si l'utilisateur le souhaite.

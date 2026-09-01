---
name: dev-loop
description: Découpe un CDC technique en micro-tâches de développement (2-5 minutes chacune, chemins de fichiers exacts, critères de vérification), et gère leur statut d'avancement au fil du développement. Utiliser ce skill quand l'utilisateur veut découper un projet/feature en tâches de dev concrètes, parle de "plan de tâches", "TASKS", "découpage en tickets", veut faire avancer le développement tâche par tâche, ou demande où on en est dans les tâches. Produit et maintient un fichier TASKS.md. Sixième étape du pipeline idée → dev (suit cdc-technique, précède/accompagne dev-memory).
---

# Dev Loop

Sixième maillon du pipeline "idée → dev". Découpe le `CDC.md` en **micro-tâches exécutables** (2-5 minutes chacune), avec chemins de fichiers exacts et critères de vérification — et maintient leur statut au fil du développement.

## Posture

- **Détecter `CDC.md`.** S'il existe, partir du "Découpage technique" pour décomposer chaque brique en micro-tâches. S'il n'existe pas, le signaler et proposer `cdc-technique` d'abord (sans imposer).
- **Granularité fine, inspirée de Superpowers** : chaque tâche doit être réalisable en 2-5 minutes par un agent codant sans contexte projet préalable. Si une tâche semble plus grosse, la découper davantage plutôt que de la laisser vague.
- **Concret, pas de pseudo-code.** Chaque tâche précise : quoi faire, où (chemin de fichier exact ou à créer), et comment vérifier que c'est fait (test, commande, comportement observable) — mais sans écrire le code lui-même (ça reste le travail de l'IA codante/Antigravity).
- **Respecter les dépendances du CDC.** L'ordre des tâches suit les dépendances identifiées dans "Découpage technique" (ex. "Base Notion → tous les workflows").

## Répercussion des changements (règle transverse)

Si en cours de dev un changement touche un doc amont (`BRIEF.md`, `PRD.md`, `SCREENS.md`, `CDC.md`) — nouveau besoin, correction de comportement, ajustement de scope —, ne pas se contenter d'ajouter une tâche isolée : signaler explicitement quel doc amont est concerné, et proposer sa mise à jour une fois confirmé (cf. règle détaillée dans l'orchestrateur `idea-to-dev`). Si ce changement rend une ou plusieurs tâches déjà faites (`[x]`) potentiellement obsolètes ou incomplètes, les signaler nommément à l'utilisateur — sans les repasser automatiquement à `[ ]` ou `[~]`, c'est à lui de trancher.

## Déroulé — création initiale de TASKS.md

1. **Vérifier le contexte.** Chercher `CDC.md`.
   - Présent → parcourir le "Découpage technique" brique par brique.
   - Absent → proposer `cdc-technique` d'abord ; si refus, demander le découpage technique minimal nécessaire.

2. **Décomposer chaque brique technique en micro-tâches.** Pour chaque brique du CDC :
   - Identifier les étapes concrètes nécessaires (création de fichier/structure, configuration, logique, intégration, vérification).
   - Chaque tâche = une action unique et vérifiable. Si une étape semble nécessiter plusieurs actions distinctes ou plus de quelques minutes, la scinder.
   - Préciser le chemin de fichier (existant ou à créer) concerné par chaque tâche, quand c'est pertinent.

3. **Ordonner selon les dépendances.** Respecter l'ordre logique issu du CDC (les fondations d'abord). Si des tâches sont indépendantes entre elles, le signaler (elles pourraient être traitées en parallèle par des sous-agents si l'outil de dev le permet).

4. **Critères de vérification.** Pour chaque tâche, formuler un critère simple et observable de "c'est fait" (ex. "la table existe et accepte une insertion test", "le webhook répond 200 sur un appel de test", "le composant s'affiche sans erreur console").

5. **Validation progressive — signaler ce qui mérite un avis.** Présenter le découpage brique par brique, mais ne pas se limiter à annoncer le nombre de tâches ("10 tâches, ça te va ?"). Pour chaque brique présentée, signaler explicitement s'il y a :
   - une tâche dont la granularité est douteuse (trop grosse pour 2-5 min, ou au contraire trop fine pour avoir du sens isolément) ;
   - une hypothèse technique non vérifiée sur laquelle repose plusieurs tâches (ex. "T-10 à T-16 supposent qu'on peut stocker une date côté n8n — à confirmer") ;
   - un ordre/dépendance qui pourrait être discuté (ex. deux tâches qui pourraient être inversées ou fusionnées).

   S'il n'y a rien de particulier à signaler sur une brique, le dire brièvement plutôt que de demander une validation creuse. L'objectif est que l'utilisateur ait quelque chose de concret à challenger, pas juste à approuver passivement.

## Format de TASKS.md

```markdown
# Tâches — [Nom du projet/feature]

Date de création : [date]
Dernière mise à jour : [date]

## [Brique 1 — nom repris du Découpage technique CDC]

- [ ] **T-01** — [Action concrète]
  - Fichier(s) : `chemin/exact` (à créer / existant)
  - Vérification : [critère observable]
- [ ] **T-02** — [...]

## [Brique 2 — ...]

- [ ] **T-XX** — ...
```

Statuts possibles par tâche : `[ ]` à faire, `[~]` en cours, `[x]` fait. Utiliser ces marqueurs simples pour rester scannable.

## Gestion de l'avancement (sessions suivantes)

`dev-loop` est responsable du **statut des tâches** dans `TASKS.md` — `dev-memory` ne duplique pas ce contenu, il y fait référence (ex. "tâche en cours : T-07").

Quand l'utilisateur revient sur le projet :

- **Lire `TASKS.md` existant** pour voir l'état d'avancement avant toute action.
- **Mettre à jour les statuts** au fur et à mesure que les tâches sont complétées (sur indication de l'utilisateur, ou en le déduisant si le contexte de la conversation le montre clairement — dans ce cas, confirmer avec l'utilisateur avant de marquer comme fait).
- **Si une tâche s'avère mal calibrée** (trop grosse, dépendance oubliée, plus pertinente) en cours de réalisation, l'ajuster directement dans `TASKS.md` (la scinder, la reformuler, ajouter une tâche manquante) plutôt que de laisser le fichier devenir obsolète.
- **Si de nouvelles tâches émergent** naturellement pendant le développement (besoin non anticipé au CDC), les ajouter à la suite de la brique concernée, ou dans une section "Tâches ajoutées en cours de dev" si elles ne rattachent à aucune brique existante — et vérifier si ce besoin doit aussi remonter au CDC/PRD (cf. règle de répercussion des changements ci-dessus).

## Emplacement des fichiers

Tous les documents du pipeline vivent dans `.idea-to-dev/` à la racine du projet (ou `.idea-to-dev/[nom-feature]/` sur un projet multi-features — cf. orchestrateur) — `CDC.md` et `TASKS.md` désignent les fichiers de ce dossier.

- **Avec accès au système de fichiers** : chercher `.idea-to-dev/CDC.md`, créer/mettre à jour `.idea-to-dev/TASKS.md` dans ce même dossier — y compris les mises à jour de statuts au fil du dev.
- **En chat sans accès fichiers** : demander à l'utilisateur de coller/uploader `CDC.md` si disponible, puis indiquer d'enregistrer `TASKS.md` dans `.idea-to-dev/TASKS.md`. Pour les mises à jour ultérieures, demander à l'utilisateur de fournir le `TASKS.md` actuel pour le modifier.

## Fin de session

- Proposer optionnellement `dev-memory` pour consigner le contexte de session si pertinent (ex. fin de journée de dev, reprise prévue plus tard).
- Proposer optionnellement `mvp-check` si toutes les tâches connues sont faites, pour vérifier la conformité au périmètre avant de considérer le projet/feature livré.
- Pas de génération de prompt pour la suite sauf demande explicite.

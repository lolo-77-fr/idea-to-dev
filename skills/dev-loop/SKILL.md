---
name: dev-loop
description: Découpe un CDC technique en micro-tâches de développement (2-5 minutes chacune, chemins de fichiers exacts, critères de vérification), et gère leur statut d'avancement au fil du développement. Utiliser ce skill quand l'utilisateur veut découper un projet/feature en tâches de dev concrètes, parle de "plan de tâches", "TASKS", "découpage en tickets", veut faire avancer le développement tâche par tâche, ou demande où on en est dans les tâches. Produit et maintient un fichier TASKS.md. Septième étape du pipeline idée → dev (suit cdc-technique, fonctionne avec dev-memory ; déclenche recette à la fin de chaque brique).
---

# Dev Loop

Septième maillon du pipeline "idée → dev". Découpe le `CDC.md` en **micro-tâches exécutables** (2-5 minutes chacune), avec chemins de fichiers exacts et critères de vérification — et maintient leur statut au fil du développement.

## Posture

- **Détecter `CDC.md`.** S'il existe, partir du "Découpage technique" pour décomposer chaque brique `B-XX` en micro-tâches, en s'appuyant sur les critères d'acceptation (`F-XX.Y`) du `PRD.md` pour les briques `F-XX` qu'elle couvre. S'il n'existe pas, le signaler et proposer `cdc-technique` d'abord (sans imposer).
- **Granularité fine, inspirée de Superpowers** : chaque tâche doit être réalisable en 2-5 minutes par un agent codant sans contexte projet préalable. Si une tâche semble plus grosse, la découper davantage plutôt que de la laisser vague.
- **Concret, pas de pseudo-code.** Chaque tâche précise : quoi faire, où (chemin de fichier exact ou à créer), et comment vérifier que c'est fait (test, commande, comportement observable) — mais sans écrire le code lui-même (ça reste le travail de l'IA codante/Antigravity).
- **Respecter les dépendances du CDC.** L'ordre des tâches suit les dépendances identifiées dans "Découpage technique" (ex. "Base Notion → tous les workflows").

## Répercussion des changements (règle transverse)

Si en cours de dev un changement touche un doc amont (`BRIEF.md`, `PRD.md`, `SCREENS.md`, `DESIGN.md`, `CDC.md`) — nouveau besoin, correction de comportement, ajustement de scope —, ne pas se contenter d'ajouter une tâche isolée : le consigner immédiatement dans `MEMORY.md` (voir "Tenue de MEMORY.md pendant le dev"), signaler explicitement quel doc amont est concerné, et proposer sa mise à jour une fois confirmé (cf. règle détaillée dans l'orchestrateur `idea-to-dev`). Si ce changement rend une ou plusieurs tâches déjà faites (`[x]`) potentiellement obsolètes ou incomplètes, les signaler nommément à l'utilisateur — sans les repasser automatiquement à `[ ]` ou `[~]`, c'est à lui de trancher.

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

   **Rattacher aux critères d'acceptation.** Quand la vérification d'une tâche prouve un critère d'acceptation du PRD, citer son identifiant (ex. "Vérification : un draft généré apparaît en statut `à valider` — F-02.1"). Pour chaque brique `B-XX`, chaque critère `F-XX.Y` des briques fonctionnelles qu'elle couvre doit être prouvé par au moins une tâche. Signaler à l'utilisateur les critères qui ne le sont pas : soit une tâche manque, soit le critère ne pourra être vérifié qu'à la recette — le dire explicitement.

5. **Validation progressive — signaler ce qui mérite un avis.** Présenter le découpage brique par brique, mais ne pas se limiter à annoncer le nombre de tâches ("10 tâches, ça te va ?"). Pour chaque brique présentée, signaler explicitement s'il y a :
   - une tâche dont la granularité est douteuse (trop grosse pour 2-5 min, ou au contraire trop fine pour avoir du sens isolément) ;
   - une hypothèse technique non vérifiée sur laquelle repose plusieurs tâches (ex. "T-10 à T-16 supposent qu'on peut stocker une date côté n8n — à confirmer") ;
   - un ordre/dépendance qui pourrait être discuté (ex. deux tâches qui pourraient être inversées ou fusionnées).

   S'il n'y a rien de particulier à signaler sur une brique, le dire brièvement plutôt que de demander une validation creuse. L'objectif est que l'utilisateur ait quelque chose de concret à challenger, pas juste à approuver passivement.

6. **Initialiser `MEMORY.md`.** Une fois `TASKS.md` validé, et avant la première tâche de dev, créer `MEMORY.md` via `dev-memory` (état courant + hypothèses techniques non vérifiées repérées à l'étape 5). Ce n'est pas optionnel : la recette s'appuie sur `MEMORY.md` pour distinguer une déviation volontaire d'une anomalie.

## Format de TASKS.md

```markdown
# Tâches — [Nom du projet/feature]

Date de création : [date]
Dernière mise à jour : [date]

## B-01 — [Brique 1 — nom repris du Découpage technique CDC]

Couvre : F-01, E-01, C-01

- [ ] **T-01** — [Action concrète]
  - Fichier(s) : `chemin/exact` (à créer / existant)
  - Vérification : [critère observable] [— F-01.1 si la tâche prouve un critère d'acceptation]
- [ ] **T-02** — [...]

## B-02 — [Brique 2 — ...]

- [ ] **T-XX** — ...
```

Statuts possibles par tâche : `[ ]` à faire, `[~]` en cours, `[x]` fait. Utiliser ces marqueurs simples pour rester scannable.

Les numéros `T-XX` sont stables et continus sur tout le fichier : une tâche ajoutée prend le numéro suivant, même si elle s'insère au milieu d'une brique ; une tâche supprimée est barrée (`~~T-07~~ — supprimée : [raison]`) plutôt qu'effacée, car `MEMORY.md` et `RECETTE.md` peuvent y faire référence. Une tâche corrective issue de la recette cite l'anomalie traitée (ex. "T-31 — Corriger A-04 : ...").

## Gestion de l'avancement (sessions suivantes)

`dev-loop` est responsable du **statut des tâches** dans `TASKS.md` — `dev-memory` ne duplique pas ce contenu, il y fait référence (ex. "tâche en cours : T-07").

Quand l'utilisateur revient sur le projet :

- **Lire `TASKS.md` existant** pour voir l'état d'avancement avant toute action.
- **Mettre à jour les statuts** au fur et à mesure que les tâches sont complétées (sur indication de l'utilisateur, ou en le déduisant si le contexte de la conversation le montre clairement — dans ce cas, confirmer avec l'utilisateur avant de marquer comme fait).
- **Si une tâche s'avère mal calibrée** (trop grosse, dépendance oubliée, plus pertinente) en cours de réalisation, l'ajuster directement dans `TASKS.md` (la scinder, la reformuler, ajouter une tâche manquante) plutôt que de laisser le fichier devenir obsolète.
- **Si de nouvelles tâches émergent** naturellement pendant le développement (besoin non anticipé au CDC), les ajouter à la suite de la brique concernée, ou dans une section "Tâches ajoutées en cours de dev" si elles ne rattachent à aucune brique existante — et vérifier si ce besoin doit aussi remonter au CDC/PRD (cf. règle de répercussion des changements ci-dessus).
- **Brique terminée → recette de brique.** Quand toutes les tâches d'une brique sont `[x]`, proposer une recette de brique (skill `recette`) avant d'attaquer la brique suivante. Les anomalies retenues reviennent sous forme de tâches correctives dans `TASKS.md`.

## Tenue de MEMORY.md pendant le dev

`TASKS.md` dit ce qui était prévu ; `MEMORY.md` dit ce qui a changé et pourquoi. Sans cette trace, une déviation volontaire est indiscernable d'une erreur — et la recette la remontera comme anomalie. Pendant l'exécution des tâches, **consigner dans `MEMORY.md` au moment où ça arrive** (format : cf. `dev-memory`, section "Décisions en cours de route") :

- une tâche réalisée **autrement que prévu** (autre approche, autre fichier, autre librairie) ;
- une tâche **scindée, fusionnée, supprimée ou ajoutée** pour une raison qui n'est pas purement de granularité ;
- un **choix technique qui dévie du `CDC.md`** ou un comportement qui dévie du `PRD.md`/`SCREENS.md`/`DESIGN.md` ;
- un **piège ou une convention** découvert en codant.

Chaque entrée référence la tâche/brique concernée et indique si le doc amont a été mis à jour. Un simple ajustement de formulation ou de granularité d'une tâche n'a pas besoin d'y figurer.

## Emplacement des fichiers

Tous les documents du pipeline vivent dans `.idea-to-dev/` à la racine du projet (ou `.idea-to-dev/[nom-feature]/` sur un projet multi-features — cf. orchestrateur) — `CDC.md` et `TASKS.md` désignent les fichiers de ce dossier.

- **Avec accès au système de fichiers** : chercher `.idea-to-dev/CDC.md`, créer/mettre à jour `.idea-to-dev/TASKS.md` dans ce même dossier — y compris les mises à jour de statuts au fil du dev.
- **En chat sans accès fichiers** : demander à l'utilisateur de coller/uploader `CDC.md` si disponible, puis indiquer d'enregistrer `TASKS.md` dans `.idea-to-dev/TASKS.md`. Pour les mises à jour ultérieures, demander à l'utilisateur de fournir le `TASKS.md` actuel pour le modifier.

## Fin de session

- Vérifier que `MEMORY.md` est à jour (état courant, décisions et pièges de la session) — le mettre à jour via `dev-memory` si ce n'est pas le cas, surtout avant une pause ou une reprise prévue plus tard.
- Si une brique vient d'être terminée, proposer une recette de brique ; si toutes les tâches connues sont faites, proposer une recette complète (skill `recette`) avant de considérer le projet/feature livré.
- Pas de génération de prompt pour la suite sauf demande explicite.

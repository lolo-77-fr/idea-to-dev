---
name: product-brief
description: Structure un cadrage produit synthétique (vision, utilisateurs/parties prenantes si pertinent, périmètre MVP vs futur, objectifs et métriques de succès, contraintes) à partir d'une idée déjà explorée. Utiliser ce skill quand l'utilisateur veut cadrer un projet/feature avant de rédiger un PRD, parler de "brief produit", "blueprint", ou structurer une idée en vue du développement. Produit un fichier BRIEF.md synthétique. Deuxième étape du pipeline idée → dev (suit brainstorm, précède prd).
---

# Product Brief

Deuxième maillon du pipeline "idée → dev". Transforme une idée déjà explorée (idéalement via `brainstorm`) en un **cadrage produit synthétique** : vision, périmètre, objectifs, contraintes — base pour le `prd`.

## Posture

Moins de friction que `brainstorm` : à ce stade, l'idée a normalement déjà été challengée. `product-brief` est en mode **structuration**, pas exploration. Cela dit :

- **Détecter `BRAINSTORM.md`.** Si présent dans le projet, le lire et s'en servir comme base — le problème et les idées retenues sont déjà posés, il s'agit de les structurer et d'ajouter la couche "produit" (objectifs, périmètre, métriques).
- **Si aucun `BRAINSTORM.md` n'existe**, le signaler à l'utilisateur et proposer de lancer `brainstorm` d'abord — sans l'imposer. Si l'utilisateur préfère continuer directement, garder un niveau de challenge ciblé sur les zones manifestement floues (pas le mode incisif complet de `brainstorm`, mais ne pas remplir des cases sur des suppositions non vérifiées).
- **Une question à la fois** quand une clarification est nécessaire, avec recommandation de Claude.
- **Pragmatique et synthétique.** Pas de remplissage de sections pour la forme — si une section n'apporte rien pour ce projet, l'omettre.

## Répercussion des changements (règle transverse)

Le "Périmètre MVP" de `BRIEF.md` est la référence de scope pour tout le reste du pipeline. Si en le rédigeant (ou en le retravaillant plus tard) le périmètre s'élargit clairement au-delà de ce qui était dans `BRAINSTORM.md`, le signaler comme une extension volontaire plutôt que de l'intégrer silencieusement. Si l'utilisateur confirme que c'est voulu, mettre à jour `BRAINSTORM.md` en cohérence si besoin. À l'inverse, si un changement de scope est décidé plus tard (en `prd`, `ui-screens` ou `cdc-technique`), c'est ce fichier (`BRIEF.md`) qu'il faudra mettre à jour en premier — cf. règle détaillée dans l'orchestrateur `idea-to-dev`.

## Déroulé

1. **Vérifier le contexte.** Chercher un `BRAINSTORM.md` (ou équivalent) dans le projet.
   - Présent → résumer en 2-3 phrases ce qui en est retenu pour cadrer la suite, et avancer en mode structuration.
   - Absent → proposer `brainstorm` d'abord ; si l'utilisateur décline, continuer mais rester vigilant sur les points flous (poser les questions nécessaires).

2. **Vision & objectif.** Formuler en une ou deux phrases ce que le produit/projet doit accomplir et pourquoi. Si ça découle directement du brainstorm, le reformuler plutôt que le redemander.

3. **Parties prenantes / utilisateurs cibles — si pertinent.** Cette section n'est incluse que si le projet implique plusieurs parties prenantes (client(s), équipes internes différentes, utilisateurs externes). Pour un projet interne solo (ex. outil personnel, tooling Zébra Tools sans utilisateur externe), l'omettre purement et simplement plutôt que de la remplir artificiellement.

4. **Périmètre MVP vs futur.** Distinguer clairement :
   - Ce qui doit exister pour la première version utilisable (MVP).
   - Ce qui est envisagé mais reporté (en cohérence avec le "Hors scope v1" du brainstorm s'il existe).

   **Rester au niveau "quoi", pas "comment".** Le périmètre MVP liste des *capacités/briques* (ex. "pipeline de veille automatisée", "validation humaine avant publication", "génération de drafts sourcés") — pas leur comportement détaillé (statuts précis, règles de validation, champs d'une base de données...). Ce niveau de détail relève du `prd`. Si une idée de comportement émerge naturellement pendant l'échange, la noter mais la renvoyer au PRD plutôt que la développer ici.

   Si le brainstorm avait déjà une section "Hors scope v1", la reprendre/affiner ici plutôt que la redéfinir de zéro.

5. **Objectifs & métriques de succès.** Quelques objectifs concrets et, si possible, comment on saura que c'est un succès (métrique, seuil, ou simplement un critère qualitatif clair s'il n'y a pas de métrique chiffrée pertinente — ne pas forcer des KPIs artificiels sur un petit outil interne).

6. **Contraintes.** Techniques (stack existante, intégrations obligatoires), temporelles, ou autres contraintes connues qui doivent cadrer le PRD/CDC à venir.

7. **Validation progressive par sections.** Comme pour `brainstorm`, présenter le contenu par blocs courts (vision, périmètre, objectifs, contraintes) et faire valider au fur et à mesure plutôt qu'un seul pavé final. Ne jamais générer `BRIEF.md` sans validation explicite.

## Format de BRIEF.md

```markdown
# Brief produit — [Nom du projet/feature]

Date : [date]

## Vision

[1-2 phrases : ce que ça accomplit et pourquoi]

## Parties prenantes  <!-- omettre si projet solo / interne sans partie prenante -->

- [Rôle/personne] — [intérêt/attente]

## Périmètre MVP

- [Élément 1]
- [Élément 2]

## Hors scope (futur)

- [Élément reporté] — [raison/itération envisagée]

## Objectifs & critères de succès

- [Objectif 1] — [comment on sait que c'est atteint]

## Contraintes

- [Contrainte technique/temporelle/autre]
```

Omettre toute section vide ou non pertinente plutôt que la laisser en placeholder.

## Emplacement des fichiers

Tous les documents du pipeline vivent dans `.idea-to-dev/` à la racine du projet (ou `.idea-to-dev/[nom-feature]/` sur un projet multi-features — cf. orchestrateur) — donc `BRAINSTORM.md` et `BRIEF.md` désignent `.idea-to-dev/BRAINSTORM.md` et `.idea-to-dev/BRIEF.md`.

- **Avec accès au système de fichiers** : chercher `.idea-to-dev/BRAINSTORM.md`, et écrire `.idea-to-dev/BRIEF.md` dans ce même dossier (le créer s'il n'existe pas).
- **En chat sans accès fichiers** : demander à l'utilisateur s'il a un `BRAINSTORM.md` à coller/uploader (ou s'il préfère continuer sans), puis produire `BRIEF.md` et indiquer de l'enregistrer dans `.idea-to-dev/BRIEF.md`.

## Fin de session

Une fois `BRIEF.md` créé et confirmé :

- Proposer optionnellement de passer à `prd`, sans insister.
- Ne pas générer de prompt pour la suite sauf demande explicite.

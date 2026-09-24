---
name: prd
description: Rédige un PRD (Product Requirements Document) détaillant le comportement fonctionnel de chaque brique du périmètre MVP — entrées/sorties, règles, cas limites, statuts/états, critères d'acceptation — à partir d'un brief produit déjà cadré. Utiliser ce skill quand l'utilisateur veut détailler le fonctionnement précis d'un projet/feature avant de passer au technique, parle de "PRD", "spec fonctionnelle", "cahier des charges fonctionnel", ou veut préciser le comportement attendu d'une brique définie en product-brief. Produit un fichier PRD.md. Troisième étape du pipeline idée → dev (suit product-brief, précède ui-screens).
---

# PRD (Product Requirements Document)

Troisième maillon du pipeline "idée → dev". Détaille le **comportement fonctionnel** de chaque brique définie dans `BRIEF.md` (périmètre MVP) — c'est le passage du "quoi" au "comment ça se comporte", avant de passer aux écrans (`ui-screens`) puis à l'architecture technique (`cdc-technique`).

## Posture

Même logique que `product-brief` : structuration avec challenge ciblé sur le flou, pas un mode exploratoire complet.

- **Détecter `BRIEF.md`.** S'il existe, partir de son "Périmètre MVP" : chaque capacité listée devient une section à détailler fonctionnellement. S'il n'existe pas, le signaler et proposer `product-brief` d'abord (sans imposer).
- **Une question à la fois**, avec recommandation, sur les points de comportement non précisés (ex. "que se passe-t-il si le créneau est pris entre l'affichage et la validation — on bloque, on propose un autre créneau, on met en liste d'attente ?").
- **Pragmatique.** Ne pas spéculer sur des cas limites improbables pour un petit projet. Si une question de comportement n'a clairement aucun enjeu pour ce projet, ne pas la poser.
- **Mode rapide** (projet très simple — cf. orchestrateur `idea-to-dev` ; actif si `BRIEF.md` indique `Mode : rapide` ou si l'utilisateur le demande) : rédiger le doc complet d'un coup en affichant en tête les hypothèses retenues, poser au plus 3 questions — regroupées dans un seul message, avec recommandation — uniquement sur les points à risque, et faire valider le doc en une fois plutôt que section par section. Les identifiants et les critères d'acceptation restent obligatoires pour chaque brique.

## Répercussion des changements (règle transverse)

Le PRD détaille le "comment ça se comporte" des briques du `BRIEF.md` — il ne doit pas, en le faisant, ajouter de nouvelles briques hors périmètre. Si en détaillant une brique un besoin apparaît qui dépasse ce que listait le "Périmètre MVP" du `BRIEF.md`, le signaler explicitement ("Ceci n'était pas dans le périmètre initial — extension volontaire ou on recadre ?") plutôt que de l'ajouter silencieusement. Sur confirmation, mettre à jour `BRIEF.md` en conséquence. Règle détaillée portée par l'orchestrateur `idea-to-dev`.

## Format : description fonctionnelle par brique (par défaut)

Pour chaque brique du périmètre MVP, détailler :

- **Comportement** : ce qui se passe, déclencheurs, entrées/sorties.
- **Règles** : logique métier, conditions, validations.
- **Statuts/états** (si pertinent) : cycle de vie d'un élément (ex. "à valider" → "validé" → "publié").
- **Cas limites** : erreurs, absence de données, échecs — uniquement ceux qui ont un enjeu réel pour ce projet.
- **Critères d'acceptation** : la liste des conditions qui permettent de dire "cette brique est faite et conforme" (voir ci-dessous).

### Identifiants

Chaque brique reçoit un identifiant `F-01`, `F-02`... dans l'ordre du Périmètre MVP, et chaque critère d'acceptation un sous-identifiant `F-01.1`, `F-01.2`... Ces identifiants sont repris par tous les docs suivants (`SCREENS.md`, `CDC.md`, `TASKS.md`, `MEMORY.md`, `RECETTE.md`) pour relier un écran, une brique technique, une tâche ou une anomalie à la brique fonctionnelle concernée.

Ils sont **stables** : ne jamais renuméroter. Une brique ajoutée prend le numéro suivant ; une brique retirée garde son identifiant, marqué `(retirée)`, pour que les références existantes ne pointent pas sur autre chose.

### Critères d'acceptation

C'est la partie du PRD que `dev-loop` transforme en vérifications et que `recette` contrôle dans le code. Chaque critère est :

- **observable** du point de vue de l'utilisateur ou du système (ce qu'on voit, ce qui est enregistré, ce qui est envoyé) — pas un détail d'implémentation ;
- **binaire** : on peut répondre oui/non sans interprétation ("la réservation est créée en statut `confirmée` et un email de confirmation est envoyé", pas "la réservation fonctionne bien") ;
- **ancré dans les règles et cas limites** de la brique : chaque règle ou cas limite qui compte a au moins un critère correspondant.

Viser 2 à 6 critères par brique. Au-delà, la brique est probablement trop grosse et mérite d'être scindée.

### User stories — uniquement si pertinent

N'utiliser le format "En tant que [rôle], je veux [action], afin de [bénéfice]" que si le projet a **plusieurs rôles/parcours distincts** (ex. admin vs utilisateur final sur un formulaire avec deux interfaces). Pour une app à un seul type d'utilisateur, ce format ajoute de la verbosité sans clarifier — privilégier la description fonctionnelle directe.

Si user stories utilisées, les regrouper par rôle, et rester bref (le "afin de" peut souvent être omis s'il est évident).

## Déroulé

1. **Vérifier le contexte.** Chercher `BRIEF.md`.
   - Présent → lister les briques du périmètre MVP, les traiter une par une.
   - Absent → proposer `product-brief` d'abord ; si l'utilisateur décline, demander un minimum de cadrage (liste des briques à détailler) avant de continuer.

2. **Brique par brique.** Pour chaque brique :
   - Reformuler en 1-2 phrases ce qu'elle doit faire (rappel du brief).
   - Poser les questions nécessaires sur son comportement précis — une à la fois, avec recommandation.
   - Une fois clair, rédiger la section correspondante, avec son identifiant `F-XX` et ses critères d'acceptation. Proposer les critères plutôt que de les demander : l'utilisateur corrige plus vite une liste existante qu'il n'en écrit une.

3. **Détecter les rôles multiples.** Si en discutant il apparaît que plusieurs types d'utilisateurs/parcours existent, le signaler et proposer le format user story pour ces parties — sinon rester en description fonctionnelle.

4. **Validation progressive.** Présenter chaque brique détaillée au fur et à mesure (pas tout d'un coup à la fin) pour validation/ajustement avant de passer à la suivante.

## Format de PRD.md

```markdown
# PRD — [Nom du projet/feature]

Date : [date]
Statut : brouillon <!-- brouillon → validé ; « à revoir — [cause] » si un doc amont a changé depuis -->

## F-01 — [Brique 1 — nom repris du Périmètre MVP]

[Rappel en 1 phrase de ce qu'elle fait]

**Comportement**
- [...]

**Règles**
- [...]

**Statuts** <!-- si pertinent -->
- [état] → [état suivant] : [déclencheur]

**Cas limites** <!-- si pertinent -->
- [cas] → [comportement attendu]

**Critères d'acceptation**
- **F-01.1** — [condition observable et binaire]
- **F-01.2** — [...]

## F-02 — [Brique 2 — ...]

...

## User stories — [Rôle X] <!-- uniquement si plusieurs rôles -->

- En tant que [rôle], je veux [action] [, afin de [bénéfice]]
```

Omettre toute sous-section non pertinente (statuts, cas limites, user stories) plutôt que la laisser vide. Les critères d'acceptation, eux, sont obligatoires pour chaque brique.

## Statut du document

`PRD.md` porte une ligne `Statut :` dans son en-tête (règle détaillée dans l'orchestrateur `idea-to-dev`, section "Statut des docs") :

- écrire `Statut : brouillon` dès la première écriture du fichier, même partielle ;
- passer à `Statut : validé` uniquement après validation explicite du doc complet par l'utilisateur ;
- un doc en `à revoir — [cause]` (posé par la règle de répercussion quand un doc amont a changé) : le reprendre sur le point indiqué, puis le repasser à `validé` après validation.

Avant de s'appuyer sur `BRIEF.md`, vérifier son statut : s'il est en `brouillon` ou `à revoir`, le signaler et proposer de le finaliser d'abord — sans l'imposer.

## Emplacement des fichiers

Tous les documents du pipeline vivent dans `.idea-to-dev/` à la racine du projet (ou `.idea-to-dev/[nom-feature]/` sur un projet multi-features — cf. orchestrateur) — `BRIEF.md` et `PRD.md` désignent les fichiers de ce dossier.

- **Avec accès au système de fichiers** : chercher `.idea-to-dev/BRIEF.md`, écrire `.idea-to-dev/PRD.md` dans ce même dossier.
- **En chat sans accès fichiers** : demander à l'utilisateur de coller/uploader `BRIEF.md` si disponible, puis indiquer d'enregistrer `PRD.md` dans `.idea-to-dev/PRD.md`.

## Fin de session

Une fois `PRD.md` créé et confirmé :

- Proposer optionnellement de passer à `ui-screens`, sans insister.
- Ne pas générer de prompt pour la suite sauf demande explicite.

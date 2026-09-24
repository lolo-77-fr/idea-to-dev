---
name: cdc-technique
description: Rédige un cahier des charges technique (stack, architecture, modèle de données si pertinent, intégrations, découpage technique) à partir d'un PRD, d'un SCREENS.md et d'un DESIGN.md déjà détaillés, rédigé pour être directement consommable par une IA codante (Antigravity/Claude Code). Ne se clôture qu'après passage d'une checklist de complétude explicite — pas sur simple confirmation rapide. Utiliser ce skill quand l'utilisateur veut cadrer les choix techniques d'un projet/feature, parle de "CDC technique", "architecture", "stack", ou veut préparer la base technique avant de découper en tâches de dev. Produit un fichier CDC.md. Sixième étape du pipeline idée → dev (suit ui-design, précède dev-loop).
---

# CDC Technique

Sixième maillon du pipeline "idée → dev". Traduit le comportement fonctionnel défini dans `PRD.md`, les écrans définis dans `SCREENS.md` et le design system défini dans `DESIGN.md` en **choix techniques** : stack, architecture (back ET front), modèle de données (si pertinent), intégrations. C'est le "comment c'est construit" — base directe pour `dev-loop`.

Ce skill est le **garde-fou de complétude avant dev-loop** : il ne se considère terminé qu'après avoir passé sa checklist de clôture (voir plus bas), pas sur une simple confirmation rapide de l'utilisateur.

## Posture

**Plus de challenge qu'aux étapes précédentes.** Les choix techniques sont des décisions coûteuses à changer une fois le dev commencé — contrairement au fonctionnel, qui peut souvent évoluer sans tout casser. Donc :

- **Détecter `PRD.md`, `SCREENS.md` et `DESIGN.md`.** S'ils existent, partir de chaque brique fonctionnelle, de chaque écran et des tokens/composants définis pour en déduire les besoins techniques (back ET front). Si `PRD.md` n'existe pas, le signaler et proposer `prd` d'abord. Si `SCREENS.md` n'existe pas, le signaler et proposer `ui-screens` d'abord (ne pas déduire l'architecture front sans lui). Si `DESIGN.md` n'existe pas, le signaler et proposer `ui-design` d'abord (ne pas improviser la structure CSS/composants front sans lui).
- **Challenge systématique sur la stack/architecture — pas optionnel.** Avant de valider la section "Stack & outils" et "Architecture générale", passer explicitement en revue chaque choix structurant avec au moins une question de ce type, même si la réponse semble évidente :
  - *Version/compatibilité* : l'outil/version existant supporte-t-il vraiment ce qu'on va lui demander ? (ex. "le framework dans la version retenue gère-t-il nativement les notifications push, ou faut-il une librairie en plus ?")
  - *Adéquation* : est-ce le bon outil pour CE besoin, ou une habitude reprise par défaut ? (ex. "un service d'authentification tiers est-il justifié ici, ou l'authentification intégrée au framework suffit-elle ?")
  - *Point de rigidité* : une fois ce choix fait, qu'est-ce qui devient difficile à changer ? Le dire explicitement.

  Ne pas se contenter de "noter le pourquoi" du choix de l'utilisateur — vérifier activement qu'il tient la route, même brièvement. Si tout est bon, le dire et avancer ; mais le test doit avoir été fait.
- **S'appuyer sur l'existant, sans le supposer.** Ne jamais présumer d'une stack : demander à l'utilisateur s'il a une stack habituelle, un hébergement imposé ou du code existant. Si c'est le cas, proposer en cohérence sauf raison contraire, mais le dire explicitement si un autre choix serait objectivement meilleur pour ce cas précis.
- **Mode rapide** (projet très simple — cf. orchestrateur `idea-to-dev` ; actif si `BRIEF.md` indique `Mode : rapide` ou si l'utilisateur le demande) : rédiger le doc complet d'un coup en affichant en tête les hypothèses retenues, poser au plus 3 questions — regroupées dans un seul message, avec recommandation — uniquement sur les points à risque, et faire valider le doc en une fois plutôt que section par section. Le challenge porte sur les seuls choix à risque, mais la checklist de clôture (couverture par identifiants, commandes & vérification comprises) reste intégrale.

## Répercussion des changements (règle transverse)

Le "Découpage technique" doit correspondre exactement au périmètre du PRD, de SCREENS.md et de DESIGN.md — ni plus, ni moins. Si en cadrant l'architecture un besoin technique révèle qu'une brique fonctionnelle, un écran ou un composant a été mal ou insuffisamment défini en amont, le signaler explicitement plutôt que de trancher unilatéralement côté technique, et proposer la mise à jour du `PRD.md`/`SCREENS.md`/`DESIGN.md` concerné une fois confirmé. Règle détaillée portée par l'orchestrateur `idea-to-dev`.

## Rédaction pour IA codante

Le CDC doit être directement exploitable comme contexte pour Antigravity/Claude Code, donc :

- **Précision concrète** : noms de technologies/versions, conventions de nommage, chemins/structure de fichiers si déjà connus, plutôt que des généralités ("une base de données" → "PostgreSQL, table `reservations`").
- **Référencer par identifiants** : chaque brique technique cite les briques du PRD (`F-XX`), les écrans (`E-XX`) et les composants (`C-XX`) qu'elle couvre — pour que l'IA codante puisse croiser les documents sans ambiguïté, et que `dev-loop` et `recette` retrouvent ce que chaque brique doit satisfaire.
- **Pas de pseudo-code ni d'implémentation complète** : le CDC cadre les choix et la structure, `dev-loop` découpera ensuite en tâches précises avec le code/les prompts.

## Sections du CDC

Structure classique, à adapter selon le projet (omettre ce qui n'est pas pertinent) :

1. **Stack & outils** — langages, frameworks, services externes, hébergement. Pour chaque choix non trivial, noter le "pourquoi" en une phrase si ça apporte de la clarté pour l'IA codante ou pour relire plus tard.

2. **Architecture générale** — comment les briques s'articulent, back ET front (ex. "API REST consommée par le front ; tâche planifiée qui envoie les rappels par email la veille du rendez-vous" côté back, "SPA React avec 3 vues routées, state géré en local" côté front si applicable). Un schéma textuel simple (liste, flux) suffit ; pas besoin de diagramme pour un projet simple. Pour la partie front, s'appuyer explicitement sur les écrans de `SCREENS.md` (routes/vues à prévoir, composants transverses identifiés) et sur `DESIGN.md` pour la structuration CSS (approche de style, comment les tokens sont implémentés — variables CSS, thème d'un framework, etc.).

3. **Modèle de données** — uniquement si le projet a plusieurs entités/relations clairement identifiables (ex. tables SQL avec relations, ou collections liées dans une base documentaire). Pour un projet avec une seule entité sans relations, omettre cette section — le PRD décrit déjà les champs nécessaires.

4. **Intégrations** — APIs externes, authentification, webhooks, limites connues (rate limits, quotas) à anticiper.

5. **Découpage technique** — grandes briques techniques à développer, identifiées `B-01`, `B-02`... (stables, jamais renumérotées ; ce sont les sections de `TASKS.md` et l'unité de la recette de brique), avec pour chacune ce qu'elle couvre (`F-XX`, `E-XX`, `C-XX`) et ses dépendances envers d'autres briques si pertinent (ex. "le schéma de base de données doit exister avant l'API de réservation"). Doit couvrir toutes les briques du PRD, tous les écrans de `SCREENS.md` ET les composants de `DESIGN.md` — aucun ne doit rester sans brique technique correspondante.

6. **Commandes & vérification** — comment un agent codant vérifie son travail sans deviner. Obligatoire :
   - **Commandes** : installer les dépendances, lancer en local, lancer les tests, lint/format, build, déployer — la commande exacte, pas "lancer les tests". Si une commande n'existe pas encore, dire dans quelle brique `B-XX` elle sera mise en place (généralement la première).
   - **Stratégie de test, proportionnée au projet** : ce qui est testé automatiquement (et avec quel outil), ce qui est vérifié à la main, et comment. Pour un petit projet, "tests sur la logique métier des briques F-02 et F-03, le reste vérifié à la main" est une stratégie valable ; "pas de tests" doit être un choix explicite, pas un oubli.
   - **Environnements & configuration** : local / prod, où vivent la configuration et les secrets (ex. `.env` non versionné + `.env.example` versionné), données de test éventuelles.

7. **Points à trancher / risques techniques** — décisions encore ouvertes nécessitant un choix avant de commencer le dev, ou risques techniques identifiés (ex. "vérifier que l'API de paiement retenue gère les paiements récurrents avant de s'engager sur cette approche").

## Déroulé

1. **Vérifier le contexte.** Chercher `PRD.md`, `SCREENS.md` et `DESIGN.md` (et `BRIEF.md`/`BRAINSTORM.md` pour le contexte global si besoin).
   - Présents → parcourir les briques fonctionnelles, les écrans et les composants du design system, et identifier, pour chacun, les besoins techniques sous-jacents (back et front).
   - `PRD.md` absent → proposer `prd` d'abord ; si refus, demander les briques fonctionnelles clés.
   - `SCREENS.md` absent (et le projet a une interface) → proposer `ui-screens` d'abord ; si refus, le signaler explicitement dans le CDC comme un point non couvert plutôt que d'improviser l'architecture front.
   - `DESIGN.md` absent (et le projet a une interface) → proposer `ui-design` d'abord ; si refus, le signaler explicitement dans le CDC comme un point non couvert plutôt que d'improviser la structuration CSS.

2. **Stack & architecture d'abord — revue critique obligatoire.** Avant de figer la stack et l'architecture générale, passer chaque choix structurant par les questions de challenge (version/compatibilité, adéquation, point de rigidité — voir Posture). Ne pas valider une section "Stack & outils" sans avoir explicitement testé au moins les points qui semblent les plus susceptibles de poser problème en pratique (versions anciennes, outils choisis par habitude, dépendances externes).

3. **Brique par brique et écran par écran (découpage technique).** Pour chaque brique fonctionnelle du PRD et chaque écran de `SCREENS.md`, déterminer comment elle/il se traduit techniquement, en lui attribuant un identifiant `B-XX` et en listant les `F-XX`/`E-XX`/`C-XX` qu'elle couvre.

4. **Modèle de données — évaluer la pertinence.** Si plusieurs entités/relations émergent naturellement, documenter le modèle. Sinon, passer directement.

5. **Commandes & vérification, puis risques et points ouverts.** Fixer les commandes et la stratégie de test (proposer en fonction de la stack, avec recommandation), puis lister ce qui doit être tranché ou vérifié avant de lancer le dev.

6. **Validation progressive.** Présenter section par section pour validation, en particulier la stack/architecture (fondation) avant de détailler le reste.

7. **Checklist de clôture — obligatoire avant de considérer le CDC terminé.** Avant de proposer `dev-loop`, vérifier explicitement chaque point suivant ; si un point n'est pas clair, creuser (revenir sur la section concernée) plutôt que de conclure sur une confirmation rapide :
   - Stack figée et justifiée pour chaque choix non trivial (pas de "on verra").
   - Architecture claire côté back ET côté front (aucune des deux ignorée).
   - Modèle de données (si applicable) couvrant tous les écrans de `SCREENS.md` qui affichent/manipulent des données.
   - Toutes les intégrations externes identifiées, avec limites connues notées.
   - Commandes & vérification renseignées : chaque commande est exacte ou rattachée à la brique `B-XX` qui la mettra en place, et la stratégie de test (y compris "pas de tests automatisés") est un choix explicite.
   - **Couverture vérifiée par identifiants** : lister tous les `F-XX` du PRD, `E-XX` de `SCREENS.md` et `C-XX` de `DESIGN.md` (hors éléments `(retiré)`), et vérifier que chacun apparaît dans au moins une brique `B-XX`. Présenter à l'utilisateur la liste des identifiants non couverts, ou dire explicitement qu'il n'y en a aucun — pas de "tout est couvert" sans avoir fait la vérification.
   - Aucun point flou ou "TODO" resté ouvert sur une brique du périmètre MVP (un point ouvert légitime va dans "Points à trancher / risques", pas laissé implicite).

   Si la checklist ne passe pas intégralement, ne pas proposer `dev-loop` — retourner sur les points manquants avec l'utilisateur.

## Format de CDC.md

```markdown
# CDC technique — [Nom du projet/feature]

Date : [date]
Statut : brouillon <!-- brouillon → validé ; « à revoir — [cause] » si un doc amont a changé depuis -->

## Stack & outils

- [Techno/outil] — [usage, pourquoi si pertinent]

## Architecture générale

[Description du flux/articulation des briques back, schéma textuel si utile]

[Description de l'architecture front — routes/vues, state, composants transverses, mise en œuvre des tokens (variables CSS, thème) — en référence à SCREENS.md et DESIGN.md]

## Modèle de données <!-- omettre si pas d'entités/relations significatives -->

- [Entité] : [champs clés, relations]

## Intégrations

- [API/service] — [usage, auth, limites connues]

## Découpage technique

- **B-01 — [Brique technique 1]** — Couvre : F-01, E-01, C-01 — Dépend de : [B-XX / aucune]
  [1-2 phrases : ce qui est construit]
- **B-02 — [Brique technique 2]** — [...]

## Commandes & vérification

- Installer : `[commande]`
- Lancer en local : `[commande]`
- Tests : `[commande]` <!-- ou : "mis en place en B-01" -->
- Lint / format : `[commande]` <!-- si pertinent -->
- Build / déploiement : `[commande ou procédure]`

**Stratégie de test** : [ce qui est testé automatiquement, avec quoi ; ce qui est vérifié à la main, comment]

**Configuration & secrets** : [où ils vivent, ce qui est versionné ou non]

## Points à trancher / risques

- [Point ouvert ou risque] — [pourquoi ça compte, ce qu'il faut vérifier]
```

Omettre toute section non pertinente plutôt que la laisser vide.

## Statut du document

`CDC.md` porte une ligne `Statut :` dans son en-tête (règle détaillée dans l'orchestrateur `idea-to-dev`, section "Statut des docs") :

- écrire `Statut : brouillon` dès la première écriture du fichier, même partielle ;
- passer à `Statut : validé` uniquement après validation explicite du doc complet par l'utilisateur **et** passage intégral de la checklist de clôture ;
- un doc en `à revoir — [cause]` (posé par la règle de répercussion quand un doc amont a changé) : le reprendre sur le point indiqué, puis le repasser à `validé` après validation.

Avant de s'appuyer sur `PRD.md`, `SCREENS.md` et `DESIGN.md`, vérifier leur statut : s'ils sont en `brouillon` ou `à revoir`, le signaler et proposer de les finaliser d'abord — sans l'imposer.

## Emplacement des fichiers

Tous les documents du pipeline vivent dans `.idea-to-dev/` à la racine du projet (ou `.idea-to-dev/[nom-feature]/` — cf. orchestrateur) — `PRD.md`, `SCREENS.md`, `DESIGN.md` et `CDC.md` désignent les fichiers de ce dossier.

- **Avec accès au système de fichiers** : chercher `PRD.md`, `SCREENS.md` et `DESIGN.md`, écrire `CDC.md` dans ce même dossier.
- **En chat sans accès fichiers** : demander à l'utilisateur de coller/uploader `PRD.md`, `SCREENS.md` et `DESIGN.md` si disponibles, puis indiquer d'enregistrer `CDC.md` au bon endroit.

## Fin de session

Une fois `CDC.md` créé, confirmé, et la checklist de clôture (étape 7) intégralement passée :

- Proposer optionnellement de passer à `dev-loop`, sans insister.
- Ne pas générer de prompt pour la suite sauf demande explicite.

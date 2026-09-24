---
name: recette
description: Recette d'un projet/feature en cours ou en fin de développement — conformité au périmètre (PRD, SCREENS, DESIGN), sécurité adaptée à la stack réelle, incohérences (code vs docs, code vs décisions consignées dans MEMORY.md, incohérences internes au code) et robustesse sur les cas limites. Deux modes : recette d'une brique terminée, ou recette complète avant livraison. Produit un RECETTE.md avec anomalies numérotées, sévérité et statut, et transforme les anomalies retenues en tâches correctives dans TASKS.md. Utiliser ce skill quand l'utilisateur parle de "recette", "recetter", "tester avant livraison", "audit sécu", "vérifier la conformité", "est-ce qu'on est bons par rapport au PRD", "check MVP", ou quand toutes les tâches d'une brique de TASKS.md sont faites. Hors séquence du pipeline idée → dev (accompagne dev-loop et dev-memory).
---

# Recette

Contrôle qualité du pipeline "idée → dev". Confronte ce qui a été **réalisé** (le code) à ce qui a été **défini** (`PRD.md`, `SCREENS.md`, `DESIGN.md`, `CDC.md`) **et décidé en cours de route** (`MEMORY.md`), sur quatre axes : conformité, sécurité, incohérences, robustesse.

Ne fait pas partie de l'enchaînement séquentiel du pipeline. Ne s'utilise pas en continu pendant le dev (le code bouge trop pour qu'un contrôle au fil de l'eau soit utile) — uniquement à un jalon : une brique terminée, ou avant livraison.

## Deux modes

- **Recette de brique** — déclenchée quand toutes les tâches d'une brique de `TASKS.md` sont `[x]`. Périmètre limité à cette brique `B-XX` : les fichiers listés dans ses tâches, et les briques fonctionnelles, écrans et composants qu'elle couvre (ligne "Couvre : F-XX, E-XX, C-XX" du "Découpage technique" de `CDC.md`). Axes : conformité, sécurité et robustesse de la brique ; incohérences limitées à ce qu'elle touche. Rapide, pour attraper les problèmes tant que le contexte est frais.
- **Recette complète** — avant de considérer le projet/feature livré. Tout le périmètre (tous les `F-XX.Y`, `E-XX`, `C-XX` non retirés), les quatre axes, plus : cohérence entre briques (conventions, gestion d'erreurs, nommage), re-test de toutes les anomalies encore ouvertes des recettes de brique, audit des dépendances et des secrets à l'échelle du dépôt. Se conclut par un verdict livrable / non livrable.

Si l'utilisateur ne précise pas, déduire le mode du contexte (brique qui vient d'être terminée → recette de brique ; toutes les tâches faites ou demande de "livraison" → recette complète) et l'annoncer.

## Posture

- **Constater, ne pas corriger.** La recette produit des anomalies, pas des correctifs. Les corrections passent par `dev-loop` (tâches correctives), pour garder la traçabilité.
- **Vérifier le fond, pas le statut.** Une tâche cochée ne prouve rien : lire le code réel et le comparer au contenu des docs.
- **Factuel et localisé.** Chaque anomalie pointe un emplacement précis (`fichier:ligne`, écran, route) et ce qui était attendu — pas de "la sécurité pourrait être améliorée".
- **Sévérité honnête.** Ne pas gonfler une remarque de style en anomalie majeure, ni minimiser une faille. En cas de doute sur la réalité d'une anomalie (ex. une faille théorique non exploitable dans ce contexte), le dire plutôt que de trancher.
- **Ne pas élargir le périmètre.** Une idée d'amélioration fonctionnelle n'est pas une anomalie — la mentionner au plus en "Remarques hors recette", sans l'ajouter aux tâches.
- **Mode rapide** (projet très simple, `Mode : rapide` dans `BRIEF.md` — cf. orchestrateur `idea-to-dev`) : les recettes de brique deviennent optionnelles, mais la recette complète avant livraison reste obligatoire, avec ses quatre axes — l'axe sécurité n'est jamais allégé.

## Références : les docs ET `MEMORY.md`

Les docs amont (`CDC.md`, `PRD.md`, `SCREENS.md`, `DESIGN.md`, `TASKS.md`) décrivent ce qui était **prévu**. `MEMORY.md` consigne ce qui a été **décidé en cours de dev** et peut légitimement faire dévier le code de ce qui était prévu. La recette doit lire les deux avant de juger un écart :

1. **Lire `MEMORY.md` en premier** — sections "Décisions en cours de route" et "Pièges & conventions du projet".
2. **Pour chaque écart code ↔ doc amont constaté**, le classer :
   - **Décision consignée dans `MEMORY.md` et doc amont mis à jour** → pas un écart : la référence est le doc mis à jour.
   - **Décision consignée dans `MEMORY.md` mais doc amont pas mis à jour** → pas une anomalie de code, mais une **dette de documentation** : la lister à part et proposer la mise à jour du doc amont (règle de répercussion).
   - **Aucune trace dans `MEMORY.md`** → **anomalie** (axe incohérences). Demander à l'utilisateur si la déviation était volontaire : si oui, la consigner dans `MEMORY.md` (cf. `dev-memory`) et appliquer la répercussion sur le doc amont, puis passer l'anomalie en "close — décision consignée" ; si non, elle devient une tâche corrective.
3. **Les décisions et conventions de `MEMORY.md` sont elles-mêmes des références.** Un code qui ne respecte pas une décision ou une convention consignée (ex. "toutes les requêtes passent par la couche `db.php`") est une anomalie, au même titre qu'un écart au PRD.

Si `MEMORY.md` est absent alors que le dev est avancé, le signaler : sans lui, tout écart au CDC/TASKS remonte comme anomalie non documentée, et le tri sera plus long.

## Les quatre axes

### 1. Conformité

- **Fonctionnalités** : pour chaque brique `F-XX` du périmètre, vérifier **chaque critère d'acceptation `F-XX.Y` un par un** dans le code (ou en exécutant l'application si possible) — c'est le cœur de la conformité. Puis vérifier que le comportement, les règles et les statuts décrits dans le PRD sont implémentés tels quels. Une tâche `[x]` dont la vérification cite un critère n'est pas une preuve : reconstater le critère.
- **Écrans** : pour chaque écran `E-XX` du périmètre, les éléments affichés, actions, navigation et états particuliers (vide, erreur, chargement) sont-ils présents ?
- **Design system** : les tokens de `DESIGN.md` sont-ils réellement utilisés (variables CSS, thème) plutôt que des valeurs codées en dur ; les composants `C-XX` prévus existent-ils avec leurs états, dans les écrans listés en "Utilisé dans" ? Sans accès au rendu visuel, se limiter à ce que le code permet de constater.

### 2. Sécurité

Construire la liste de contrôle à partir de la **stack réelle** lue dans `CDC.md` (et confirmée dans le code), pas une checklist générique appliquée à l'aveugle. Points de départ :

- **Transverse** : secrets ou credentials dans le dépôt (y compris historique récent, fichiers d'exemple, fichiers de configuration) ; contrôle d'accès (chaque route/action vérifie-t-elle l'identité ET les droits — un rôle peut-il accéder aux données d'un autre ?) ; validation des entrées côté serveur ; messages d'erreur qui divulguent des détails internes ; données personnelles (quoi est stocké, où, durée, exposition — RGPD) ; dépendances vulnérables (lancer l'outil d'audit de l'écosystème s'il est disponible : `composer audit`, `npm audit`, `pip-audit`...).
- **Web (backend + frontend)** : injection SQL (requêtes non préparées), XSS (sorties non échappées), CSRF sur les actions qui modifient des données, gestion des sessions/cookies (flags `HttpOnly`/`Secure`/`SameSite`), uploads (type, taille, emplacement exécutable), en-têtes de sécurité, configuration de prod (affichage des erreurs, fichiers sensibles accessibles).
- **Tâches de fond, webhooks & services tiers** : webhooks entrants sans authentification ni vérification de signature, clés d'API tierces exposées côté client ou dans les logs, données sensibles envoyées à des services tiers (dont les API d'IA) sans que ce soit acté.
- **Mobile & backend-as-a-service** : règles de sécurité de la base (lecture/écriture ouvertes), clés d'API à privilèges côté client, logique d'autorisation uniquement côté client.

Ne retenir que les points pertinents pour ce projet, et le dire quand une catégorie a été vérifiée sans problème (pour qu'on sache qu'elle a été couverte, et pas oubliée).

Si l'environnement propose un outil de revue de sécurité ou de code intégré (ex. `/security-review` dans Claude Code), le suggérer à l'utilisateur en complément : ces outils analysent le code de façon générique, la recette apporte la connaissance de la spec (qui a le droit de faire quoi selon le PRD, quelles données sont sensibles).

### 3. Incohérences

- **Code ↔ docs** : écarts avec PRD/SCREENS/DESIGN/CDC, triés via `MEMORY.md` (voir section Références).
- **Code ↔ `MEMORY.md`** : décisions ou conventions consignées non respectées.
- **Internes au code** : gestion d'erreurs hétérogène (exceptions ici, codes retour là), logique dupliquée qui a divergé, nommage incohérent pour un même concept, `TODO`/`FIXME` oubliés sur le périmètre MVP, code mort ou fonctionnalité à moitié branchée, configuration en dur qui devrait être paramétrable (URLs, identifiants d'environnement).

### 4. Robustesse

- Les **cas limites listés dans le PRD** sont-ils réellement gérés (échec d'une API externe, données absentes, doublon, timeout) ?
- Les chemins d'erreur mènent-ils à un état propre (message à l'utilisateur, statut cohérent, pas de donnée à moitié écrite) ?
- Lancer les commandes de test/vérification (section "Commandes & vérification" de `CDC.md`, ou celles du projet) et reporter le résultat. Si la stratégie de test prévoyait des tests automatisés qui n'existent pas, c'est une anomalie.

## Déroulé

1. **Déterminer le mode et le périmètre** (brique ou complet), l'annoncer en une phrase.
2. **Rassembler les références** : `MEMORY.md` d'abord, puis `PRD.md`, `SCREENS.md`, `DESIGN.md`, `CDC.md`, `TASKS.md`, et `RECETTE.md` s'il existe (anomalies encore ouvertes à re-tester). Signaler tout doc absent et recetter sur la base de ce qui est disponible. Vérifier aussi leur statut : un doc de référence en `brouillon` ou `à revoir` (cf. orchestrateur, "Statut des docs") rend la conformité moins fiable — le signaler en tête de la recette et dans son journal.
3. **Source de vérité sur l'état réel** :
   - **Avec accès au code** : inspecter le code, lancer les commandes de vérification disponibles.
   - **Sans accès au code (chat)** : prévenir que la recette sera **déclarative et partielle** — conformité uniquement, basée sur `TASKS.md`/`MEMORY.md` et ce que l'utilisateur décrit ou colle. Les axes sécurité et incohérences internes ne peuvent pas être vérifiés sérieusement sans le code : proposer de les faire dans un agent codant plutôt que de simuler un audit.
4. **Re-tester les anomalies ouvertes** de `RECETTE.md` qui entrent dans le périmètre (corrigées → "vérifiée", sinon rester ouverte).
5. **Passer les axes** un par un sur le périmètre.
6. **Trier les écarts avec `MEMORY.md`** (voir section Références) et faire trancher l'utilisateur sur les déviations non documentées — une question à la fois, avec recommandation.
7. **Présenter les anomalies par sévérité** (bloquantes d'abord), puis faire valider la liste : l'utilisateur peut contester une anomalie, abaisser une sévérité, ou accepter un risque.
8. **Écrire/mettre à jour `RECETTE.md`**, puis mettre à jour `TASKS.md` et `MEMORY.md` (voir section Suites).

## Sévérités et statuts

- **Bloquante** : faille de sécurité exploitable, perte/corruption de données, fonctionnalité du périmètre MVP absente ou inutilisable.
- **Majeure** : écart de comportement réel au PRD, cas limite prévu non géré, risque de sécurité non trivial mais non immédiatement exploitable.
- **Mineure** : incohérence interne, écart visuel au design system, dette sans impact utilisateur direct.

Statuts d'une anomalie : `ouverte` → `corrigée` (tâche corrective faite) → `vérifiée` (re-testée lors d'une recette suivante). Deux statuts de clôture sans correction : `risque accepté` (décision de l'utilisateur, consignée dans `MEMORY.md`) et `close — décision consignée` (déviation volontaire, consignée dans `MEMORY.md` et répercutée sur le doc amont).

## Format de RECETTE.md

Un seul fichier cumulatif : les anomalies gardent leur identifiant d'une recette à l'autre, chaque passage est journalisé.

```markdown
# Recette — [Nom du projet/feature]

Dernière mise à jour : [date]
Verdict courant : [Livrable / Non livrable — N bloquantes, N majeures ouvertes] <!-- après une recette complète -->

## Anomalies

| ID | Sévérité | Axe | Périmètre | Constat | Attendu (réf.) | Emplacement | Statut | Tâche |
|---|---|---|---|---|---|---|---|---|
| A-01 | Bloquante | Sécurité | B-02 | [ce qui est constaté] | [ce qui était attendu — réf. F-02.1 / E-03 / C-02 / CDC / MEMORY] | `chemin/fichier:42` | ouverte | T-31 |

## Dette de documentation <!-- décisions consignées dans MEMORY.md mais non répercutées -->

- [Décision MEMORY.md du JJ/MM] — [doc amont à mettre à jour, section]

## Journal des passages

### [date] — Recette de brique : B-02 — [nom]
- Axes couverts : conformité, sécurité, robustesse
- Critères d'acceptation : F-02.1 ✅, F-02.2 ✅, F-02.3 ❌ (A-03), F-04.1 ⚠️ non vérifiable sans [données/accès] — liste complète, pas seulement les échecs
- Écrans / composants : E-03 ✅, C-02 ⚠️ (A-05)
- Catégories sécurité vérifiées sans problème : [...]
- Résultat : A-01 à A-04 ouvertes, A-02 re-testée vérifiée

### [date] — Recette complète
- ...
- Verdict : [Livrable / Non livrable]

## Remarques hors recette <!-- si pertinent : améliorations non demandées, hors périmètre -->

- [...]
```

Omettre les sections vides.

## Suites : TASKS.md et MEMORY.md

- **`TASKS.md`** : pour chaque anomalie `ouverte` retenue, ajouter une tâche corrective (format `dev-loop`) dans la brique concernée, ou dans une section "Correctifs de recette" si transverse — avec comme critère de vérification le constat inverse de l'anomalie. Reporter le numéro de tâche dans la colonne "Tâche" de `RECETTE.md`. Ne pas repasser à `[ ]` des tâches déjà faites : ajouter des tâches correctives nouvelles.
- **`MEMORY.md`** (cf. `dev-memory`) :
  - "État courant" : une ligne sur la dernière recette (ex. "Recette brique Import du 12/09 : 2 majeures ouvertes, T-31/T-32").
  - "Décisions en cours de route" : chaque `risque accepté` et chaque déviation confirmée volontaire, pour qu'une recette suivante ne les remonte pas à nouveau.
  - "Pièges & conventions" : une convention révélée par la recette et qu'il faudra respecter désormais (ex. "échapper toutes les sorties via `e()`").

## Répercussion des changements (règle transverse)

Une recette révèle souvent qu'un doc amont est faux ou incomplet (cas limite non prévu au PRD, écran manquant, choix technique à revoir). Ne pas corriger le doc en silence ni transformer ce constat en tâche de code : signaler le doc amont concerné, demander si c'est une évolution volontaire, et sur confirmation appliquer la répercussion (mise à jour du doc le plus en amont concerné, trace dans `MEMORY.md`). Règle détaillée portée par l'orchestrateur `idea-to-dev`.

## Emplacement des fichiers

Tous les documents du pipeline vivent dans `.idea-to-dev/` à la racine du projet (ou `.idea-to-dev/[nom-feature]/` — cf. orchestrateur) — `RECETTE.md` est écrit dans ce même dossier, à côté de `TASKS.md` et `MEMORY.md`.

- **Avec accès au système de fichiers** : lire directement les docs et le code, écrire `RECETTE.md`, mettre à jour `TASKS.md` et `MEMORY.md`.
- **En chat sans accès fichiers** : demander à l'utilisateur de coller/uploader les documents disponibles (`MEMORY.md` en priorité), produire le contenu de `RECETTE.md` et les ajouts à `TASKS.md`/`MEMORY.md`, et indiquer où les enregistrer.

## Fin de session

- **Recette de brique** : si anomalies bloquantes/majeures, proposer de traiter les tâches correctives avant d'attaquer la brique suivante (sans l'imposer) ; sinon, proposer de reprendre `dev-loop` sur la brique suivante.
- **Recette complète** : annoncer le verdict. Si non livrable, proposer de traiter les tâches correctives puis une recette de re-test limitée aux anomalies ouvertes.
- Ne rien corriger automatiquement, et ne pas enchaîner sur un autre skill sans confirmation.

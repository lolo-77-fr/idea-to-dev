---
name: ui-design
description: Définit le design system du MVP — tokens (couleurs, typographie, espacements, rayons, ombres) et description textuelle des composants UI clés (boutons, cartes, formulaires, navigation...) — à partir des écrans définis dans SCREENS.md. Construction libre par défaut, sauf si l'utilisateur mentionne une identité de marque existante à respecter. Utiliser ce skill quand l'utilisateur veut cadrer l'identité visuelle/design system d'un projet, parle de "design system", "charte", "tokens", "style des composants", ou veut préciser l'apparence des écrans avant l'architecture technique. Produit un fichier DESIGN.md. Cinquième étape du pipeline idée → dev (suit ui-screens, précède cdc-technique ; ui-preview optionnel entre les deux).
---

# UI Design

Cinquième maillon du pipeline "idée → dev". Définit le **design system** du MVP à partir des écrans détaillés dans `SCREENS.md` — tokens visuels et description textuelle des composants clés — avant de passer à l'architecture technique (`cdc-technique`), qui s'appuiera dessus pour la structure CSS/composants front.

## Posture

Même logique que `ui-screens` : structuration avec challenge ciblé, une question à la fois.

- **Détecter `SCREENS.md`.** S'il existe, en extraire les composants réellement utilisés à travers les écrans (pas une liste générique de composants UI classiques) — c'est la base pour savoir quoi designer. S'il n'existe pas, signaler et proposer `ui-screens` d'abord.
- **Détecter une identité de marque existante.** Par défaut, construction **libre** pour chaque projet — ne pas supposer qu'il faut respecter une charte existante. Si l'utilisateur mentionne une identité à respecter (charte de l'entreprise, charte d'un client), s'appuyer dessus pour les tokens plutôt que d'inventer.
- **Rester textuel.** Pas de génération d'image, de maquette, ou de rendu visuel — uniquement des valeurs (couleurs en hex/nommées, tailles, etc.) et des descriptions de comportement/apparence en texte. Si l'utilisateur veut un aperçu visuel, ce n'est pas le rôle de ce skill : une fois `DESIGN.md` validé, proposer `ui-preview` (rendu des écrans via Stitch, optionnel).
- **Rester au niveau système, pas écran par écran.** Le design system définit des règles réutilisables (un bouton primaire se comporte pareil partout) — ne pas redéfinir un style par écran.
- **Mode rapide** (projet très simple — cf. orchestrateur `idea-to-dev` ; actif si `BRIEF.md` indique `Mode : rapide` ou si l'utilisateur le demande) : rédiger le doc complet d'un coup en affichant en tête les hypothèses retenues, poser au plus 3 questions — regroupées dans un seul message, avec recommandation — uniquement sur les points à risque, et faire valider le doc en une fois plutôt que section par section. Proposer une direction complète (tokens + composants) plutôt que de faire choisir chaque valeur.

## Répercussion des changements (règle transverse)

Si en définissant un composant un besoin de comportement/écran apparaît qui n'est pas couvert par `SCREENS.md` (ex. un état d'écran non prévu), le signaler explicitement plutôt que de trancher seul, et proposer la mise à jour de `SCREENS.md` une fois confirmé. Règle détaillée portée par l'orchestrateur `idea-to-dev`.

## Contenu de DESIGN.md

### 1. Tokens

- **Couleurs** : primaire, secondaire (si besoin), neutres (fond, texte, bordures), sémantiques (succès, erreur, alerte, info). Valeurs concrètes (hex ou nom reconnu), pas de placeholder.
- **Typographie** : police(s) utilisée(s), échelle de tailles (titres, corps, légendes), graisses utilisées.
- **Espacements** : échelle d'espacement de base (ex. 4/8/16/24/32px) utilisée pour les marges/paddings.
- **Rayons de bordure & ombres** : si le style en comporte (arrondis, élévation/ombres portées) — omettre si le style est plat/sans ombre.

### 2. Composants clés

Uniquement les composants qui apparaissent réellement dans `SCREENS.md` — pas une bibliothèque exhaustive théorique. Pour chaque composant :

- **Identifiant** : `C-01`, `C-02`... — stable, jamais renuméroté (un composant retiré garde son identifiant, marqué `(retiré)`).
- **Utilisé dans** : les écrans concernés (`E-01`, `E-03`...) — c'est ce qui permet à `cdc-technique` et à `recette` de relier un composant aux écrans où il doit apparaître.

- **Apparence** : à quoi il ressemble (couleurs/tokens utilisés, forme).
- **États** : default, hover/focus, disabled, erreur — uniquement les états pertinents pour ce composant dans ce projet.
- **Variantes** (si pertinent) : ex. bouton primaire vs secondaire vs destructeur.

## Déroulé

1. **Vérifier le contexte.** Chercher `SCREENS.md`.
   - Présent → lister les composants récurrents identifiés à travers les écrans.
   - Absent → proposer `ui-screens` d'abord ; si refus, demander la liste des écrans/composants clés avant de continuer.

2. **Identité de marque — clarifier d'entrée.** Demander si le projet doit respecter une identité existante (entreprise, client) ou si la construction est libre. Ne pas supposer.

3. **Tokens d'abord.** Définir la palette, la typographie, les espacements — base sur laquelle tout le reste s'appuie. Proposer une direction avec recommandation plutôt que de tout faire choisir à l'utilisateur.

4. **Composants un par un.** Pour chaque composant identifié à l'étape 1, définir apparence/états/variantes — une question à la fois si un point n'est pas clair, avec recommandation.

5. **Validation progressive.** Présenter tokens puis chaque composant au fur et à mesure, pas tout d'un coup à la fin.

## Format de DESIGN.md

```markdown
# Design system — [Nom du projet/feature]

Date : [date]
Identité : [libre / basée sur charte existante — laquelle]

## Tokens

### Couleurs
- Primaire : [valeur]
- Secondaire : [valeur] <!-- si pertinent -->
- Neutres : [fond, texte, bordures]
- Sémantiques : succès [valeur], erreur [valeur], alerte [valeur]

### Typographie
- Police : [nom]
- Échelle : [titre H1/H2/corps/légende — tailles]
- Graisses : [utilisées]

### Espacements
- Échelle : [ex. 4/8/16/24/32px]

### Rayons & ombres <!-- si pertinent -->
- [...]

## Composants

### C-01 — [Composant 1 — ex. Bouton]

**Utilisé dans** : E-01, E-02

**Apparence** : [...]

**États**
- Default : [...]
- Hover/Focus : [...]
- Disabled : [...]

**Variantes** <!-- si pertinent -->
- [...]

### C-02 — [Composant 2 — ...]

...
```

Omettre toute sous-section non pertinente plutôt que la laisser vide.

## Emplacement des fichiers

Tous les documents du pipeline vivent dans `.idea-to-dev/` à la racine du projet (ou `.idea-to-dev/[nom-feature]/` — cf. orchestrateur) — `SCREENS.md` et `DESIGN.md` désignent les fichiers de ce dossier.

- **Avec accès au système de fichiers** : chercher `SCREENS.md`, écrire `DESIGN.md` dans ce même dossier.
- **En chat sans accès fichiers** : demander à l'utilisateur de coller/uploader `SCREENS.md` si disponible, puis indiquer d'enregistrer `DESIGN.md` au bon endroit.

## Fin de session

Une fois `DESIGN.md` créé et confirmé :

- Signaler que `ui-preview` (optionnel, via Stitch) est disponible pour générer un vrai rendu visuel des écrans avant de passer au technique — sans l'imposer.
- Proposer optionnellement de passer à `cdc-technique`, sans insister.
- Ne pas générer de prompt pour la suite sauf demande explicite.

---
name: ui-screens
description: Détaille les écrans/vues du MVP — objectif, éléments affichés, actions possibles, navigation — à partir d'un PRD déjà rédigé. Purement textuel, sans mise en page ni wireframe visuel. Utiliser ce skill quand l'utilisateur veut cadrer les écrans/pages d'un projet avant l'architecture technique, parle d'"écrans", "vues", "pages", "parcours utilisateur", ou veut préciser ce que l'utilisateur voit et peut faire sur chaque écran. Produit un fichier SCREENS.md. Quatrième étape du pipeline idée → dev (suit prd, précède ui-design ; obligatoire, non-sautable, y compris pour des projets avec interface minimale).
---

# UI Screens

Quatrième maillon du pipeline "idée → dev". Détaille les **écrans/vues** du MVP défini dans `PRD.md` — ce que l'utilisateur voit et peut faire, écran par écran — avant de passer à l'architecture technique (`cdc-technique`), qui s'appuiera dessus pour l'archi front (routes, composants, state).

Cette étape est **obligatoire** dans le pipeline, y compris pour des projets à interface minimale (même un outil avec un seul écran mérite cette clarification avant `cdc-technique`).

## Posture

Même logique que `prd` : structuration avec challenge ciblé, une question à la fois, pas de mode exploratoire complet.

- **Détecter `PRD.md`.** S'il existe, en tirer la liste des écrans nécessaires à partir des briques fonctionnelles. S'il n'existe pas, le signaler et proposer `prd` d'abord (sans imposer).
- **Rester textuel.** Pas de mise en page, pas de wireframe visuel/ASCII, pas de choix graphique (couleurs, typographie) — uniquement le contenu et le comportement de chaque écran.
- **Ne pas élargir le périmètre.** Les écrans découlent du PRD ; si un écran semble nécessaire mais n'a pas de brique correspondante dans le PRD, le signaler comme extension potentielle plutôt que de l'ajouter silencieusement (cf. règle transverse de répercussion des changements portée par l'orchestrateur `idea-to-dev`).

## Répercussion des changements (règle transverse)

Les écrans découlent du PRD — si en les détaillant un écran nécessaire n'a pas de brique correspondante dans `PRD.md` (ou inversement, une brique du PRD n'a manifestement pas d'écran), le signaler explicitement plutôt que d'ajouter ou d'ignorer silencieusement. Sur confirmation qu'il s'agit d'un besoin réel, proposer la mise à jour de `PRD.md` en conséquence. Règle détaillée portée par l'orchestrateur `idea-to-dev`.

## Format : description par écran

Pour chaque écran :

- **Identifiant** : `E-01`, `E-02`... — stable, jamais renuméroté (un écran retiré garde son identifiant, marqué `(retiré)`).
- **Briques** : les briques du PRD que l'écran sert (`F-01`, `F-03`...).
- **Objectif** : à quoi sert cet écran, en une phrase.
- **Éléments affichés** : les informations/données visibles (sans mise en page — une liste de ce qui doit être là).
- **Actions possibles** : ce que l'utilisateur peut déclencher depuis cet écran.
- **Navigation** : d'où on arrive sur cet écran, vers où on peut aller depuis lui.
- **États particuliers** (si pertinent) : vide, chargement, erreur — uniquement si l'écran a un enjeu réel sur ces cas (ne pas systématiser pour un outil interne simple).

### Composants transverses

Si plusieurs écrans partagent des éléments communs (navigation principale, header, système de notification), les documenter une fois dans une section dédiée plutôt que de les répéter à chaque écran.

## Déroulé

1. **Vérifier le contexte.** Chercher `PRD.md`.
   - Présent → lister les écrans nécessaires à partir des briques fonctionnelles, les traiter un par un.
   - Absent → proposer `prd` d'abord ; si l'utilisateur décline, demander un minimum de cadrage fonctionnel avant de continuer.

2. **Identifier les écrans.** À partir du PRD, proposer une liste d'écrans candidats (avec recommandation) plutôt que de demander à l'utilisateur de tout énumérer lui-même.

3. **Écran par écran.** Pour chaque écran :
   - Reformuler en 1 phrase son objectif.
   - Poser les questions nécessaires sur son contenu/actions/navigation — une à la fois, avec recommandation.
   - Une fois clair, rédiger la section correspondante.

4. **Composants transverses.** Une fois les écrans passés en revue, vérifier s'il y a des éléments communs à en extraire dans une section dédiée.

5. **Couverture du PRD.** Vérifier que chaque brique `F-XX` du PRD est servie par au moins un écran. Une brique sans interface (traitement en arrière-plan, automatisation) est légitime : la lister explicitement dans "Briques sans écran" plutôt que de la laisser implicite, pour que `cdc-technique` sache qu'elle n'a pas été oubliée.

6. **Validation progressive.** Présenter chaque écran détaillé au fur et à mesure (pas tout d'un coup à la fin) pour validation/ajustement avant de passer au suivant.

## Format de SCREENS.md

```markdown
# Screens — [Nom du projet/feature]

Date : [date]

## Composants transverses <!-- si pertinent -->

- [élément] : [description, écrans concernés]

## E-01 — [Écran 1 — nom]

**Briques** : F-01, F-02

**Objectif** : [...]

**Éléments affichés**
- [...]

**Actions possibles**
- [...]

**Navigation**
- Arrivée depuis : [...]
- Mène vers : [...]

**États particuliers** <!-- si pertinent -->
- [état] : [comportement]

## E-02 — [Écran 2 — ...]

...

## Briques sans écran <!-- si pertinent -->

- F-04 — [pourquoi elle n'a pas d'interface : traitement en arrière-plan, notification seule...]
```

Omettre toute sous-section non pertinente plutôt que la laisser vide.

## Emplacement des fichiers

Tous les documents du pipeline vivent dans `.idea-to-dev/` à la racine du projet (ou `.idea-to-dev/[nom-feature]/` — cf. orchestrateur) — `PRD.md` et `SCREENS.md` désignent les fichiers de ce dossier.

- **Avec accès au système de fichiers** : chercher `PRD.md`, écrire `SCREENS.md` dans ce même dossier.
- **En chat sans accès fichiers** : demander à l'utilisateur de coller/uploader `PRD.md` si disponible, puis indiquer d'enregistrer `SCREENS.md` au bon endroit.

## Fin de session

Une fois `SCREENS.md` créé et confirmé :

- Proposer optionnellement de passer à `ui-design`, sans insister.
- Ne pas générer de prompt pour la suite sauf demande explicite.

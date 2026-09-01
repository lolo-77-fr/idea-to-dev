---
name: mvp-check
description: Vérifie la conformité de l'état réel d'un projet (code ou tâches déclarées) par rapport au périmètre défini dans BRIEF.md, PRD.md et SCREENS.md — fonctionnalité par fonctionnalité, écran par écran, pas seulement statut des tâches cochées. Utiliser ce skill quand l'utilisateur veut vérifier si le MVP est conforme, demande un "check MVP", "vérification de conformité", "est-ce qu'on est bons par rapport au brief/PRD", ou avant de considérer un projet/feature comme livré. Invocable à tout moment du pipeline idée → dev, pas uniquement en fin de parcours — utile aussi pour un point d'étape intermédiaire pendant le développement.
---

# MVP Check

Vérification de conformité entre ce qui a été **défini** (`BRIEF.md`, `PRD.md`, `SCREENS.md`) et ce qui a été **réalisé** (code réel, ou à défaut `TASKS.md`/`MEMORY.md`). Ne fait pas partie de l'enchaînement séquentiel du pipeline — invocable à tout moment, y compris en cours de développement pour un point d'étape.

## Posture

- **Vérifier le fond, pas le statut.** Une tâche cochée dans `TASKS.md` ne garantit pas que la fonctionnalité correspond fidèlement à ce que demandait le PRD — toujours comparer au contenu réel du PRD/SCREENS, pas seulement à l'avancement déclaré.
- **Rester factuel.** Le verdict distingue clairement ce qui est vérifié (conforme), ce qui est incertain (pas assez d'information pour trancher), et ce qui est un écart avéré.
- **Ne pas élargir le périmètre.** Ce skill vérifie la conformité au périmètre existant — il ne propose pas de nouvelles fonctionnalités ni n'étend le scope. Si un écart révèle un besoin de recadrage, le signaler et renvoyer vers la règle de répercussion des changements plutôt que de trancher soi-même.

## Déroulé

1. **Rassembler les références.** Chercher `BRIEF.md` (périmètre MVP), `PRD.md` (comportement fonctionnel), `SCREENS.md` (écrans). Si l'un est absent, le signaler et vérifier sur la base de ce qui est disponible.

2. **Déterminer la source de vérité sur l'état réel :**
   - **Avec accès au code** : inspecter le code pour vérifier la présence et le comportement réel de chaque brique/écran — pas seulement lire `TASKS.md`.
   - **Sans accès au code (chat)** : s'appuyer sur `TASKS.md` et `MEMORY.md`, en signalant explicitement que la vérification est déclarative (basée sur ce qui est documenté, pas observée directement) et donc moins fiable.

3. **Vérifier brique par brique** (à partir des sections du PRD) :
   - Présente et conforme au comportement décrit → ✅
   - Présente mais avec un écart de comportement (règle non appliquée, cas limite non géré) → ⚠️ écart
   - Absente → ❌ manquante

4. **Vérifier écran par écran** (à partir de `SCREENS.md`) : mêmes statuts — présent/conforme, présent avec écart, absent.

5. **Produire un verdict global** :
   - **Conforme** : tout est ✅.
   - **Écarts à traiter** : lister précisément chaque ⚠️/❌ avec la brique ou l'écran concerné.

6. **Si des écarts touchent des tâches spécifiques de `TASKS.md`**, les signaler nommément — sans les marquer automatiquement à revoir, laisser l'utilisateur trancher.

## Format de sortie

```markdown
# MVP Check — [Nom du projet/feature]

Date : [date]
Source de vérification : [code / déclaratif (TASKS.md + MEMORY.md)]

## Fonctionnalités (PRD)

- ✅ [Brique 1]
- ⚠️ [Brique 2] — [écart constaté]
- ❌ [Brique 3] — non implémentée

## Écrans (SCREENS.md)

- ✅ [Écran 1]
- ⚠️ [Écran 2] — [écart constaté]

## Verdict

[Conforme / Écarts à traiter]

## Tâches TASKS.md potentiellement concernées <!-- si pertinent -->

- [tâche] — [pourquoi elle semble concernée]
```

## Emplacement des fichiers

Chercher `BRIEF.md`, `PRD.md`, `SCREENS.md`, `TASKS.md`, `MEMORY.md` dans `.idea-to-dev/` (ou `.idea-to-dev/[nom-feature]/`) à la racine du projet.

- **Avec accès au système de fichiers** : lire directement ces fichiers et le code du projet.
- **En chat sans accès fichiers** : demander à l'utilisateur de coller/uploader les documents disponibles.

## Fin de session

Une fois le verdict présenté :

- Si écarts identifiés, demander à l'utilisateur comment il souhaite les traiter (reprendre `dev-loop` sur les tâches concernées, retoucher un doc amont) — ne rien corriger automatiquement.
- Ne pas enchaîner sur un autre skill sans confirmation.

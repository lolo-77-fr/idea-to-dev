# idea-to-dev

Pipeline de skills Claude pour aller d'une idée vague à un projet prêt à développer, en passant par un cadrage progressif et structuré.

## Pipeline

```
brainstorm → product-brief → prd → ui-screens → ui-design → (ui-preview) → cdc-technique → dev-loop → dev-memory
```

Trois skills hors séquence complètent le pipeline :

- `recette` — contrôle du code à chaque jalon : recette de brique (quand toutes les tâches d'une brique sont faites) et recette complète (avant livraison).
- `ui-preview` — rendu visuel optionnel des écrans via Stitch, entre `ui-design` et `cdc-technique`.
- `gtm` — s'invoque une fois le produit livré ou en fin de développement, en continuité du pipeline ou de façon autonome.

| Skill | Rôle | Sortie |
|---|---|---|
| `brainstorm` | Clarifie une idée vague en challengeant l'utilisateur, converge vers un problème net + idées retenues/écartées | `BRAINSTORM.md` |
| `product-brief` | Cadre le produit : vision, périmètre MVP/futur, objectifs, contraintes | `BRIEF.md` |
| `prd` | Détaille le comportement fonctionnel de chaque brique (entrées/sorties, règles, statuts, cas limites) | `PRD.md` |
| `ui-screens` | Détaille les écrans/vues du MVP : objectif, éléments affichés, actions, navigation (texte, pas de wireframe) — obligatoire, non-sautable | `SCREENS.md` |
| `ui-design` | Définit le design system du MVP : tokens (couleurs, typographie, espacements, rayons, ombres) et description textuelle des composants clés | `DESIGN.md` |
| `ui-preview` | Étape optionnelle : génère un rendu visuel réel des écrans via Stitch (Google Labs), en respectant `DESIGN.md` | — |
| `cdc-technique` | Traduit le fonctionnel en choix techniques : stack, architecture, intégrations, découpage technique — clôturé par une checklist de complétude | `CDC.md` |
| `dev-loop` | Découpe le CDC en micro-tâches (2-5 min) avec critères de vérification, gère leur statut, impose la trace des déviations dans `MEMORY.md` | `TASKS.md` |
| `dev-memory` | Mémoire du dev : décisions et déviations vs CDC/TASKS, pièges, debug actif, points de retour ; référence de la recette pour distinguer déviation voulue et anomalie ; point de départ de la réconciliation d'un projet ayant évolué hors-pipeline | `MEMORY.md` |
| `recette` | Contrôle conformité (PRD/SCREENS/DESIGN), sécurité adaptée à la stack, incohérences (code ↔ docs ↔ `MEMORY.md`, code interne) et robustesse ; anomalies → tâches correctives | `RECETTE.md` |
| `gtm` | Priorise les canaux d'acquisition/vente d'un produit livré via la méthodologie Bullseye, en continuité du pipeline ou de façon autonome | — |
| `idea-to-dev` | Orchestrateur — enchaîne les 8 skills séquentiels ci-dessus, gère reprise de projet existant et répercussion des changements de scope | — |

Tous les documents produits sont stockés dans `.idea-to-dev/` à la racine du projet cible (ou `.idea-to-dev/[nom-feature]/` pour une nouvelle feature sur un projet déjà passé par le pipeline).

## Installation

### Claude Code (plugin marketplace — recommandé)

Ce dépôt est une marketplace de plugins Claude Code contenant un seul plugin (`idea-to-dev`) qui embarque les 12 skills du pipeline. Installation :

```
/plugin marketplace add lolo-77-fr/idea-to-dev
/plugin install idea-to-dev@idea-to-dev
```

Mise à jour ultérieure :

```
/plugin marketplace update idea-to-dev
```

(ou activer l'auto-update pour cette marketplace depuis `/plugin` → onglet Marketplaces).

### Claude Code / Claude.ai (skills copiés manuellement)

Alternative sans passer par le plugin : copier le dossier du skill voulu (ex. `skills/brainstorm/`) dans votre dossier de skills (`~/.claude/skills/` ou équivalent selon votre installation). Chaque skill est un dossier autonome contenant un `SKILL.md`.

Pour installer tout le pipeline :

```bash
git clone https://github.com/lolo-77-fr/idea-to-dev.git
cp -r idea-to-dev/skills/* ~/.claude/skills/
```

### Claude.ai (fichiers .skill packagés)

Des fichiers `.skill` packagés sont disponibles pour chaque skill (à uploader directement dans l'interface Claude.ai si elle le permet), voir le dossier `packaged/`.

### Antigravity / autres IA de codage

Référencer le contenu de `SKILL.md` du skill voulu comme instructions système / contexte de session, ou copier le dossier `skills/<nom>/` dans le mécanisme d'extension/skills de l'outil si supporté.

## Convention de stockage

Chaque skill lit/écrit ses documents dans `.idea-to-dev/` à la racine du projet :

```
.idea-to-dev/
├── BRAINSTORM.md
├── BRIEF.md
├── PRD.md
├── SCREENS.md
├── DESIGN.md
├── CDC.md
├── TASKS.md
├── MEMORY.md
└── RECETTE.md
```

- **Avec accès au système de fichiers** (Claude Code, Antigravity) : le dossier est créé/lu automatiquement.
- **En chat sans accès fichiers** (claude.ai) : le skill produit le contenu et indique explicitement d'enregistrer le fichier dans `.idea-to-dev/`.

## Usage type

1. Lancer `idea-to-dev` (ou directement `brainstorm`) sur une idée de projet/feature.
2. Le pipeline avance étape par étape, avec validation à chaque fin d'étape.
3. Une fois `TASKS.md` et `MEMORY.md` en place, le développement peut commencer — directement dans l'agent codant, ou via un prompt de transfert généré par `idea-to-dev` si on est parti d'un chat sans accès au code.

# idea-to-dev

Pipeline de skills Claude pour aller d'une idée vague à un projet prêt à développer, en passant par un cadrage progressif et structuré.

## Pipeline

```
brainstorm → product-brief → prd → cdc-technique → dev-loop → dev-memory
```

| Skill | Rôle | Sortie |
|---|---|---|
| `brainstorm` | Clarifie une idée vague en challengeant l'utilisateur, converge vers un problème net + idées retenues/écartées | `BRAINSTORM.md` |
| `product-brief` | Cadre le produit : vision, périmètre MVP/futur, objectifs, contraintes | `BRIEF.md` |
| `prd` | Détaille le comportement fonctionnel de chaque brique (entrées/sorties, règles, statuts, cas limites) | `PRD.md` |
| `cdc-technique` | Traduit le fonctionnel en choix techniques : stack, architecture, intégrations, découpage technique | `CDC.md` |
| `dev-loop` | Découpe le CDC en micro-tâches (2-5 min) avec critères de vérification, gère leur statut | `TASKS.md` |
| `dev-memory` | Mémoire de session : décisions en cours de route, pièges, debug actif, points de retour | `MEMORY.md` |
| `idea-to-dev` | Orchestrateur — enchaîne les 6 skills ci-dessus sur un même projet | — |

Tous les documents produits sont stockés dans `.idea-to-dev/` à la racine du projet cible.

## Installation

### Claude Code / Claude.ai (skills personnalisés)

Copier le dossier du skill voulu (ex. `skills/brainstorm/`) dans votre dossier de skills (`~/.claude/skills/` ou équivalent selon votre installation). Chaque skill est un dossier autonome contenant un `SKILL.md`.

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
├── CDC.md
├── TASKS.md
└── MEMORY.md
```

- **Avec accès au système de fichiers** (Claude Code, Antigravity) : le dossier est créé/lu automatiquement.
- **En chat sans accès fichiers** (claude.ai) : le skill produit le contenu et indique explicitement d'enregistrer le fichier dans `.idea-to-dev/`.

## Usage type

1. Lancer `idea-to-dev` (ou directement `brainstorm`) sur une idée de projet/feature.
2. Le pipeline avance étape par étape, avec validation à chaque fin d'étape.
3. Une fois `TASKS.md` et `MEMORY.md` en place, le développement peut commencer — directement dans l'agent codant, ou via un prompt de transfert généré par `idea-to-dev` si on est parti d'un chat sans accès au code.

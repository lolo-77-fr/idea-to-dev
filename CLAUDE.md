# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A set of Claude skills (pure Markdown prompts, no code, no build/test tooling) that form an "idée → dev" pipeline: taking a vague idea through progressive framing documents down to dev micro-tasks. All skill content is written in **French** — keep edits in French and match the existing tone and structure.

- `skills/<name>/SKILL.md` — source of truth for each skill (YAML frontmatter `name` + `description`, then the body).
- `packaged/<name>.skill` — zip archives for upload to Claude.ai, each containing `<name>/SKILL.md`.
- `README.md` — user-facing overview, pipeline table, install instructions.
- `.claude-plugin/` — `marketplace.json` + `plugin.json`: the repo is a Claude Code plugin marketplace shipping all skills as one plugin (`/plugin install idea-to-dev@idea-to-dev`). Their descriptions list the skills — update them when adding/removing one, and bump `version` on release.

## Pipeline structure

Sequential: `brainstorm → product-brief → prd → ui-screens → ui-design → cdc-technique → dev-loop → dev-memory`, each producing one doc (`BRAINSTORM.md`, `BRIEF.md`, `PRD.md`, `SCREENS.md`, `DESIGN.md`, `CDC.md`, `TASKS.md`, `MEMORY.md`) that the next step consumes.

Off-sequence skills:
- `idea-to-dev` — orchestrator; detects starting case (A: existing code without docs, B: new feature → `.idea-to-dev/[nom-feature]/` subfolder, C: out-of-pipeline drift → reconciliation), chains steps with explicit user confirmation, adapts the end depending on chat vs coding-agent context.
- `recette` — QA at milestones (per-brique and full pre-delivery): conformity, security, inconsistencies, robustness → `RECETTE.md`, anomalies become corrective tasks in `TASKS.md`. Replaced the former `mvp-check`.
- `ui-preview` — optional Stitch rendering between `ui-design` and `cdc-technique`; never blocks the pipeline.
- `gtm` — Bullseye acquisition-channel prioritisation, post-delivery; not part of the pipeline.

## Cross-skill invariants (keep consistent when editing)

Skills reference each other heavily, so a change to one usually requires touching several:

- **Every skill repeats the "Répercussion des changements (règle transverse)" section** (signal → confirm → propagate upstream → flag impacted `TASKS.md` tasks). The canonical version lives in `skills/idea-to-dev/SKILL.md`; per-skill copies are short reminders.
- **Every skill has an "Emplacement des fichiers" section** stating docs live in `.idea-to-dev/` (or `.idea-to-dev/[nom-feature]/`) at the target project's root, with a chat-without-filesystem fallback.
- **Pipeline order/step numbers appear in many places**: each `description` frontmatter ("Nième étape du pipeline… suit X, précède Y"), each body intro ("Nième maillon"), the orchestrator's step lists, and the README table/diagram. Adding, removing, or reordering a step means updating all of them. Descriptions only name the previous and next step, to keep this manageable.
- `MEMORY.md` is the register of deviations from `CDC.md`/`TASKS.md` during dev: `dev-loop` must log them (with task/brique + upstream-doc status), and `recette` uses it to tell intended deviations from anomalies. Keep `dev-loop`, `dev-memory`, `recette` and the orchestrator aligned on this.
- `ui-screens` and `ui-design` are mandatory/non-skippable; `cdc-technique` closes only after its completeness checklist. Don't weaken these in orchestrator edits.
- The `description` frontmatter drives skill triggering — keep trigger phrases ("PRD", "CDC technique", "TASKS", …) when rewording.

## Consistency check & packaging

Run after any edit to a skill, the README or `.claude-plugin/`:

```bash
scripts/check.sh        # verify only (exit 1 on any problem)
scripts/check.sh --fix  # also rebuild stale/missing packaged/<name>.skill zips
```

It checks folder name = frontmatter `name`, presence of the shared sections, step ordinals in descriptions and intros, the orchestrator's chain, README table and marketplace description vs `skills/`, plugin version parity, and package freshness. The pipeline order lives in the `PIPELINE`/`ORDINALS` arrays at the top of the script — update them when adding or reordering a step.

When adding a skill, also add its README table row and mention it in the `.claude-plugin/marketplace.json` description (the script flags both if missing).

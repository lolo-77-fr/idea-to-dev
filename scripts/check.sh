#!/usr/bin/env bash
# Vérifie la cohérence entre les skills, le README, le plugin et les packages.
# Usage : scripts/check.sh          → vérifie seulement
#         scripts/check.sh --fix    → reconstruit en plus les packages .skill obsolètes ou manquants
set -u
cd "$(dirname "$0")/.."

FIX=0
[ "${1:-}" = "--fix" ] && FIX=1
ERRORS=0
err() { echo "✗ $*"; ERRORS=$((ERRORS + 1)); }

# Ordre du pipeline séquentiel et ordinal attendu pour chaque étape.
PIPELINE=(brainstorm product-brief prd ui-screens ui-design cdc-technique dev-loop dev-memory)
ORDINALS=(Première Deuxième Troisième Quatrième Cinquième Sixième Septième Huitième)
# Skills qui n'ont pas les sections transverses du pipeline.
STANDALONE=" gtm "

# 1. Nom du dossier = name du frontmatter, sections transverses présentes.
for dir in skills/*/; do
  n=$(basename "$dir")
  f="$dir/SKILL.md"
  [ -f "$f" ] || { err "$n : SKILL.md manquant"; continue; }
  name=$(sed -n 's/^name: *//p' "$f" | head -1)
  [ "$name" = "$n" ] || err "$n : frontmatter name='$name' ≠ nom du dossier"
  grep -q '^description: ' "$f" || err "$n : description manquante"
  case "$STANDALONE" in *" $n "*) continue ;; esac
  grep -q '^## Répercussion des changements' "$f" || err "$n : section « Répercussion des changements » manquante"
  [ "$n" = idea-to-dev ] || grep -q '^## Emplacement' "$f" || err "$n : section « Emplacement » manquante"
done

# 2. Numérotation des étapes (description + intro du corps) et chaîne de l'orchestrateur.
for i in "${!PIPELINE[@]}"; do
  n=${PIPELINE[$i]}; o=${ORDINALS[$i]}; f="skills/$n/SKILL.md"
  [ -f "$f" ] || { err "$n : étape du pipeline sans skill"; continue; }
  sed -n '3p' "$f" | grep -q "$o étape du pipeline" || err "$n : la description ne dit pas « $o étape du pipeline »"
  m=$o; [ "$o" = Première ] && m=Premier  # « maillon » est masculin
  grep -q "^$m maillon du pipeline" "$f" || err "$n : l'intro ne dit pas « $m maillon du pipeline »"
done
# Les six docs d'étape (avant dev-loop) portent un statut.
for n in brainstorm product-brief prd ui-screens ui-design cdc-technique; do
  f="skills/$n/SKILL.md"
  grep -q '^Statut : brouillon' "$f" || err "$n : ligne « Statut : » absente du format du doc"
  grep -q '^## Statut du document' "$f" || err "$n : section « Statut du document » manquante"
done
CHAIN=$(printf '`%s` → ' "${PIPELINE[@]}"); CHAIN=${CHAIN% → }
grep -qF "$CHAIN" skills/idea-to-dev/SKILL.md || err "idea-to-dev : la chaîne du pipeline ne correspond pas à : $CHAIN"

# 3. Chaque skill est cité dans le README et dans la description du plugin, et aucun skill supprimé n'y traîne.
for dir in skills/*/; do
  n=$(basename "$dir")
  grep -q "^| \`$n\` |" README.md || err "README : pas de ligne pour \`$n\` dans le tableau"
  grep -qw "$n" .claude-plugin/marketplace.json || err "marketplace.json : \`$n\` absent de la description"
done
for n in $(sed -n 's/^| `\([a-z-]*\)` |.*/\1/p' README.md); do
  [ -d "skills/$n" ] || err "README : \`$n\` cité mais skills/$n n'existe pas"
done

# 4. Versions du plugin identiques.
v1=$(sed -n 's/.*"version": *"\([^"]*\)".*/\1/p' .claude-plugin/plugin.json)
v2=$(sed -n 's/.*"version": *"\([^"]*\)".*/\1/p' .claude-plugin/marketplace.json)
[ "$v1" = "$v2" ] || err "versions du plugin différentes : plugin.json=$v1, marketplace.json=$v2"

# 5. Packages .skill à jour (et reconstruits avec --fix).
for dir in skills/*/; do
  n=$(basename "$dir"); pkg="packaged/$n.skill"
  if [ -f "$pkg" ] && unzip -p "$pkg" "$n/SKILL.md" 2>/dev/null | cmp -s - "$dir/SKILL.md"; then
    continue
  fi
  if [ $FIX -eq 1 ]; then
    (cd skills && rm -f "../$pkg" && zip -qX "../$pkg" "$n/SKILL.md") && echo "↻ $pkg reconstruit"
  else
    err "$pkg obsolète ou manquant (relancer avec --fix)"
  fi
done
for pkg in packaged/*.skill; do
  n=$(basename "$pkg" .skill)
  [ -d "skills/$n" ] || err "$pkg : aucun skill source (package orphelin)"
done

if [ $ERRORS -eq 0 ]; then echo "✓ tout est cohérent"; else echo "$ERRORS problème(s)"; exit 1; fi

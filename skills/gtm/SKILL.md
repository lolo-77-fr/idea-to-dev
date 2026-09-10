---
name: gtm-bullseye
description: "Aide à identifier et prioriser les canaux d'acquisition/vente pour un produit livré ou en fin de développement, en appliquant la méthodologie Bullseye (Traction, Weinberg & Mares) adaptée au produit réel via son contexte (BRIEF.md/PRD.md). Utiliser explicitement ce skill quand l'utilisateur demande comment lancer, vendre, trouver ses premiers clients, ou quel canal marketing/growth tester pour un projet — que ce soit en continuité du pipeline idea-to-dev (après dev-memory) ou de façon autonome sur n'importe quel produit/projet. Ne PAS déclencher si un canal est déjà validé et qu'il s'agit seulement de l'optimiser/scaler — dans ce cas c'est une simple exécution marketing, pas une recherche de canal."
---

# GTM Bullseye — Identifier et prioriser les canaux d'acquisition

## Vue d'ensemble

Basé sur le framework Bullseye de *Traction* (Weinberg & Mares, 2014) : la plupart des startups meurent d'un manque de distribution, pas d'un manque de produit — et la cause la plus fréquente est de s'enfermer trop tôt sur un canal par confort, sans avoir testé les autres. Ce skill adapte le framework original en l'ancrant systématiquement dans le contexte réel du produit (pas de recommandations génériques) et en investiguant activement (recherche web + questions ciblées) plutôt que de se contenter d'une liste abstraite.

Ce skill peut être invoqué seul, sur n'importe quel produit, ou comme suite du pipeline `idea-to-dev` une fois le développement avancé/terminé (après `dev-loop`/`dev-memory`).

## Avant de commencer : contexte produit

Toujours lire, s'ils existent, dans cet ordre :
1. `BRIEF.md`, `PRD.md` (positionnement, audience cible, problème résolu)
2. `SCREENS.md`, `DESIGN.md` si utile pour comprendre le produit concret
3. `GTM.md` s'il existe déjà — signale une reprise de cycle (voir "Cycles et reprise" plus bas), pas un démarrage à zéro

Si aucun de ces fichiers n'existe, poser les questions minimales avant de commencer : qu'est-ce que le produit fait, pour qui, quel est le budget/temps disponible pour le go-to-market, y a-t-il déjà une audience/liste/réseau existant.

## Processus en 2 passes + cycle Bullseye

### Passe 1 — Triage des 19 canaux (rapide, pas de recherche externe)

Évaluer les 19 canaux ci-dessous **uniquement à partir du contexte produit déjà connu** (pas de recherche web à ce stade). Produire un classement complet — les 19 canaux, du plus au moins pertinent a priori — **chacun avec une justification courte** (1-2 phrases : pourquoi ce rang, en quoi ça colle ou pas au produit/audience/budget/cycle de vente). Rien n'est supprimé de la liste, même les canaux clairement hors-sujet doivent apparaître avec leur justification, en bas de classement.

Les 19 canaux (Traction, Weinberg & Mares) :

1. **Viral Marketing** — la croissance vient-elle naturellement du produit utilisé/partagé ?
2. **Public Relations (PR)** — y a-t-il un angle presse/média généraliste ?
3. **Unconventional PR** — coup d'éclat, stunt, action remarquée hors des canaux presse classiques
4. **Search Engine Marketing (SEM)** — ads sur mots-clés de recherche (Google Ads etc.)
5. **Social & Display Ads** — publicité ciblée sur réseaux sociaux/display
6. **Offline Ads** — presse papier, radio, affichage, TV
7. **Search Engine Optimization (SEO)** — trafic organique par contenu/référencement
8. **Content Marketing** — blog, guides, ressources qui attirent et nourrissent l'audience
9. **Email Marketing** — capture et nurturing par email
10. **Engineering as Marketing** — outils gratuits, calculateurs, widgets qui génèrent de la traction
11. **Targeting Blogs** — relais par des blogs/médias déjà lus par l'audience cible
12. **Business Development (BD)** — partenariats stratégiques, intégrations, accords de distribution
13. **Sales** — vente directe, outbound, démonstrations
14. **Affiliate Programs** — partenaires rémunérés à la performance
15. **Existing Platforms** — s'appuyer sur une plateforme avec audience déjà là (marketplace, app store, réseau social, API d'un tiers)
16. **Trade Shows** — salons professionnels du secteur
17. **Offline Events** — meetups, ateliers, événements physiques organisés ou sponsorisés
18. **Speaking Engagements** — conférences, interventions publiques
19. **Community Building** — construire/animer une communauté propre (Discord, Slack, forum)

Présenter ce classement des 19 en chat avant de passer à la passe 2 — obtenir confirmation ou ajustement de l'utilisateur sur le classement avant d'investir du temps de recherche dessus.

### Passe 2 — Brainstorm approfondi (sur le haut du classement)

Se concentrer sur les canaux les mieux classés en passe 1 (typiquement le tiers supérieur, à ajuster selon la clarté du triage). Pour chacun, produire une **hypothèse concrète et nommée** — jamais une généralité du type "faire du content marketing" :

- **Canaux externes** (SEO, Content, Targeting Blogs, PR, Existing Platforms, Affiliate, Community, Trade Shows, Offline Events, Speaking, BD...) → faire une recherche web pour identifier les acteurs réels de la niche : quels blogs/médias couvrent ce type de produit, quelles communautés/plateformes l'audience cible fréquente déjà, quels événements existent, quels partenaires potentiels. L'hypothèse doit nommer des acteurs/plateformes réels quand c'est possible, pas des catégories abstraites.
- **Canaux internes/dépendants des ressources** (Sales, Email, Engineering as Marketing, Viral, Ads, Offline Ads) → poser des questions ciblées sur les ressources et appétences disponibles : budget ads, liste email existante, réseau perso, appétence pour tel format (écrit/vidéo/live), capacité à développer un outil gratuit.

Ne pas avancer vers les rings tant que chaque canal investigué n'a pas une hypothèse concrète actionnable.

### Rings (Bullseye classique)

Classer les canaux investigués en passe 2 dans les trois anneaux :
- **Inner ring** — prometteurs maintenant, à tester en premier
- **Middle ring** — possibles, à garder en réserve
- **Outer ring** — pistes lointaines, à ne pas oublier mais pas prioritaires

*Garde-fou : ne pas exclure un canal de l'outer ring sous prétexte qu'il semble "improbable" — c'est souvent celui-là qui finit par marcher.*

### Tests (inner ring uniquement)

Pour chaque canal de l'inner ring : définir un test cadré, court, peu coûteux, avec un **seuil de succès chiffré fixé avant le test** (CAC cible, taux de réponse, taux de conversion...). Sans ce seuil pré-défini, le résultat du test sera jugé sur préférence plutôt que sur donnée.

*Garde-fou : tester 3+ canaux à pleine intensité en parallèle dilue l'effort — préférer des tests courts et peu coûteux qui permettent de trancher vite, puis concentrer les ressources.*

### Décision et focus

Une fois les tests réalisés : comparer les résultats au seuil pré-défini, pas aux préférences. Choisir **un seul** canal gagnant et y concentrer l'effort. Les autres canaux ne sont pas abandonnés définitivement — ils redeviennent des candidats au prochain cycle.

### Cycles et reprise

Un canal finit par saturer (rendements décroissants). Quand `GTM.md` existe déjà :
- Si un cycle est en cours (tests lancés, pas encore de décision) → reprendre où ça s'est arrêté, ne pas relancer le triage depuis zéro
- Si un canal focus existant montre des signes de saturation, ou si l'utilisateur le signale → relancer un nouveau cycle Bullseye, en conservant l'historique des cycles précédents (canaux déjà testés, résultats, canal(aux) qui ont fonctionné) — ça permet d'éviter de retester un canal déjà écarté sans raison nouvelle et d'aller plus vite au triage suivant.

## Format de sortie

Toujours produire :
1. **En chat** — la discussion complète : classement des 19, hypothèses de la passe 2, échanges sur les rings, définition des seuils de test, décision finale. C'est un processus itératif, pas un rapport figé d'un coup.
2. **Fichier `GTM.md`** — maintenu au fil du processus (créé s'il n'existe pas, mis à jour sinon), avec :
   - Résumé du contexte produit utilisé
   - Classement des 19 canaux avec justifications (passe 1)
   - Hypothèses concrètes par canal investigué (passe 2)
   - Rings actuels (inner/middle/outer)
   - Tests en cours ou réalisés, avec seuils et résultats
   - Décision(s) et canal(aux) focus
   - Historique des cycles précédents (si applicable)

## Red flags à signaler à l'utilisateur

- Un canal choisi avant d'être testé
- "Un peu de tout" sans concentration sur un canal gagnant
- Un test lancé sans seuil de succès défini au préalable
- Une hypothèse de canal restée générique (pas d'acteur/plateforme nommé) faute d'avoir fait la recherche

## Vérification avant de clore une session

- [ ] Contexte produit lu (BRIEF/PRD/GTM existant)
- [ ] Les 19 canaux classés avec justification (passe 1)
- [ ] Canaux prioritaires investigués avec hypothèses concrètes, pas génériques (passe 2)
- [ ] Rings définis
- [ ] Seuils de succès fixés avant tout test
- [ ] GTM.md créé/mis à jour en conséquence

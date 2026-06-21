# CV As Code

**Projet Vibe Coding — Ynov Lyon**  
**Auteur :** Sébastien Soave  
**Formation :** Bachelor Cybersécurité — Ynov Lyon

---

## Contexte et objectif

Ce projet met en œuvre le concept **« CV As Code »** : le curriculum vitae est rédigé en **Markdown**, versionné dans Git, puis transformé automatiquement en **PDF** via un pipeline reproductible.

L'objectif pédagogique est de démontrer :

- la séparation des responsabilités (contenu / structure / style) ;
- l'automatisation d'un workflow de génération de documents ;
- la compatibilité avec un environnement local, Docker et GitHub Actions.

---

## Architecture du pipeline

```
content/cv.md
      │
      ▼  Pandoc (+ templates/cv-template.html)
output/cv.html
      │
      ▼  WeasyPrint (+ styles/print.css)
output/cv.pdf
```

| Étape | Outil | Entrée | Sortie |
|-------|-------|--------|--------|
| 1 | Pandoc | `content/cv.md` | `output/cv.html` |
| 2 | WeasyPrint | `output/cv.html` | `output/cv.pdf` |

Le script `scripts/build.sh` orchestre les deux étapes. La commande `make build` en est le point d'entrée.

---

## Structure du projet

```
cv-as-code/
├── .github/              # Workflows CI (GitHub Actions)
├── content/
│   └── cv.md             # Source unique du CV (Markdown + YAML)
├── output/               # Fichiers générés (non versionnés)
├── scripts/
│   └── build.sh          # Pipeline Pandoc → WeasyPrint
├── styles/
│   └── print.css         # Feuille de style impression
├── templates/
│   └── cv-template.html  # Template HTML Pandoc
├── Dockerfile            # Environnement conteneurisé
├── Makefile              # Commandes make build / make clean
└── README.md
```

---

## Principes de conception

| Principe | Application |
|----------|-------------|
| **SRP** (Single Responsibility) | `cv.md` = contenu, `cv-template.html` = structure, `print.css` = présentation |
| **KISS** (Keep It Simple) | Un script Bash, une commande `make build`, pas de sur-ingénierie |
| **DRY** (Don't Repeat Yourself) | Une seule source de vérité : `content/cv.md` |
| **Pas de CSS inline** | Tous les styles sont externalisés dans `styles/print.css` |
| **PDF non versionné** | Le dossier `output/` est ignoré par Git (`.gitignore`) |

---

## Prérequis

### macOS (Apple Silicon M1/M2)

```bash
brew install pandoc
pip install weasyprint
```

> WeasyPrint nécessite des bibliothèques système (Cairo, Pango). Sur macOS, elles sont généralement installées via Homebrew avec les dépendances Python.

### Linux / Docker / CI

- **Pandoc** ≥ 2.x
- **WeasyPrint** ≥ 60
- **Bash** ≥ 4

---

## Installation et utilisation

```bash
# Cloner le dépôt
git clone <url-du-repo>
cd cv-as-code

# Générer le CV (HTML + PDF)
make build

# Nettoyer les fichiers générés
make clean
```

### Résultat attendu

Après `make build` :

```
output/
├── cv.html      # Version HTML intermédiaire
├── cv.pdf       # CV final prêt à envoyer
└── print.css    # Copie locale pour résolution des chemins
```

---

## Description des fichiers

### `content/cv.md`

Fichier source du CV. Contient :

- un **front matter YAML** (nom, titre, localisation, email, GitHub…) injecté dans l'en-tête HTML ;
- le **corps Markdown** (sections Profil, Compétences, Formation, Expériences, Projets, Langues, Centres d'intérêt).

C'est le **seul fichier à modifier** pour mettre à jour le CV.

### `templates/cv-template.html`

Template HTML compatible **Pandoc**. Définit la structure sémantique :

- `<header class="cv-header">` : identité et contact (variables `$title$`, `$subtitle$`, `$email$`…)
- `<main class="cv-body">` : contenu converti (`$body$`)

Aucun style inline : la présentation est entièrement déléguée au CSS.

### `styles/print.css`

Feuille de style pour **WeasyPrint** :

- **Variables CSS** dans `:root` (couleurs, typographie, espacements, marges) ;
- **`@page`** pour le format **A4** ;
- Thème visuel orienté **cybersécurité** (palette slate, accent vert terminal, titres en monospace avec préfixe `//`) ;
- Règles d'impression (`page-break`, veuves/orphelines).

### `scripts/build.sh`

Script Bash du pipeline :

1. Vérifie la présence de `pandoc` et `weasyprint` ;
2. Crée le dossier `output/` ;
3. Copie `print.css` dans `output/` (résolution fiable des chemins en local, Docker et CI) ;
4. Génère `output/cv.html` avec Pandoc ;
5. Génère `output/cv.pdf` avec WeasyPrint.

### `Makefile`

Interface simplifiée :

| Commande | Action |
|----------|--------|
| `make build` | Lance `scripts/build.sh` |
| `make clean` | Supprime le contenu de `output/` |

---

## Technologies utilisées

| Technologie | Rôle |
|-------------|------|
| **Markdown** | Format source du contenu |
| **YAML** | Métadonnées du CV (front matter) |
| **Pandoc** | Conversion Markdown → HTML |
| **HTML5** | Structure du document |
| **CSS3** | Mise en page et thème visuel |
| **WeasyPrint** | Conversion HTML → PDF |
| **Bash** | Script d'automatisation |
| **Make** | Orchestration des commandes |
| **Git / GitHub** | Versionnement et CI/CD |

---

## Compatibilité

| Environnement | Statut |
|---------------|--------|
| macOS Apple Silicon (M1/M2) | ✅ Compatible |
| Linux (CI GitHub Actions) | ✅ Compatible |
| Docker | ✅ Compatible (via `Dockerfile`) |
| PDF versionné dans Git | ❌ Non (généré automatiquement) |

---

## Évolutions prévues

- [x] Workflow **GitHub Actions** pour générer le PDF à chaque push
- [x] Image **Docker** complète pour un build reproductible sans installation locale
- [x] Publication automatique du PDF en artefact CI

---

## 4. Le Rapport Analytique

### Arsenal IA

| Outil | Rôle dans le projet |
|-------|---------------------|
| **Cursor** | IDE principal et agent IA intégré : génération du pipeline, du CSS, du template Pandoc, du Dockerfile, du workflow GitHub Actions et audits de conformité |
| **ChatGPT** | Appui ponctuel pour comprendre la documentation WeasyPrint/Pandoc et valider des choix d'architecture |
| **LLM utilisés** | Modèles intégrés à Cursor (Composer / agents de code) pour itérer sur les fichiers du dépôt en respectant les contraintes du sujet |

Cursor a été l'outil central du Vibe Coding : il m'a permis de produire rapidement une base fonctionnelle tout en gardant la main sur la structure du projet (SRP, KISS, DRY). ChatGPT a servi de second avis sur des points techniques précis (dépendances WeasyPrint, syntaxe des templates Pandoc).

---

### Ingénierie de Prompt

#### Prompt 1 — Initialisation du pipeline complet

> *« Créer un pipeline qui transforme un fichier Markdown en PDF automatiquement avec Pandoc et WeasyPrint. Générer content/cv.md, templates/cv-template.html, styles/print.css, scripts/build.sh et Makefile. Respecter SRP, KISS, DRY, aucun CSS inline. »*

**Utilité :** poser le cadre architectural dès le départ et obtenir une structure de projet cohérente avec le sujet Ynov, sans mélanger contenu, template et style.

#### Prompt 2 — Audit de conformité avant rendu

> *« Analyse le projet CV As Code par rapport au sujet Ynov. Vérifie les critères éliminatoires, l'architecture, WeasyPrint, le build, Docker et GitHub Actions. Ne modifie aucun fichier. »*

**Utilité :** identifier les lacunes (Dockerfile vide, workflow CI absent, README incomplet) avant le commit final, sans laisser l'IA modifier le code à ma place.

#### Prompt 3 — Génération ciblée Docker + CI

> *« Dockerfile complet compatible Apple Silicon M1/M2 et GitHub Actions. GitHub Action avec push sur main, make build, vérification output/cv.pdf, upload Artifact. Ne modifie aucun autre fichier. »*

**Utilité :** demander des livrables précis et isolés, en limitant le scope de l'IA pour éviter des modifications non désirées sur le reste du dépôt.

**Principe retenu :** des prompts **contraints** (structure imposée, interdiction de modifier certains fichiers, audit en lecture seule) produisent de meilleurs résultats que des demandes vagues du type « fais-moi le projet ».

---

### Analyse Critique

#### Erreurs de l'IA

- L'IA a parfois affirmé que des fichiers étaient « vides » alors qu'ils contenaient déjà du code, ce qui aurait pu entraîner un écrasement inutile.
- Le README généré indiquait Docker et GitHub Actions comme « compatibles » alors que le `Dockerfile` et le workflow étaient encore vides — **incohérence documentaire** corrigée manuellement après audit.
- Tentative initiale de référencer le CSS avec un chemin relatif `../styles/print.css` depuis `output/`, fonctionnel en preview HTML mais fragile pour WeasyPrint selon le `--base-url`.

#### Hallucinations rencontrées

- Suggestion implicite que `pandoc/pandoc-action` ou des actions tierces obscures étaient nécessaires, alors qu'une installation via `apt-get install pandoc` sur Ubuntu suffit en CI.
- Proposition de sur-ingénierie (multi-stage Docker, scripts Python intermédiaires) écartée au profit du pipeline Bash existant, plus simple et conforme au sujet.

#### Problèmes Docker

| Problème | Résolution |
|----------|------------|
| Image non multi-arch | Choix de `python:3.12-slim-bookworm`, disponible en **arm64** (M1/M2) et **amd64** (GitHub Actions) |
| WeasyPrint absent des dépôts apt | Installation via `pip install weasyprint` après les libs système Cairo/Pango |
| PDF non récupérable depuis l'hôte | Utilisation de `docker run -v "$(pwd)/output:/app/output"` pour monter le volume de sortie |

#### Problèmes Pandoc

| Problème | Résolution |
|----------|------------|
| Métadonnées YAML non injectées dans l'en-tête | Template Pandoc dédié avec variables `$title$`, `$subtitle$`, `$email$`… |
| Sections Markdown non stylables individuellement | Option `--section-divs` pour encapsuler chaque `##` dans une balise `<section>` |
| Lien CSS incorrect dans le HTML généré | Copie de `print.css` dans `output/` et référence `--css="print.css"` |

#### Problèmes WeasyPrint

| Problème | Résolution |
|----------|------------|
| CSS non appliqué au PDF | Paramètre `--base-url="${OUTPUT_DIR}/"` pour résoudre correctement les chemins |
| Mise en page A4 ignorée | Règle `@page { size: A4; margin: … }` avec marges via variables CSS |
| Sauts de page incohérents | Règles `page-break-inside: avoid` sur les sections et `@media print` pour veuves/orphelines |

**Leçon :** l'IA accélère la production, mais chaque couche (Pandoc → HTML → WeasyPrint → PDF) doit être **validée séparément** ; un pipeline qui échoue silencieusement sur le CSS est une erreur classique.

---

### Difficultés rencontrées

#### Génération PDF

La chaîne MD → HTML → PDF implique trois outils distincts. La difficulté principale a été la **résolution des chemins CSS** : WeasyPrint ne charge pas les feuilles de style de la même manière qu'un navigateur. La copie de `print.css` dans `output/` et le `--base-url` explicite ont résolu le problème de façon reproductible en local, Docker et CI.

#### Compatibilité Apple Silicon

Sur macOS M1/M2, WeasyPrint dépend de bibliothèques natives (Cairo, Pango) installées via Homebrew. En conteneur, il fallait choisir une image **arm64-native** plutôt que forcer l'émulation amd64. Le `Dockerfile` basé sur Debian Bookworm slim répond à cette contrainte.

#### CI/CD GitHub Actions

WeasyPrint ne s'installe pas avec un simple `pip install` sur Ubuntu sans les paquets système associés. Le workflow CI installe explicitement `libcairo2`, `libpango-1.0-0`, `libpangocairo-1.0-0`, etc., avant WeasyPrint — calqué sur le `Dockerfile` pour garantir la **parité local / CI / Docker**.

Autre point d'attention : le workflow ne se déclenche que sur la branche `main` ; un push sur une branche de feature ne lance pas la CI tant qu'il n'y a pas de merge.

---

### Conclusion personnelle

Ce projet m'a permis de comprendre qu'un CV « as code » n'est pas qu'un fichier Markdown : c'est un **pipeline reproductible** où chaque composant a une responsabilité claire. L'usage de l'IA (Cursor) a considérablement accéléré la mise en place du socle technique, mais les erreurs les plus coûteuses — chemins CSS, dépendances WeasyPrint, incohérences README — ont été détectées grâce à des **audits ciblés** et des tests manuels, pas par l'IA seule.

Je retiens trois bonnes pratiques du Vibe Coding :

1. **Prompts contraints** : préciser ce que l'IA peut et ne peut pas modifier.
2. **Validation par étapes** : vérifier HTML avant PDF, PDF avant CI.
3. **Parité des environnements** : même stack dans le script local, le Dockerfile et GitHub Actions.

Le résultat final — un CV versionné en Markdown, un PDF généré automatiquement, un pipeline CI qui publie l'artefact — correspond exactement à l'esprit du sujet Ynov : **automatiser, reproduire, documenter**.

---

## Auteur

**Sébastien Soave**  
Étudiant — Bachelor Cybersécurité · Ynov Lyon  
Contact : soave.sebastien@icloud.com

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

- [ ] Workflow **GitHub Actions** pour générer le PDF à chaque push
- [ ] Image **Docker** complète pour un build reproductible sans installation locale
- [ ] Publication automatique du PDF en artefact CI

---

## Auteur

**Sébastien Soave**  
Étudiant — Bachelor Cybersécurité · Ynov Lyon  
Contact : soave.sebastien@icloud.com

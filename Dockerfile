# Image multi-arch (linux/amd64 + linux/arm64) — compatible M1/M2 et GitHub Actions
FROM python:3.12-slim-bookworm

# Dépendances système : Pandoc, Make, bibliothèques WeasyPrint (Cairo, Pango…)
RUN apt-get update && apt-get install -y --no-install-recommends \
    pandoc \
    make \
    libcairo2 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libpangoft2-1.0-0 \
    libharfbuzz0b \
    libgdk-pixbuf-2.0-0 \
    libffi-dev \
    shared-mime-info \
    fontconfig \
    fonts-liberation \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir weasyprint

WORKDIR /app

COPY . .

CMD ["make", "build"]

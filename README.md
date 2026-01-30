# Copilot CLI - Configuration Docker

Configuration Docker pour exécuter la CLI GitHub Copilot dans un conteneur.

## Prérequis

- Docker
- Docker Compose

## Installation

La CLI copilot est installée via npm dans le conteneur :
```bash
npm install -g @github/copilot
```

## Construction de l'image

```bash
docker compose build
```

## Utilisation

### Afficher l'aide

```bash
docker compose run --rm copilot-cli
```

### Exécuter une commande spécifique

```bash
docker compose run --rm copilot-cli [commande] [options]
```

### Exemples

```bash
# Afficher la version
docker compose run --rm copilot-cli --version

# Utiliser copilot en mode interactif
docker compose run --rm copilot-cli
```

## Structure

- `Dockerfile` : Image basée sur Node.js 20 Alpine avec la CLI copilot
- `docker compose.yaml` : Configuration du service
- `workspace/` : Répertoire partagé entre l'hôte et le conteneur

## Configuration

Le conteneur monte le répertoire `./workspace` dans `/workspace` pour faciliter le partage de fichiers.

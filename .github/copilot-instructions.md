<!-- Instructions concises pour les agents IA travaillant sur ce dépôt -->
# Copilot instructions for this repository

## Objectif du projet
Configuration Docker pour exécuter la CLI GitHub Copilot en mode serveur (port 4321), permettant l'intégration d'agents IA dans des applications via l'API.

## Fichiers clés et architecture

- [Dockerfile](../Dockerfile) : image `node:24-slim` avec installation de Copilot CLI v0.0.400-0 via `curl -fsSL https://gh.io/copilot-install`
- [entrypoint.sh](../entrypoint.sh) : wrapper qui lance `copilot --server --port 4321` avec logs de démarrage et vérifications d'environnement
- [docker-compose.yaml](../docker-compose.yaml) : service qui expose le port 4321, injecte `GH_TOKEN` depuis `.env`, monte `./workspace` → `/workspace`
- [AUTH_SETUP.md](../AUTH_SETUP.md) : guide complet pour créer un PAT GitHub avec permissions Copilot

## Flux de travail essentiels

### Build et démarrage du serveur
```bash
docker compose build              # Build avec --no-cache si changement de version CLI
docker compose up -d              # Lance le serveur en background
docker compose logs -f copilot-cli  # Voir les logs du serveur
```

### Modes d'utilisation
Le service démarre automatiquement en **mode serveur** (`copilot --server --port 4321`) via l'entrypoint, pas en mode CLI interactif.

Pour tester en mode CLI interactif :
```bash
docker compose run --rm --entrypoint sh copilot-cli
# Puis dans le shell : copilot
```

### Débogage
```bash
# Vérifier que le token est bien chargé
docker exec copilot-cli sh -c 'echo "Token: ${#GH_TOKEN} chars"'

# Accéder au shell pour debug
docker exec -it copilot-cli sh

# Tester manuellement la CLI
docker compose run --rm --entrypoint copilot copilot-cli --version
```

## Configuration et authentification

**Prérequis obligatoire** : créer un fichier `.env` à la racine avec :
```bash
GH_TOKEN=github_pat_...
```

Le token doit être un **Fine-grained PAT** avec la permission **"Copilot Requests"** (voir [AUTH_SETUP.md](../AUTH_SETUP.md) pour le processus complet).

Sans ce token, le serveur Copilot ne pourra pas s'authentifier et les requêtes échoueront.

## Conventions spécifiques

- **Version CLI pinned** : le Dockerfile installe `VERSION="v0.0.400-0"` pour éviter les breaking changes. Pour changer : éditer la ligne RUN curl dans le Dockerfile.
- **Port serveur** : toujours 4321 (hardcodé dans entrypoint.sh et docker-compose.yaml)
- **Workspace mount** : `./workspace` est le répertoire partagé pour échanger des fichiers avec le conteneur
- **Entrypoint override** : pour exécuter autre chose que le serveur, utiliser `--entrypoint` :
  ```bash
  docker compose run --rm --entrypoint sh copilot-cli
  docker compose run --rm --entrypoint copilot copilot-cli --help
  ```

## Dépendances et versions

- Image base : `node:24-slim` (nécessite glibc, pas Alpine, pour compatibilité avec le binaire copilot)
- CLI installée via curl (pas npm) : plus fiable et permet de fixer la version
- Dépendances système : `curl` et `bash` (installées via apt-get dans le Dockerfile)

## Points d'attention

- Le serveur démarre automatiquement au lancement du conteneur (pas besoin de commande manuelle)
- Les logs du serveur sont verbeux grâce à `set -x` dans entrypoint.sh
- Si le container redémarre en boucle : vérifier que GH_TOKEN est défini et valide
- Pour persister la config copilot : monter un volume `~/.config/copilot:/root/.config/copilot`

## Ressources

- [CLI Copilot officielle](https://github.com/github/copilot-cli)
- [SDK Copilot docs](https://github.com/github/copilot-sdk/blob/main/docs/getting-started.md)
- [GitHub PAT settings](https://github.com/settings/personal-access-tokens/new)
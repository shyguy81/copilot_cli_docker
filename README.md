# Copilot CLI - Configuration Docker

Configuration Docker pour exécuter la CLI GitHub Copilot en mode serveur, permettant l'intégration d'agents IA dans vos applications.

## Prérequis

- Docker et Docker Compose
- Un token GitHub avec la permission **"Copilot Requests"** (voir [Configuration](#configuration))

## Installation rapide

```bash
# 1. Cloner le dépôt (si nécessaire)
git clone <url-du-repo>
cd copilot_cli

# 2. Créer le fichier .env avec votre token GitHub
echo "GH_TOKEN=github_pat_..." > .env

# 3. Construire l'image
docker compose build

# 4. Démarrer le serveur
docker compose up -d

# 5. Vérifier que le serveur fonctionne
docker compose logs -f copilot-cli
```

Le serveur Copilot sera accessible sur **http://localhost:4321**

## Configuration

### 1. Créer un Personal Access Token (PAT)

1. Aller sur https://github.com/settings/personal-access-tokens/new
2. Créer un **Fine-grained token** avec :
   - Nom : "Copilot CLI Docker"
   - Expiration : 90 jours (ou plus)
   - Permission : ✅ **"Copilot Requests"** (obligatoire)
3. Générer et copier le token (`github_pat_...`)

### 2. Configurer le fichier .env

Créer un fichier `.env` à la racine du projet :

```bash
GH_TOKEN=github_pat_VOTRE_TOKEN_ICI
```

⚠️ **Important** : Ne jamais commiter le fichier `.env` !

Pour plus de détails, consultez [AUTH_SETUP.md](AUTH_SETUP.md).

## Utilisation

### Mode serveur (par défaut)

Le conteneur démarre automatiquement en mode serveur sur le port 4321 :

```bash
# Démarrer le serveur
docker compose up -d

# Voir les logs
docker compose logs -f copilot-cli

# Arrêter le serveur
docker compose down
```

### Mode CLI interactif

Pour utiliser la CLI en mode interactif :

```bash
# Ouvrir un shell dans le conteneur
docker compose run --rm --entrypoint sh copilot-cli

# Puis exécuter copilot
copilot
```

### Commandes utiles

```bash
# Rebuild complet (si changement de version)
docker compose build --no-cache

# Vérifier que le token est configuré
docker exec copilot-cli sh -c 'echo "Token: ${#GH_TOKEN} chars"'

# Tester la version de Copilot
docker compose run --rm --entrypoint copilot copilot-cli --version

# Accéder au shell pour debug
docker exec -it copilot-cli sh
```

## Structure du projet

```
.
├── Dockerfile              # Image node:24-slim + CLI Copilot v0.0.400-0
├── docker-compose.yaml     # Service exposant le port 4321
├── entrypoint.sh          # Script de démarrage du serveur
├── .env                   # Token GitHub (à créer, non versionné)
├── workspace/             # Répertoire partagé avec le conteneur
└── AUTH_SETUP.md          # Guide détaillé d'authentification
```

### Détails techniques

- **Image base** : `node:24-slim` (nécessite glibc pour le binaire copilot)
- **Installation CLI** : via `curl -fsSL https://gh.io/copilot-install` avec version fixée (`v0.0.400-0`)
- **Port serveur** : 4321 (hardcodé)
- **Volume partagé** : `./workspace` → `/workspace`

## Dépannage

### Le conteneur redémarre en boucle

Vérifier que le token GitHub est bien défini dans `.env` :
```bash
cat .env
docker exec copilot-cli sh -c 'echo $GH_TOKEN'
```

### Erreur d'authentification

Vérifier que le token a la permission **"Copilot Requests"** :
- https://github.com/settings/personal-access-tokens

### Changer la version de Copilot CLI

Éditer le `Dockerfile` et modifier la ligne :
```dockerfile
RUN curl -fsSL https://gh.io/copilot-install | VERSION="v0.0.XXX-X" bash
```

Puis rebuild :
```bash
docker compose build --no-cache
```

## Ressources

- [GitHub Copilot CLI](https://github.com/github/copilot-cli)
- [Copilot SDK Documentation](https://github.com/github/copilot-sdk/blob/main/docs/getting-started.md)
- [Gérer vos tokens GitHub](https://github.com/settings/personal-access-tokens)

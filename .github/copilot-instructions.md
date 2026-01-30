<!-- Instructions concises pour les agents IA travaillant sur ce dépôt -->
# Copilot instructions for this repository

Objectif rapide
- Ce dépôt fournit une configuration minimale Docker pour exécuter la CLI GitHub Copilot dans un conteneur léger.

Fichiers clés
- `Dockerfile` : image basée sur `node:20-alpine`, installe la CLI via `npm install -g @github/copilot` et expose `copilot` comme `ENTRYPOINT`.
- `docker-compose.yaml` : service `copilot-cli` qui monte `./workspace` → `/workspace`, et active `stdin_open`/`tty` pour l'interaction.
- `README.md` : commandes d'utilisation et exemples (build + run).

Architecture et flux de travail
- Architecture : un seul service conteneurisé — pas d'API ou de backend multiples dans ce dépôt.
- Flux principal : build de l'image → exécution de la commande `copilot` dans le conteneur.

Commandes essentielles (exemples réutilisables)
- Construire l'image :
  - `docker compose build` (ou `docker-compose build` selon votre version)
- Lancer `copilot --help` :
  - `docker compose run --rm copilot-cli`
- Lancer une commande `copilot` spécifique :
  - `docker compose run --rm copilot-cli [commande] [options]`
- Ouvrir un shell dans le conteneur (débogage / login interactif) :
  - `docker compose run --rm --entrypoint sh copilot-cli`

Conventions de projet
- Répertoire de travail : le dépôt monte `./workspace` dans le conteneur à `/workspace`. Placer les fichiers à traiter dans `workspace/`.
- Entrypoint CLI : le conteneur attend que `copilot` soit exécuté directement ; pour exécuter d'autres outils, override l'`--entrypoint`.

Dépendances et points d'intégration
- Image base : `node:20-alpine` — si vous changez la méthode d'installation (curl|bash), ajoutez `curl` et `bash` dans le `Dockerfile`.
- Installation : le `Dockerfile` actuel utilise `npm install -g @github/copilot`. Alternativement l'installateur shell public est `curl -fsSL https://gh.io/copilot-install | bash` (nécessite `curl` et `bash`).

Notes pratiques pour un agent IA
- Chercher les commandes `docker compose` / `docker-compose` et utiliser l'une ou l'autre selon l'environnement CI/loc.
- Pour reproduire un problème localement, exécuter `docker compose run --rm --entrypoint sh copilot-cli` et lancer `copilot` manuellement.
- Si la CLI requiert authentification GitHub, suivre le flux interactif depuis le shell du conteneur ; pour persister les tokens, monter un volume depuis l'hôte (par ex. `- ~/.config/copilot:/root/.config/copilot`).

Ce que je n'ai pas trouvé
- Pas de tests, pas de scripts de build additionnels, ni de conventions spécifiques de code (formatters, lints) dans ce dépôt minimal.

Questions pour vous
- Voulez‑vous que j'ajoute des exemples de montage de configuration utilisateur (persist token) ?

# Ressources utiles

- https://github.com/github/copilot-cli
- https://github.com/github/copilot-sdk/blob/main/docs/getting-started.md
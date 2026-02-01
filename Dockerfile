# Utiliser une image avec glibc pour compatibilité avec le binaire copilot
FROM node:24-slim

# Installer curl et bash pour l'installation de Copilot CLI
RUN apt-get update && apt-get install -y curl bash && rm -rf /var/lib/apt/lists/*

# Installation de la CLI copilot via curl (version spécifique)
RUN curl -fsSL https://gh.io/copilot-install | VERSION="v0.0.400-0" bash

# Définir le répertoire de travail
WORKDIR /workspace

LABEL org.opencontainers.image.source=https://github.com/shyguy81/copilot_cli_docker
LABEL org.opencontainers.image.description="Docker image for Copilot CLI running in server mode"
LABEL org.opencontainers.image.licenses=MIT

# Copier le script wrapper
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Exposer le port 4321
EXPOSE 4321

# Point d'entrée pour exécuter la commande copilot en mode serveur
ENTRYPOINT ["/entrypoint.sh"]
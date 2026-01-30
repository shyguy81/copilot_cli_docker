FROM node:20-alpine

# Installation de la CLI copilot
# RUN npm install -g @github/copilot
RUN npm install -g @github/copilot@prerelease

# Définir le répertoire de travail
WORKDIR /workspace

# Exposer le port 4321
EXPOSE 4321

# Point d'entrée pour exécuter la commande copilot
ENTRYPOINT ["copilot", "--server", "--port", "4321"]
# CMD ["--help"]
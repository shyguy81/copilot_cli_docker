FROM node:20-alpine

# Installation de la CLI copilot
RUN npm install -g @github/copilot

# Définir le répertoire de travail
WORKDIR /workspace

# Point d'entrée pour exécuter la commande copilot
ENTRYPOINT ["copilot"]
CMD ["--help"]
# Configuration de l'authentification GitHub Copilot CLI

## ✅ Ce que vous avez fait (correct)

Vous avez ajouté `GH_TOKEN=${GH_TOKEN}` dans [docker-compose.yaml](docker-compose.yaml), ce qui est **nécessaire**.

## ⚠️ Ce qu'il manque

Il faut maintenant **créer le token et le définir**. Voici comment :

### 1. Créer un Fine-grained Personal Access Token (PAT)

1. Aller sur https://github.com/settings/personal-access-tokens/new
2. Donner un nom au token (ex: "Copilot CLI Docker")
3. Choisir l'expiration (ex: 90 jours)
4. Sous **"Permissions"**, cliquer sur **"add permissions"**
5. ✅ **Sélectionner "Copilot Requests"** (OBLIGATOIRE)
6. Cliquer sur **"Generate token"**
7. **Copier le token** (commence par `github_pat_...`)

### 2. Créer le fichier `.env`

```bash
# Copier le template
cp .env.example .env

# Éditer et remplacer YOUR_TOKEN_HERE par votre token
nano .env  # ou vim, code, etc.
```

Le fichier `.env` doit contenir :
```bash
GH_TOKEN=github_pat_11AABCDEF...VOTRE_TOKEN...XYZ
```

### 3. Relancer le conteneur

```bash
docker compose down
docker compose up -d
```

### 4. Vérifier que le token est bien passé

```bash
# Vérifier que la variable n'est plus vide
docker exec copilot-cli sh -c 'echo "Token length: ${#GH_TOKEN}"'

# Si > 0, c'est bon !
```

### 5. Tester Copilot CLI

```bash
# Entrer dans le conteneur
docker exec -it copilot-cli sh

# Dans le shell, lancer copilot (mode interactif)
copilot

# Ou lancer directement le serveur
copilot --server --port 4321
```

## 🔐 Sécurité

- ⚠️ **NE PAS commit le fichier `.env`** (déjà dans .gitignore normalement)
- Le token donne accès à Copilot, donc le protéger
- Révoquer le token si compromis : https://github.com/settings/personal-access-tokens

## 📝 Alternative : variable d'environnement système

Au lieu du fichier `.env`, vous pouvez exporter la variable sur l'hôte :

```bash
export GH_TOKEN="github_pat_..."
docker compose up -d
```

## ✅ Résumé

**Votre configuration est correcte**, il ne manque plus que :
1. Créer le PAT avec permission "Copilot Requests"
2. Le mettre dans `.env`
3. Relancer le conteneur

Ensuite `copilot` devrait fonctionner ! 🚀

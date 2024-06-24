#!/bin/bash

# idk this does some important shit ig
set -e

sudo apt update

# Step 0: Install Dependencies
echo "Installing dependencies..."
sudo apt install -y git apt-transport-https software-properties-common

echo "Installing GH CLI..."
if ! command -v wget &> /dev/null; then
    sudo apt update && sudo apt-get install wget -y
fi
sudo mkdir -p -m 755 /etc/apt/keyrings
wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh -y

echo "Authenticating GH CLI..."
gh auth login

echo "Installing Docker..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Installing Nginx..."
sudo apt install -y nginx

echo "Installing MariaDB..."
bash <(curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup)
sudo apt update
sudo apt install mariadb-server

# Step 1: Clone the Repository
echo "Cloning the repository..."
gh repo clone Axsoter/keycloak-dockerfiles
cd keycloak-dockerfiles

# Step 2: Build the Docker Image
echo "Building Docker image..."
read -p "Enter Keycloak Admin Username: " keycloak_admin
read -sp "Enter Keycloak Admin Password: " keycloak_password
echo

read -p "Enter MariaDB Database Host: " db_host
read -p "Enter MariaDB Database Name: " db_name
read -p "Enter MariaDB Database Username: " db_username
read -sp "Enter MariaDB Database Password: " db_password
echo

sed -i "s/KEYCLOAK_ADMIN=.*/KEYCLOAK_ADMIN=$keycloak_admin/" Dockerfile
sed -i "s/KEYCLOAK_ADMIN_PASSWORD=.*/KEYCLOAK_ADMIN_PASSWORD=$keycloak_password/" Dockerfile
sed -i "s/KC_DB_URL_HOST=.*/KC_DB_URL_HOST=$db_host/" Dockerfile
sed -i "s/KC_DB_URL_DATABASE=.*/KC_DB_URL_DATABASE=$db_name/" Dockerfile
sed -i "s/KC_DB_USERNAME=.*/KC_DB_USERNAME=$db_username/" Dockerfile
sed -i "s/KC_DB_PASSWORD=.*/KC_DB_PASSWORD=$db_password/" Dockerfile

chmod +x build_keycloak.sh
./build_keycloak.sh

# Step 3: Create and Enable the Systemd Service
echo "Creating and enabling systemd service..."
sudo cp keycloak.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable keycloak.service
sudo systemctl start keycloak.service

# Step 4: Configure Nginx
echo "Configuring Nginx..."

read -p "Enter your domain name (e.g., login.example.com): " domain_name
sudo cp sites-available/login.axsoter.com /etc/nginx/sites-available/"$domain_name"
sudo ln -s /etc/nginx/sites-available/"$domain_name" /etc/nginx/sites-enabled/
sudo sed -i "s/server_name login.axsoter.com;/server_name $domain_name;/" /etc/nginx/sites-available/"$domain_name"
sudo nginx -t
sudo systemctl reload nginx

# Step 5: Set Up HTTPS with Certbot
echo "Setting up HTTPS with Certbot..."
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d $domain_name
sudo certbot renew --dry-run


echo "Installation and configuration complete."

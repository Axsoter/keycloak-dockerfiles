# yeah

## Installation tutorial
### Automagically
**You first need to manually install MariaDB and setup the accounts and databases**
MariaDB downloader and installer:
```sh
bash <(curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup) && sudo apt update && sudo apt install mariadb-server
```

After that is done just do
```sh
bash <(curl -s https://raw.githubusercontent.com/Axsoter/keycloak-dockerfiles/main/ubuntu.sh)
```

### Manually
### Step 0: Dependencies 
- [GH CLI](https://github.com/cli/cli#installation)
- [Docker](https://docs.docker.com/engine/install/)
- [MariaDB](https://mariadb.org/download/?t=repo-config)
- [nginx](http://nginx.org/en/linux_packages.html)

You need to setup your DB accounts and other stuff BEFORE you start anything here (or after, it just won't work before you do it).

### Step 1: Clone the Repository

First, clone the repository containing all the necessary files.

```sh
gh repo clone Axsoter/keycloak-dockerfiles
cd keycloak-dockerfiles
```

### Step 2: Build the Docker Image

1. **Enter username and password**:
   Change the `KEYCLOAK_ADMIN`, `KEYCLOAK_ADMIN_PASSWORD`, `KC_DB_URL_HOST`, `KC_DB_URL_DATABASE`, `KC_DB_USERNAME` and `KC_DB_PASSWORD` fields inside Dockerfile (`nano Dockerfile`) to your wanted admin credentials and current database credentials.

2. **Run the Build Script**:
    ```sh
    chmod +x build_keycloak.sh
    ./build_keycloak.sh
    ```

### Step 3: Create and Enable the Systemd Service

1. **Copy the Service File**:
    ```sh
    sudo cp keycloak.service /etc/systemd/system/
    ```

2. **Reload Systemd**:
    ```sh
    sudo systemctl daemon-reload
    ```

3. **Enable and Start the Service**:
    ```sh
    sudo systemctl enable keycloak.service
    sudo systemctl start keycloak.service
    ```

### Step 4: Configure Nginx

0. **IMPORTANT**;
   Please change the domain otherwise it WON'T WORK.

1. **Copy the Nginx Configuration File**:
    ```sh
    sudo cp sites-available/login.axsoter.com /etc/nginx/sites-available/
    ```

2. **Enable the Site**:
    ```sh
    sudo ln -s /etc/nginx/sites-available/login.axsoter.com /etc/nginx/sites-enabled/
    ```

3. **Test Nginx Configuration**:
    ```sh
    sudo nginx -t
    ```

4. **Reload Nginx**:
    ```sh
    sudo systemctl reload nginx
    ```

### Step 5: Set Up HTTPS with Certbot

0. **IMPORTANT**;
   Same as Step 4

1. **Install Certbot**:
    ```sh
    sudo apt install certbot python3-certbot-nginx
    ```

2. **Obtain and Install the Certificate**:
    ```sh
    sudo certbot --nginx -d login.axsoter.com
    ```

3. **Follow the Prompts**: Certbot will automatically configure Nginx to use the SSL certificate.

4. **Renewal**: Certbot sets up automatic renewal, but you can test it with:
    ```sh
    sudo certbot renew --dry-run
    ```

## Repository Structure

```
keycloak-dockerfiles
├── Dockerfile
├── build_keycloak.sh
├── keycloak.service
└── sites-available/
    └── login.axsoter.com
```

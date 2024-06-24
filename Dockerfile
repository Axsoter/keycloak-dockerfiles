# Use the Keycloak image from quay.io as the base image
FROM quay.io/keycloak/keycloak:25.0.1

# Set environment variables for Keycloak admin user
ENV KEYCLOAK_ADMIN=insert_admin_username
ENV KEYCLOAK_ADMIN_PASSWORD=insert_admin_password

# Set environment variables for Keycloak hostname and proxy settings
ENV KC_HOSTNAME=internalKeycloak
ENV KC_PROXY=edge

# Set environment variables for the MariaDB database
ENV KC_DB=mariadb
ENV KC_DB_URL_HOST=insert_db_host
ENV KC_DB_URL_DATABASE=insert_db_name
ENV KC_DB_USERNAME=insert_db_username
ENV KC_DB_PASSWORD=insert_db_password

# Expose the port that Keycloak will run on (PLEASE DON'T CHANGE THIS)
EXPOSE 8080

# Add health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s CMD curl -f http://localhost:8080/health || exit 1

# Command to run Keycloak
ENTRYPOINT ["./kc.sh", "start", "--optimized"]

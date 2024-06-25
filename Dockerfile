FROM quay.io/keycloak/keycloak:latest as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Set environment variables for Keycloak admin user
ENV KEYCLOAK_ADMIN=insert_admin_username
ENV KEYCLOAK_ADMIN_PASSWORD=insert_admin_password

# Set environment variables for Keycloak proxy settings
ENV KC_PROXY=edge

# Set environment variables for the MariaDB database
ENV KC_DB=mariadb
ENV KC_DB_URL_HOST=insert_db_host
ENV KC_DB_URL_DATABASE=insert_db_name
ENV KC_DB_USERNAME=insert_db_username
ENV KC_DB_PASSWORD=insert_db_password

# Expose the port that Keycloak will run on (PLEASE DON'T CHANGE THIS)
EXPOSE 8080

WORKDIR /opt/keycloak
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Command to run Keycloak
ENV KC_HOSTNAME=localhost
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]

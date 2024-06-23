# Use the Keycloak image from quay.io as the base image
FROM quay.io/keycloak/keycloak:25.0.1

# Set environment variables for Keycloak admin user
ENV KEYCLOAK_ADMIN=[INSERT KEYCLOAK ADMIN USERNAME]
ENV KEYCLOAK_ADMIN_PASSWORD=[INSERT KEYCLOAK ADMIN PASSWORD]

# Expose the port that Keycloak will run on (PLEASE DON'T CHANGE THIS)
EXPOSE 8080

# Command to run Keycloak in development mode
ENTRYPOINT ["start-dev"]

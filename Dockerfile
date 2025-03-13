FROM alpine:3.21.3

RUN apk add --no-cache curl

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENV TEST_URL="https://www.google.com"
ENV INTERVAL=5
ENV TIMEOUT=15
ENV LOG_ALIVE=30

# Définir les variables
ENV SENDER_API_URL="http://127.0.0.1:5000/send"
ENV ADMIN_PHONES="0123456789"
ENV LAB_NAME="TibHome"

# Définir le script d'entrée
ENTRYPOINT ["sh", "/entrypoint.sh"]
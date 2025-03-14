FROM alpine:3.21.3

RUN apk add --no-cache curl

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENV TEST_IP="8.8.8.8"
ENV INTERVAL=5
ENV TIMEOUT=15
ENV LOG_ALIVE=30

ENV SENDER_API_URL="http://127.0.0.1:5000/send"
ENV ADMIN_PHONES="0123456789"
ENV LAB_NAME="TibHome"

ENTRYPOINT ["sh", "/entrypoint.sh"]
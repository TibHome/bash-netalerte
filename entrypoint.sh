#!/bin/sh

IS_DOWN=0
COUNT=0

if [ -f "/config.conf" ]; then
    source "/config.conf"
fi

mylog() {
    echo "$(date -u +"%Y-%m-%dT%H:%M:%S") - $1"
}

alerte_admin() {
    echo "[NetAlerte]" > /tmp/msg
    echo "${1}" >> /tmp/msg

    curl -s \
        --location "${SENDER_API_URL}" \
        --header 'Content-Type: application/x-www-form-urlencoded' \
        --data-urlencode "recipient=${ADMIN_PHONES}" \
        --data-urlencode "message=$(cat /tmp/msg)" \
        > /dev/null
}

while true; do
    ping -c 1 -W 2 ${TEST_IP} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        if [[ "${IS_DOWN}" -eq 1 ]]; then
            mylog "Send message to admin (BACK)"
            alerte_admin "Connection back"
            IS_DOWN=0
        else
            COUNT=$((COUNT + 1))
            elapsed_time=$((COUNT * INTERVAL))
            if [ $((elapsed_time % LOG_ALIVE)) -eq 0 ]; then
                mylog "Connection good"
            fi
        fi
        DOWN_TIME=0
    else
        DOWN_TIME=$((DOWN_TIME + INTERVAL))
        if [[ "${DOWN_TIME}" -ge "${TIMEOUT}" && "${IS_DOWN}" -eq 0 ]]; then
            mylog "Send message to admin (LOSS)"
            alerte_admin "Connection loss"
            IS_DOWN=1
        else
            mylog "Connection loss"
        fi
    fi
    sleep "${INTERVAL}"
done
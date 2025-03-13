#!/bin/sh

IS_DOWN=0
COUNT=0

mylog() {
    echo "$(date -u +"%Y-%m-%dT%H:%M:%S") - $1"
}

alerte_admin() {
MESSAGE="[NetAlerte]
${1}"

curl -s \
     --location "${SENDER_API_URL}" \
     --header 'Content-Type: application/x-www-form-urlencoded' \
     --data-urlencode "recipient=${ADMIN_PHONES}" \
     --data-urlencode "message=${MESSAGE}" \
     > /dev/null
}

while true; do
    curl -s --head --connect-timeout 5 ${TESt_URL} > /dev/null
    if [ $? -eq 0 ]; then
        if [[ "${IS_DOWN}" -eq 1 ]]; then
            mylog "Connection back"
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
            mylog "Connection loss"
            alerte_admin "Connection loss"
            IS_DOWN=1
        fi
    fi
    sleep "${INTERVAL}"
done
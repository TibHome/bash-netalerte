# bash-netalerte
Bsh script for alerting when connection loss

## Overview
NetAlert is a simple monitoring script that checks the connectivity of a specified URL. If the connection is lost for a defined period, it sends an alert to the administrator. Once the connection is restored, another notification is sent.

## Features
- Periodic connectivity checks to a target URL.
- Logs connection status at defined intervals.
- Sends alerts to administrators when a connection loss is detected and when it is restored.
- Configurable parameters via environment variables.
- Lightweight implementation using Alpine Linux and cURL.

## Components
### **entrypoint.sh**
This is the main script responsible for monitoring the target URL and sending alerts.

### **Dockerfile**
Defines a lightweight container environment for running the monitoring script.

## How It Works
1. The script continuously checks the target URL (`TEST_URL`).
2. If the connection is lost beyond the timeout limit (`TIMEOUT`), an alert is sent.
3. Once the connection is restored, another notification is sent.
4. Status logs are periodically recorded based on (`LOG_ALIVE`).

## Installation & Usage

### **Building the Docker Image**
```sh
docker build -t bash-netalert .
```

### **Running the Container (basic way)**
```sh
docker run -d --net host \
           --name netalerte \
           -e TEST_URL="https://www.google.com" \
           -e INTERVAL=5 \
           -e TIMEOUT=15 \
           -e LOG_ALIVE=30 \
           -e SENDER_API_URL="http://127.0.0.1:5000/send" \
           -e ADMIN_PHONES="0123456789" \
           -e LAB_NAME="TibHome" \
           tibhome/bash-netalert:main
```

### **Running the Container (external config file)**
```sh
docker run -d --net host \
            --name netalerte \
            -v /my/path/config.conf:/config.conf \
           tibhome/bash-netalert:main
```

### Environment Variables

| Variable        | Description                              | Default Value                      |
|---------------|----------------------------------|--------------------------------|
| `TESt_URL`    | URL to monitor                   | `https://www.google.com`      |
| `INTERVAL`    | Time interval between checks (s)  | `5`                            |
| `TIMEOUT`     | Time before an alert is sent (s) | `15`                           |
| `LOG_ALIVE`   | Logging interval (s)             | `30`                           |
| `SENDER_API_URL` | API endpoint to send alerts   | `http://127.0.0.1:5000/send`   |
| `ADMIN_PHONES` | Phone number(s) for alerts      | `0123456789`                   |
| `LAB_NAME`    | Identifier for logs              | `TibHome`                      |

## Alerting Mechanism
When a connection loss is detected, an alert is sent using a predefined API ([sms-sender-api](https://github.com/TibHome/sms-sender-api)
).

The message format includes a header [NetAlerte] followed by the status update.

## Logging
- If the connection is stable, logs are written at intervals defined by LOG_ALIVE.
- If the connection is lost, logs will indicate the downtime duration.
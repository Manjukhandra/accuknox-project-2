#!/bin/bash

APP_URL="http://example.com"

check_status() {
    local status_code=$(curl -s -o /dev/null -w "%{http_code}" "$APP_URL")
    if [ "$status_code" == "200" ]; then
        echo "Application is UP"
    else
        echo "Application is DOWN"
    fi
}

check_status


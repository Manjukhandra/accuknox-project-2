#!/bin/bash

CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
if [ $CPU_USAGE -gt $CPU_THRESHOLD ]; then
    echo "CPU usage is above threshold: $CPU_USAGE%"
fi

MEMORY_USAGE=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')
MEMORY_USAGE_INT=$(printf "%.0f" $MEMORY_USAGE)
if [ $MEMORY_USAGE_INT -gt $MEMORY_THRESHOLD ]; then
    echo "Memory usage is above threshold: $MEMORY_USAGE%"
fi

DISK_USAGE=$(df -h | awk '$NF=="/"{printf "%s", $5}' | sed 's/%//')
if [ $DISK_USAGE -gt $DISK_THRESHOLD ]; then
    echo "Disk usage is above threshold: $DISK_USAGE%"
fi

TOP_PROCESSES=$(ps aux --sort=-%cpu | head -n 6)
echo "Top CPU-consuming processes:"
echo "$TOP_PROCESSES"

LOG_FILE="system_health.log"
echo "==========================" >> $LOG_FILE
echo "System Health Report" >> $LOG_FILE
echo "Date: $(date)" >> $LOG_FILE
echo "CPU usage: $CPU_USAGE%" >> $LOG_FILE
echo "Memory usage: $MEMORY_USAGE%" >> $LOG_FILE
echo "Disk usage: $DISK_USAGE%" >> $LOG_FILE
echo "Top CPU-consuming processes:" >> $LOG_FILE
echo "$TOP_PROCESSES" >> $LOG_FILE



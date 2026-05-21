#!/bin/bash

# 查找Zookeeper的PID
zoo_pid=$(ps aux | grep 'QuorumPeerMain' | grep -v grep | awk '{print $2}')

# 查找Kafka的PID
kafka_pid=$(ps aux | grep 'kafka.Kafka' | grep -v grep | awk '{print $2}')

# 检查并杀掉Zookeeper进程
if [ -n "$zoo_pid" ]; then
    echo "Killing Zookeeper with PID: $zoo_pid"
    kill -9 $zoo_pid
else
    echo "No running Zookeeper process found."
fi

# 检查并杀掉Kafka进程
if [ -n "$kafka_pid" ]; then
    echo "Killing Kafka with PID: $kafka_pid"
    kill -9 $kafka_pid
else
    echo "No running Kafka process found."
fi
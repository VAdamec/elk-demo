#!/bin/bash
mkdir -p ./backup
docker-compose up -d fluentd
sleep 10
docker-compose up -d

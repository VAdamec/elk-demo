#!/usr/bin/env bash

# Wait for the Elasticsearch container to be ready before starting Kibana.
 echo "Stalling for Elasticsearch - wait for 172.22.0.10:9200"
 while true; do
     nc -q 1 172.22.0.10 9200 2>/dev/null && break
 done

echo "Starting Kibana"
exec kibana

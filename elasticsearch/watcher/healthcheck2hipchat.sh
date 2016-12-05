curl -XPUT 'localhost:9200/_watcher/watch/cluster_red_alert?pretty' -d'
{
  "trigger": {
    "schedule": {
      "interval": "1m"
    }
  },
  "input": {
    "search": {
      "request": {
        "indices": ".marvel-es-1-*",
        "types": "cluster_state",
        "body": {
          "query": {
            "bool": {
              "filter": [
                {
                  "range": {
                    "timestamp": {
                      "gte": "now-2m",
                      "lte": "now"
                    }
                  }
                },
                {
                  "terms": {
                    "cluster_state.status": ["green", "yellow", "red"]
                  }
                }
              ]
            }
          },
          "_source": [
            "cluster_state.status"
          ],
          "sort": [
            {
              "timestamp": {
                "order": "desc"
              }
            }
          ],
          "size": 1,
          "aggs": {
            "minutes": {
              "date_histogram": {
                "field": "timestamp",
                "interval": "5s"
              },
              "aggs": {
                "status": {
                  "terms": {
                    "field": "cluster_state.status",
                    "size": 3
                  }
                }
              }
            }
          }
        }
      }
    }
  },
  "throttle_period": "30m",
  "condition": {
    "script": {
      "inline": "if (ctx.payload.hits.total < 1) return false; def rows = ctx.payload.hits.hits; if (rows[0]._source.cluster_state.status != \u0027red\u0027) return false; if (ctx.payload.aggregations.minutes.buckets.size() < 12) return false; def last60Seconds = ctx.payload.aggregations.minutes.buckets[-12..-1]; return last60Seconds.every { it.status.buckets.every { s -> s.key == \u0027red\u0027 }}"
    }
  },
  "actions" : {
    "notify-hipchat" : {
      "throttle_period" : "5m",
      "hipchat" : {
        "account" : "hipchat-account1",
        "message" : {
          "body" : "Watcher Notification - Your cluster has been red for the last 60 seconds.",
          "format" : "text",
          "color" : "red",
          "notify" : true
        }
      }
    }
  }
}'

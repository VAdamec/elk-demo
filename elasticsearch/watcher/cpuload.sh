curl -XPUT 'localhost:9200/_watcher/watch/cpu_usage?pretty' -d'
{
  "trigger": {
    "schedule": {
      "interval": "1m"
    }
  },
  "input": {
    "search": {
      "request": {
        "indices": [
          ".marvel-es-1-*"
        ],
        "types" : [
          "node_stats"
        ],
        "body": {
          "size" : 0,
          "query": {
            "filtered": {
              "filter": {
                "range": {
                  "timestamp": {
                    "gte": "now-2m",
                    "lte": "now"
                  }
                }
              }
            }
          },
          "aggs": {
            "minutes": {
              "date_histogram": {
                "field": "timestamp",
                "interval": "minute"
              },
              "aggs": {
                "nodes": {
                  "terms": {
                    "field": "source_node.name",
                    "size": 10,
                    "order": {
                      "cpu": "desc"
                    }
                  },
                  "aggs": {
                    "cpu": {
                      "avg": {
                        "field": "node_stats.process.cpu.percent"
                      }
                    }
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
    "script":  "if (ctx.payload.aggregations.minutes.buckets.size() == 0) return false; def latest = ctx.payload.aggregations.minutes.buckets[-1]; def node = latest.nodes.buckets[0]; return node && node.cpu && node.cpu.value >= 75;"
  },
  "actions" : {
    "notify-hipchat" : {
      "transform": {
        "script": "def latest = ctx.payload.aggregations.minutes.buckets[-1]; return latest.nodes.buckets.findAll { return it.cpu && it.cpu.value >= 75 };"
      },
      "throttle_period" : "5m",
      "hipchat" : {
        "account" : "hipchat-account1",
        "message" : {
          "body" : "Nodes with HIGH CPU Usage (above 75%):\n\n{{#ctx.payload._value}}\"{{key}}\" - CPU Usage is at {{cpu.value}}%\n{{/ctx.payload._value}}",
          "format" : "text",
          "color" : "red",
          "notify" : true
        }
      }
    }
  }
}'

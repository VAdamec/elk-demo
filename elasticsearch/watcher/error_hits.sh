curl -XPUT 'localhost:9200/_watcher/watch/log_event_watch?pretty' -d'
{
  "metadata" : {
    "color" : "red"
  },
  "trigger" : {
    "schedule" : {
      "interval" : "5m"
    }
  },
  "input" : {
    "search" : {
      "request" : {
        "indices" : "logstash*",
        "body" : {
          "size" : 0,
          "query" : { "match" : { "status" : "error" } }
        }
      }
    }
  },
  "condition" : {
    "script" : "return ctx.payload.hits.total > 5"
  },
  "actions" : {
    "email_administrator" : {
      "throttle_period": "15m",
      "email" : {
        "to" : "vaclav.adamec@netsuite.com"
        "subject" : "Encountered {{ctx.payload.hits.total}} errors",
        "body" : "Too many error in the system, see attached data",
        "attachments" : {
          "attached_data" : {
            "data" : {
              "format" : "json"
            }
          }
        },
        "priority" : "high"
      }
    }
  }
}'

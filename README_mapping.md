# Mapping handling
* logstash/fluent side
* elasticsearch templates

## Get templates overview

```bash
curl -XGET http://localhost:9200/_template\?pretty
```

## Get exact template setup

```bash
curl -XGET http://localhost:9200/_template/http-log-logstash?pretty
```

## Delete template

```bash
curl -XDELETE http://localhost:9200/_template/http-log-logstash
```

## Mapping examples

```
curl -XPUT 'localhost:9200/_template/all' -d '
{
"order": 0,
"template": "*",
"settings": {
"index.number_of_shards": "1"
},
"mappings": {
"default": {
"dynamic_templates": [
{
"string": {
"mapping": {
"index": "not_analyzed",
"type": "string"
},
"match_mapping_type": "string"
}
}
]
}
},
"aliases": {}
}
}
'
```


## List mappings

```
curl -XGET 'http://localhost:9200/demo/_mapping'
```

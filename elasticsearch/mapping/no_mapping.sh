curl -XPUT 'localhost:9200/_template/all' -d '
{
"order": 0,
"template": "*",
"settings": {
"index.number_of_shards": "2"
"index.number_of_replicas": "1"
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

# Workshop items

## Getting know ELK stack components
* HTTP API on port tcp:9200
* Cluster communication on port tcp:9300

### Elasticsearch
* Cluster, nodes
* Indices/indexes
* Shards, replicas
* Terms (analyzed vs raw)
* Filters
* Calculated fields

```cluster``` – An Elasticsearch cluster consists of one or more nodes and is identifiable by its cluster name.

```node``` – A single Elasticsearch instance. In most environments, each node runs on a separate box or virtual machine.

```node.data``` - node take care about data storage (datas physicaly stored on them)
```node.master``` - node is part of cluster logic, based on quorum these nodes take care about data routing, rebalancing, replicas placement, ...
```node.gateway``` - not a part of cluster quorum, not store datas, but do routing of requests to data nodes and caches for results

```index``` – In Elasticsearch, an index is a collection of documents.

```shard``` – Because Elasticsearch is a distributed search engine, an index is usually split into elements known as shards that are distributed across multiple nodes. Elasticsearch automatically manages the arrangement of these shards. It also rebalances the shards as necessary, so users need not worry about the details.

```replica``` – By default, Elasticsearch creates five primary shards and one replica for each index. This means that each index will consist of five primary shards, and each shard will have one copy.

Allocating multiple shards and replicas is the essence of the design for distributed search capability, providing for high availability and quick access in searches against the documents within an index. The main difference between a primary and a replica shard is that only the primary shard can accept indexing requests. Both replica and primary shards can serve querying requests.

#### Head
* http://localhost:9200/_plugin/head/

### Kibana
* http://localhost:5601/app/kibana

### Plugins
* licencing (plugin and licence upload)
* old version need to be removed first
* plugins version need to match ELK version

````
VERSION="2.4.1"
wget "https://download.elastic.co/elasticsearch/release/org/elasticsearch/plugin/license/${VERSION}/license-${VERSION}.zip"
bin/plugin remove license
bin/plugin install file:///root/license-${VERSION}.zip

curl -XPUT -u admin -p admin 'http://localhost:9200/_license?acknowledge=true' -d @/root/vaclav-adamec-ca71504c-0562-4d0c-97c3-643e4e54140a.json
````
* licence example:

````
{"license":{"uid":"ca71504c-....140a","type":"basic","issue_date_in_millis":1469750400000,"expiry_date_in_millis":1507075199999,"max_nodes":100,"issued_to":"vaclav adamec (AVAST)","issuer":"Web Form","signature":"AAAAAgAAA....Z+mAmk"}}
````

#### Marvel
* http://localhost:5601/app/marvel

````
wget -c "https://download.elastic.co/elasticsearch/release/org/elasticsearch/plugin/marvel-agent/${VERSION}/marvel-agent-${VERSION}.zip"
bin/plugin remove marvel-agent
bin/plugin install file:///root/marvel-agent-${VERSION}.zip

curl -XPUT -u admin -p admin 'http://localhost:9200/_license?acknowledge=true' -d @/root/vaclav-adamec-ca71504c-0562-4d0c-97c3-643e4e54140a.json
````

### Special plugins

#### Watcher
* https://www.elastic.co/guide/en/watcher/current/installing-watcher.html
* examples elasticsearch/watcher
  * Cluster state + send info to Hipchat
  * CPU overload + send info to Hipchat
````
/usr/share/elasticsearch/bin/plugin install watcher
````

#### Shield
* https://www.elastic.co/guide/en/shield/current/installing-shield.html
Security for Elasticsearch, Shield protects Elasticsearch clusters by:
* Preventing unauthorized access with password protection, role-based access control, and IP filtering.
* Preserving the integrity of your data with message authentication and SSL/TLS encryption.
* Maintaining an audit trail so you know who’s doing what to your data.
````
/usr/share/elasticsearch/bin/plugin install marvel-agent
````

#### KAAE
* https://github.com/elasticfence/kaae
* opensource variant of Watcher
* still in development, not production ready

#### Sense
* http://localhost:5601/app/sense

# HandsOn time

1. Add new mapping

2. Add new index and upload data sample

3. Kibana

 * Create new index
````
nc localhost 5000 < samples/varnishncsa.log
````
 * Setup new indices in Kibana - discoveries
````
http://localhost:5601/app/kibana#/settings/indices
````
 * Vizualization
    * Histogram for all items
    * Histogram for selected "Terms"
````
@fields.final_url_no_param.raw
````
    * Histogram with selected "Filter"
````
@fields.duration_usec: [1000 TO *]
````
 * Dashboards
    * use "Use dark theme"
    * create at least three graphs and search result at bottom
````
http://localhost:5601/app/kibana#/dashboard
````

 * It's API time !!!
    * make backup of logstash index, and then do restore
    * test index relocation (platform index)
    * test Curator setup

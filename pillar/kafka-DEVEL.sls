kafka:
  manage: true
  user: 'kafka'
  home: '/opt/kafka'
  logdir: '/srv/kafka'
  confdir: '/etc/kafka'
  scala_version: '2.11'
  version: '1.0.0'
  source_hash: 04A88D7B9830E99841A13EC97809E58D0691D185
  hash_type: sha1
  partitions: 3
  replication: 3

zookeeper:
  manage: true
  user: zookeeper
  home: /opt/zookeeper
  logdir: /var/log/zookeeper
  datadir: /var/lib/zookeeper
  confdir: /etc/zookeeper
  version: 3.4.10
  source_hash: eb2145498c5f7a0d23650d3e0102318363206fba
  hash_type: sha1

mine_functions:
  network.interfaces: []
  kafka_cluster_ip_addr:
    mine_function: network.ip_addrs
    cidr: '192.168.56.0/24'

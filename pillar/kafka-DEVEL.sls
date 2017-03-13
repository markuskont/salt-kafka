kafka:
  manage: true
  user: 'kafka'
  home: '/opt/kafka'
  logdir: '/srv/kafka'
  confdir: '/etc/kafka'
  scala_version: '2.11'
  version: '0.10.2.0'
  source_hash: 051e5e16050c85ebdc40f3bbbc188317
  partitions: 3
  replication: 3

zookeeper:
  manage: true
  user: zookeeper
  home: /opt/zookeeper
  logdir: /var/log/zookeeper
  datadir: /var/lib/zookeeper
  confdir: /etc/zookeeper
  version: 3.4.9
  source_hash: 3e8506075212c2d41030d874fcc9dcd2

mine_functions:
  network.interfaces: []
  kafka_cluster_ip_addr:
    mine_function: network.ip_addrs
    cidr: '192.168.56.0/24'

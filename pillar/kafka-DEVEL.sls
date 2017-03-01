kafka:
  manage: true
  user: 'kafka'
  home: '/opt/kafka'
  logdir: '/srv/kafka'
  confdir: '/etc/kafka'
  zookeeper:
    data: '/var/lib/zookeeper'
    log: '/var/log/zookeeper'
  scala_version: '2.11'
  version: '0.10.2.0'
  source_hash: 051e5e16050c85ebdc40f3bbbc188317

mine_functions:
  network.interfaces: []
  kafka_cluster_ip_addr:
    mine_function: network.ip_addrs
    cidr: '192.168.56.0/24'

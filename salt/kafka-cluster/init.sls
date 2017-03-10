zk.setup:
  salt.state:
    - tgt: 'G@roles:zookeeper and G@env:{{ saltenv }}'
    - tgt_type: compound
    - sls: kafka-cluster.zookeeper
    - saltenv: {{ saltenv }}

kafka.setup:
  salt.state:
    - tgt: 'G@roles:kafka and G@env:{{ saltenv }}'
    - tgt_type: compound
    - sls: kafka-cluster.kafka
    - saltenv: {{ saltenv }}

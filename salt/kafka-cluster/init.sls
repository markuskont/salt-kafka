zk.setup:
  salt.state:
    - tgt: 'G@roles:zookeeper and G@env:{{ saltenv }}'
    - tgt_type: compound
    - sls: kafka-cluster.zookeeper
    - saltenv: {{ saltenv }}

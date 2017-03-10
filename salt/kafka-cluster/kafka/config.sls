{% set vars = pillar.kafka %}
{% from "kafka-cluster/connectivity.sls" import id with context %}
{% from "kafka-cluster/connectivity.sls" import zk with context %}

{{ vars.confdir }}/kafka.conf:
  file.managed:
    - mode: 644
    - template: jinja
    - source: salt://kafka-cluster/kafka/etc/kafka/kafka.properties
    - default:
      logdir: {{ vars.logdir }}
      zk: {{ zk }}
      id: {{ id }}
    - require:
      - {{ vars.logdir }}
      - {{ vars.confdir }}

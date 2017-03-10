{% set vars = pillar.zookeeper %}
{% from "kafka-cluster/connectivity.sls" import id with context %}
{% from "kafka-cluster/connectivity.sls" import members with context %}

{{ vars.datadir }}/myid:
  file.managed:
    - contents: {{ id }}
    - user: {{ vars.user }}
    - group: {{ vars.user }}

{{ vars.home }}/zookeeper-{{ vars.version }}/conf/zoo.cfg:
  file.managed:
    - mode: 644
    - template: jinja
    - source: salt://kafka-cluster/zookeeper/etc/zookeeper/zookeeper.properties
    - default:
      datadir: {{ vars.datadir }}
      logdir: {{ vars.logdir }}
      members: {{ members }}
    - require:
      - file: {{ vars.logdir }}
      - file: {{ vars.datadir }}
      - file: {{ vars.datadir }}/myid

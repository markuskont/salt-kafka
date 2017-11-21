{% set vars = pillar.kafka %}

kafka-cluster.kafka-user:
  group.present:
    - name: {{ vars.user }}
  user.present:
    - name: {{ vars.user }}
    - shell: /bin/false
    - home: {{vars.home}}
    - gid_from_name: True
    - require:
      - group: kafka-cluster.kafka-user

kafka-cluster.directories:
  file.directory:
    - user: {{ vars.user }}
    - group: {{ vars.user }}
    - mode: 755
    - makedirs: True
    - names:
      - {{ vars.home }}
      - {{ vars.logdir }}
      - {{ vars.confdir }}
    - require:
      - user: kafka
      - group: kafka

kafka-cluster.install-kafka-dist:
  file.managed:
    - name: {{vars.home}}/kafka-{{ vars.scala_version }}-{{ vars.version }}.tgz
    - source: http://www-us.apache.org/dist/kafka/{{ vars.version }}/kafka_{{ vars.scala_version }}-{{ vars.version }}.tgz
    - source_hash: {{ vars.hash_type }}={{ vars.source_hash }}
    - require:
      - file: {{ vars.home }}
  archive.extracted:
    - name: {{ vars.home }}
    - source: {{ vars.home }}/kafka-{{ vars.scala_version }}-{{ vars.version }}.tgz
    - user: {{ vars.user }}
    - group: {{ vars.user }}
    - require:
      - file: kafka-cluster.install-kafka-dist

{{ vars.home }}/kafka_{{ vars.scala_version }}-{{ vars.version }}/logs:
  file.directory:
    - user: {{ vars.user }}
    - group: {{ vars.user }}

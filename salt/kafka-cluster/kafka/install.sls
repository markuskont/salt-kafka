{% set vars = pillar.kafka %}

kafka-cluster.kafka-user:
  group.present:
    - name: kafka
  user.present:
    - name: kafka
    - shell: /bin/false
    - home: {{vars.home}}
    - gid_from_name: True
    - require:
      - group: kafka-cluster.kafka-user

kafka-cluster.directories:
  file.directory:
    - user: kafka
    - group: kafka
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
    - name: {{vars.home}}/kafka-{{ vars.scala_version }}-{{vars.version}}.tgz
    - source: http://www-us.apache.org/dist/kafka/{{vars.version}}/kafka_{{ vars.scala_version }}-{{ vars.version }}.tgz
    - source_hash: md5={{ vars.source_hash }}
    - require:
      - file: {{ vars.home }}

#set-kafka-package:
#  cmd.run:
#    - name: tar -xzf kafka-{{vars['version']}}.tgz -C {{vars['home']}}
#    - creates: {{vars['home']}}/kafka-2.11-{{vars['version']}}/bin/kafka-server-start.sh
#    - cwd: {{vars['home']}}
#    - require:
#      - cmd: get-kafka-pacakge

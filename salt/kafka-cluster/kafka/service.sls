{% set vars = pillar.kafka %}

# Zookeeper setup
{% if grains.init == 'upstart' %}
  {% set zookeeper_unit_file = '/etc/init/zookeeper.conf' %}

{{ zookeeper_unit_file }}:
  file.managed:
    - mode: 644
    - source: salt://kafka-cluster/kafka/etc/init/zookeeper.conf
    - template: jinja
    - defaults:
      home: {{ vars.home }}
      confdir: {{ vars.confdir }}
      user: {{ vars.user }}
      version: {{ vars.version }}
      scala: {{ vars.scala_version }}
    - require:
      - file: {{ vars.home }}
      - file: {{ vars.confdir }}
      - user: {{ vars.user }}

zookeeper_server_add_init:
  cmd.run:
    - name: initctl reload-configuration
    - unless: initctl list | grep zookeeper
    - require:
      - file: {{ zookeeper_unit_file }}

{% elif grains.init == 'systemd' %}
  {% set zookeeper_unit_file = '/etc/systemd/system/zookeeper.service' %}

{{ zookeeper_unit_file }}:
  file.managed:
    - source: salt://kafka-cluster/kafka/etc/systemd/system/zookeeper.service
    - mode: 644
    - template: jinja
    - defaults:
      home: {{ vars.home }}
      confdir: {{ vars.confdir }}
      user: {{ vars.user }}
      version: {{ vars.version }}
      scala: {{ vars.scala_version }}
    - require:
      - file: {{ vars.home }}
      - file: {{ vars.confdir }}
      - user: {{ vars.user }}
zookeeper_server_add_init:
  cmd.run:
    - name: systemctl daemon-reload
    - unless: systemctl list-units | grep zookeeper
    - require:
      - file: {{ zookeeper_unit_file }}

{% endif %}

# Kafka setup
{% if grains.init == 'upstart' %}
  {% set kafka_unit_file = '/etc/init/kafka.conf' %}

{{ kafka_unit_file }}:
  file.managed:
    - mode: 644
    - source: salt://kafka-cluster/kafka/etc/init/kafka.conf
    - template: jinja
    - defaults:
      home: {{ vars.home }}
      confdir: {{ vars.confdir }}
      user: {{ vars.user }}
      version: {{ vars.version }}
      scala: {{ vars.scala_version }}
    - require:
      - file: {{ vars.home }}
      - file: {{ vars.confdir }}
      - user: {{ vars.user }}

kafka_server_add_init:
  cmd.run:
    - name: initctl reload-configuration
    - unless: initctl list | grep kafka
    - require:
      - file: {{ kafka_unit_file }}

{% elif grains.init == 'systemd' %}
  {% set kafka_unit_file = '/etc/systemd/system/kafka.service' %}

{{ kafka_unit_file }}:
  file.managed:
    - source: salt://kafka-cluster/kafka/etc/systemd/system/kafka.service
    - mode: 644
    - template: jinja
    - defaults:
      home: {{ vars.home }}
      confdir: {{ vars.confdir }}
      user: {{ vars.user }}
      version: {{ vars.version }}
      scala: {{ vars.scala_version }}
    - require:
      - file: {{ vars.home }}
      - file: {{ vars.confdir }}
      - user: {{ vars.user }}
kafka_server_add_init:
  cmd.run:
    - name: systemctl daemon-reload
    - unless: systemctl list-units | grep kafka
    - require:
      - file: {{ kafka_unit_file }}

{% endif %}

zookeeper-service:
  service.running:
    - name: zookeeper
    - enable: True
    - watch:
      - file: {{ vars.home }}/kafka_{{ vars.scala_version }}-{{ vars.version }}/logs
      - file: {{ zookeeper_unit_file }}
      - file: {{ vars.confdir }}/zookeeper.conf

#kafka-service:
#  service.running:
#    - name: kafka
#    - enable: True
#    - watch:
#      - file: {{ kafka_unit_file }}
#      - file: {{ vars.confdir }}/kafka.conf
#    - require:
#      - service: zookeeper-service

{% set vars = pillar.kafka %}

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
      logdir: {{ vars.logdir }}
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
      logdir: {{ vars.logdir }}
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

kafka-service:
  service.running:
    - name: kafka
    - enable: True
    - watch:
      - file: {{ kafka_unit_file }}
      - file: {{ vars.confdir }}/kafka.conf
    - require:
      - file: {{ kafka_unit_file }}

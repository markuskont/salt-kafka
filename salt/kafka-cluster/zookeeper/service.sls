{% set vars = pillar.zookeeper %}

# Zookeeper setup
{% if grains.init == 'upstart' %}
  {% set zookeeper_unit_file = '/etc/init/zookeeper.conf' %}

{{ zookeeper_unit_file }}:
  file.managed:
    - mode: 644
    - source: salt://kafka-cluster/zookeeper/etc/init/zookeeper.conf
    - template: jinja
    - defaults:
      home: {{ vars.home }}
      user: {{ vars.user }}
      version: {{ vars.version }}
      logdir: {{ vars.logdir }}
    - require:
      - file: {{ vars.home }}
      - user: {{ vars.user }}

zookeeper_server_add_init:
  cmd.run:
    - name: initctl reload-configuration
    - onchanges:
      - file: {{ zookeeper_unit_file }}
    - require:
      - file: {{ zookeeper_unit_file }}

{% elif grains.init == 'systemd' %}
  {% set zookeeper_unit_file = '/etc/systemd/system/zookeeper.service' %}

{{ zookeeper_unit_file }}:
  file.managed:
    - source: salt://kafka-cluster/zookeeper/etc/systemd/system/zookeeper.service
    - mode: 644
    - template: jinja
    - defaults:
      home: {{ vars.home }}
      user: {{ vars.user }}
      version: {{ vars.version }}
      logdir: {{ vars.logdir }}
    - require:
      - file: {{ vars.home }}
      - user: {{ vars.user }}
zookeeper_server_add_init:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: {{ zookeeper_unit_file }}
    - require:
      - file: {{ zookeeper_unit_file }}

{% endif %}

zookeeper-service:
  service.running:
    - name: zookeeper
    - enable: True
    - watch:
      - file: {{ zookeeper_unit_file }}
      - file: {{ vars.home }}/zookeeper-{{ vars.version }}/conf/zoo.cfg

{% set vars = pillar['kafka'] %}

/etc/init/kafka.conf:
  file.managed:
    - mode: 644
    - source: salt://kafka/etc/init/kafka.conf
    - template: jinja
    - defaults:
      home: {{vars['home']}}
      confdir: {{vars['confdir']}}
      user: {{vars['user']}}
      version: {{vars['version']}}
    - require:
      - {{vars['home']}}
      - {{vars['confdir']}}
      - user: {{vars['user']}}
      - cmd: set-kafka-package

{% if grains['init'] == 'upstart' %}
kafka_add_init:
  cmd.run:
    - name: initctl reload-configuration
    - unless: initctl list | grep kafka
    - require:
      - /etc/init/kafka.conf
{% endif %}

kafka-service:
  service.running:
    - name: kafka
    - enable: True
    - watch:
      - /etc/init/kafka.conf
      - {{vars['confdir']}}/config.properties

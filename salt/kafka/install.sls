{% set vars = pillar['kafka'] %}

{{vars['user']}}:
  group.present:
    - name: {{vars['user']}}
  user.present:
    - gid_from_name: True
    - home: {{vars['home']}}
    - shell: '/bin/false'
    - createhome: True
    - groups:
      - {{vars['user']}}

{{vars['home']}}:
  file.directory:
    - user: {{vars['user']}}
    - group: {{vars['user']}}
    - mode: 755
    - require:
      - user: {{vars['user']}}
      - group: {{vars['user']}}
{{vars['logdir']}}:
  file.directory:
    - user: {{vars['user']}}
    - group: {{vars['user']}}
    - mode: 750
    - require:
      - user: {{vars['user']}}
      - group: {{vars['user']}}

zookeeperd:
  pkg.installed

get-kafka-pacakge:
  cmd.run:
    - name: wget -O kafka-{{vars['version']}}.tgz http://www-us.apache.org/dist/kafka/{{vars['version']}}/kafka_2.11-{{vars['version']}}.tgz
    - creates: {{vars['home']}}/kafka-{{vars['version']}}.tgz
    - cwd: {{vars['home']}}
    - require:
      - {{vars['home']}}

set-kafka-package:
  cmd.run:
    - name: tar -xzf kafka-{{vars['version']}}.tgz -C {{vars['home']}}
    - creates: {{vars['home']}}/kafka-2.11-{{vars['version']}}/bin/kafka-server-start.sh
    - cwd: {{vars['home']}}
    - require:
      - cmd: get-kafka-pacakge

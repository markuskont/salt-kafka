{% set vars = pillar.zookeeper %}

kafka-cluster.zk-user:
  group.present:
    - name: {{ vars.user }}
  user.present:
    - name: {{ vars.user }}
    - shell: /bin/false
    - home: {{vars.home}}
    - gid_from_name: True
    - require:
      - group: kafka-cluster.zk-user

kafka-cluster.zk-directories:
  file.directory:
    - user: {{ vars.user }}
    - group: {{ vars.user }}
    - mode: 755
    - makedirs: True
    - names:
      - {{ vars.home }}
      - {{ vars.logdir }}
      - {{ vars.datadir }}
    - require:
      - user: {{ vars.user }}
      - group: {{ vars.user }}

kafka-cluster.install-zk-dist:
  file.managed:
    - name: {{ vars.home }}/zk-{{ vars.version }}.tgz
    - source: http://www-eu.apache.org/dist/zookeeper/zookeeper-{{ vars.version }}/zookeeper-{{ vars.version }}.tar.gz
    - source_hash: {{ vars.hash_type }}={{ vars.source_hash }}
    - require:
      - file: {{ vars.home }}
  archive.extracted:
    - name: {{ vars.home }}
    - source: {{ vars.home }}/zk-{{ vars.version }}.tgz
    - user: {{ vars.user }}
    - group: {{ vars.user }}
    - require:
      - file: {{ vars.home }}/zk-{{ vars.version }}.tgz

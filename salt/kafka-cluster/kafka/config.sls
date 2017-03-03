{% set vars = pillar.kafka %}

{% set members = [] %}
{% set hostnames = [] %}

{% for master, ips in salt['mine.get'](
  'G@roles:kafka',
  fun='kafka_cluster_ip_addr',
  expr_form='compound').items() %}
    {% do members.append(ips[0]) %}
    {% do hostnames.append(master) %}
{% endfor %}

{% set zk = [] %}

{% for member in members %}
  {% do zk.append(member + ':2181') %}
{{ hostnames[loop.index0] }}:
  host.present:
    - ip: {{ member }}
{% endfor %}

{% set id = salt['mine.get'](grains.fqdn, 'kafka_cluster_ip_addr', expr_form='glob')[grains.fqdn][0].split('.')[3] %}

{{ vars.zookeeper.data }}/myid:
  file.managed:
    - contents: {{ id }}
    - user: {{ vars.user }}
    - group: {{ vars.user }}

{{ vars.confdir }}/zookeeper.conf:
  file.managed:
    - mode: 644
    - template: jinja
    - source: salt://kafka-cluster/kafka/etc/kafka/zookeeper.properties
    - default:
      datadir: {{ vars.zookeeper.data }}
      logdir: {{ vars.zookeeper.log }}
      members: {{ members }}
    - require:
      - file: {{ vars.zookeeper.log }}
      - file: {{ vars.zookeeper.data }}
      - file: {{ vars.zookeeper.data }}/myid

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

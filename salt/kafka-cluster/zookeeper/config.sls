{% set vars = pillar.zookeeper %}

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

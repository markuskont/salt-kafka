{% set vars = pillar.kafka %}

{% set members = [] %}
{% set hostnames = [] %}

{% for master, ips in salt['mine.get'](
  'G@roles:zookeeper',
  fun='kafka_cluster_ip_addr',
  expr_form='compound').items() %}
    {% do members.append(ips[0]) %}
    {% do hostnames.append(master) %}
{% endfor %}

{% set id = salt['mine.get'](
  grains.fqdn,
  'kafka_cluster_ip_addr',
  expr_form='glob')[grains.fqdn][0].split('.')[3] %}

{% set zk = [] %}

{% for member in members %}
  {% do zk.append(member + ':2181') %}
{{ hostnames[loop.index0] }}:
  host.present:
    - ip: {{ member }}
{% endfor %}

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

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

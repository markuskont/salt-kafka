{% set os = grains.get('os')|lower %}
{% if os == 'ubuntu' %}
  {% set codename = grains.get('oscodename') %}
{% elif os == 'debian' %}
  {% set os = 'ubuntu' %}
  {% if grains['oscodename'] == 'jessie' %}
    {% set codename = 'xenial' %}
  {% elif grains['oscodename'] == 'wheezy' %}
    {% set codename = 'trusty' %}
  {% endif%}
{% endif %}

kafka-cluster.webupd8-repo:
  pkgrepo.managed:
    - humanname: WebUpd8 Oracle Java PPA repository
    - name: deb http://ppa.launchpad.net/webupd8team/java/{{os}} {{codename}} main
    - keyserver: keyserver.ubuntu.com
    - keyid: EEA14886
    - file: /etc/apt/sources.list.d/WebUpd8.list
    - clean_file: True

kafka-cluster.oracle-license-select:
  cmd.run:
    - unless: which java
    - name: '/bin/echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections'
    - require_in:
      - pkg: kafka-cluster.oracle-java8-installer
      - cmd: kafka-cluster.oracle-license-seen-lie

kafka-cluster.oracle-license-seen-lie:
  cmd.run:
    - name: '/bin/echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 seen true  | /usr/bin/debconf-set-selections'
    - require_in:
      - pkg: kafka-cluster.oracle-java8-installer

kafka-cluster.oracle-java8-installer:
  pkg.installed:
    - name: oracle-java8-installer
    - require:
      - pkgrepo: kafka-cluster.webupd8-repo

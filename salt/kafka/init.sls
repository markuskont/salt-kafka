{% if pillar['kafka']['manage'] == true %}
include:
  - java
  - sysctl
  - kafka.install
  - kafka.config
  - kafka.service
{% endif %}

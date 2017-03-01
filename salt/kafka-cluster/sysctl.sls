kafka-cluster.fs.file-max:
  sysctl.present:
    - name: fs.file-max
    - value: 256000
    - config: '/etc/sysctl.conf'

Installeren van syslog-ng core:
  pkg.installed:
    - pkgs:
      - syslog-ng

Oude config file syslog-ng opslaan als back-up:
  file.rename:
    - name: /etc/syslog-ng/syslog-ng.conf.BAK
    - source: /etc/syslog-ng/syslog-ng.conf

Configuratie syslog-ng core:
  file.append:
    - name: /etc/syslog-ng/syslog-ng.conf
    - text: |
        @version: 3.5
        @include "scl.conf"
        @include "`scl-root`/system/tty10.conf"
            options {
                time-reap(30);
                mark-freq(10);
                keep-hostname(yes);
                };
        source s_local { system(); internal(); };
        source s_network {
            syslog(transport(tcp) port(514));
            };
        destination d_local {
        file("/var/log/syslog-ng/messages_${HOST}"); };
        destination d_logs {
            file(
                "/var/log/syslog-ng/logs.txt"
                owner("root")
                group("root")
                perm(0777)
                ); };
        log { source(s_local); source(s_network); destination(d_logs); };

Aanmaken van Directory log:
  file.directory:
    - name: /var/log/syslog-ng
    - user: jurian
    - group: jurian
    - mode: 755
    - makedirs: True

Aanmaken van File log:
  file.managed:
    - name: /var/log/syslog-ng/logs.text
    - user: jurian
    - group: jurian
    - mode: 755
    - replace: False

syslog-ng:
  service.running:
    - enable: True
    - reload: True
Oude config file syslog-ng opslaan als back-up:
  file.rename:
    - name: /etc/syslog-ng/syslog-ng.conf.BAK
    - source: /etc/syslog-ng/syslog-ng.conf

syslog-ng configuratie:
  file.append:
    - name: /etc/syslog-ng/syslog-ng.conf
    - text: |
        @version: 3.5
        @include "scl.conf"
        @include "`scl-root`/system/tty10.conf"
        source s_local { 
             system(); internal(); 
        };
        destination loghost { tcp("10.0.7.86" port(514)); };
        log { source(s_local); destination(loghost); };

syslog-ng:
  service.running:
    - enable: True
    - reload: True

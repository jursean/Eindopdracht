Oude config file syslog-ng opslaan als back-up
  file.rename:
    - name: /etc/syslog-ng/syslog-ng.conf
    - source: /etc/syslog-ng/syslog-ng.conf.BAK
	
syslog-ng configuratie
  file.append:
    - name: /etc/syslog-ng/syslog-ng.conf
	- text:
	  - @version: 3.5
	  - @include "scl.conf"
	  - @include "`scl-root`/system/tty10.conf"
	  - source s_local { 
	  -	     system(); internal(); 
	  - };
	  - source s_apache2 {
      -      file("/var/log/apache2/access_log");
      -      file("/var/log/apache2/error_log");
      - };
	  - source s_mysql {
      -      file("/var/log/mysql/error_log");
      - };
      - destination loghost { tcp("10.0.7.86" port(514)); };
      - log { source(s_local); destination(loghost); };
      - log { source(s_apache2); destination(loghost); };
      - log { source(s_mysql); destination(loghost); };

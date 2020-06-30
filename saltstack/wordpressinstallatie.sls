Installeren van Lamp en wordpress:
  pkg.installed:
    - pkgs:
      - wordpress
      - php
      - libapache2-mod-php
      - mysql-server
      - php-mysql

Aanmaken wordpress.conf:
  file.managed:
    - name: /etc/apache2/sites-available/wordpress.conf
    - user: jurian
    - group: jurian
    - mode: 755

Wordpress.conf File bijwerken:
  file.append:
    - name: /etc/syslog-ng/syslog-ng.conf
    - text: |
        Alias /blog /usr/share/wordpress
        <Directory /usr/share/wordpress>
            Options FollowSymLinks
            AllowOverride Limit Options FileInfo
            DirectoryIndex index.php
            Order allow,deny
            Allow from all
        </Directory>
        <Directory /usr/share/wordpress/wp-content>
            Options FollowSymLinks
            Order allow,deny
            Allow from all
        </Directory> 

Wordpress enablen:
  apache.a2enmod:
    - name: wordpress

Wordpress rewrite:
  apache.a2enmod:
    - name: rewrite

apache2:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - apache2

Maken van database wordpress:
  mysql.db_create:
    - name: wordpress

Database Grand:
  mysql.grant_add:
    - name: 'GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER' 'database.*' 'wordpress@localhost',
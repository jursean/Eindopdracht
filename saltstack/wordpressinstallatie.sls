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
  apache_module.enable:
    - name: wordpress

Wordpress rewrite:
  apache_module.enable:
    - name: rewrite

apache2:
  service.running:
    - enable: True
    - reload: True

Maken User SQL:
  mysql.user.present:
    - name: wordpress
    - host: localhost
    - password: Welkom123

Maken van database wordpress:
  mysql.db_create:
    - name: wordpress

Grant:
  mysql_grants.present:
    - grant: select,insert,update,delete,create,drop,alter
    - database: wordpress.*
    - user: wordpress
    - host: localhost

Wordpress config&database:
  file.append:
    - name: /etc/wordpress/config-localhost.php
    - text: |
        <?php
        define('DB_NAME', 'wordpress');
        define('DB_USER', 'wordpress');
        define('DB_PASSWORD', '<your-password>');
        define('DB_HOST', 'localhost');
        define('DB_COLLATE', 'utf8_general_ci');
        define('WP_CONTENT_DIR', '/usr/share/wordpress/wp-content');
        ?>

Starten MYSQL:
  service.start:
    - name: mysql


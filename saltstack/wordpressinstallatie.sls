Installeren van Lamp en wordpress:
  pkg.installed:
    - pkgs:
      - wordpress
      - php
      - libapache2-mod-php
      - mysql-server
      - python-dev

Aanmaken wordpress.conf:
  file.managed:
    - name: /etc/apache2/sites-available/wordpress.conf
    - user: jurian
    - group: jurian
    - mode: 755
    - replace: False

Wordpress.conf File bijwerken:
  file.append:
    - name: /etc/apache2/sites-available/wordpress.conf
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

sudo a2enmod rewrite:
  cmd.run:
    - unless: test -f /etc/apache2/mods-enabled/rewrite.load

apache2:
  service.running:
    - name: apache2
    - watch:
      - cmd: sudo a2enmod rewrite

Config minion aanpassen voor mySQL:
  file.append:
    - name: /etc/salt/minion
    - text: |
        mysql.host: 'localhost'
        mysql.port: 3306
        mysql.user: 'root'
        mysql.pass: ''
        mysql.db: 'mysql'
        mysql.unix_socket: '/tmp/mysql.sock'
        mysql.charset: 'utf8'

Maken User SQL:
  mysql_user.present:
    - name: wordpress
    - password: Welkom123
    - host: localhost

Maken van database wordpress:
  mysql_database.present:
    - name: wordpress
    - connection_host: localhost
    - connection_user: root
    - connection_pass:

Maken database:
  mysql.db_create:
    - name: wordpress

wordpress:
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
        define('DB_PASSWORD', 'Welkom123');
        define('DB_HOST', 'localhost');
        define('DB_COLLATE', 'utf8_general_ci');
        define('WP_CONTENT_DIR', '/usr/share/wordpress/wp-content');
        ?>
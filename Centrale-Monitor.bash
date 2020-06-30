#!/bin/bash


for a in $(sudo salt-key | sed -n -e '/Accepted Keys:/,/Denied Keys:/ p' | sed -e '1d;$d')
do
	list_output=($(sudo salt-run manage.alived |sed 's/^-\(.*\)/\1/' | sed 's/^ *//g'))
	for i in "${list_output[@]}"
	do
		if [ "$i" == "${a}" ]
		then
			minion_h=$(sudo salt ${a} network.get_hostname | sed -n '2p' | sed 's/^ *//g')
			minion_ip=$(sudo salt ${a} network.ip_addrs | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
		fi
	done

	if [ ! -d "/usr/local/nagios/etc/servers/${minion_h}.cfg" ]
	then

	sudo touch /usr/local/nagios/etc/servers/${minion_h}.cfg
	sudo chmod 777 /usr/local/nagios/etc/servers/${minion_h}.cfg
sudo printf "
#Ubuntu host Configuration file1
define host {
	use							linux-server
	host_name					$minion_h
	alias						Ubuntu Host
	address						$minion_ip
	register					1
}

define service {
	host_name					$minion_h
	service_description			PING
	check_command				check_nrpe!check_ping
	max_check_attempts			2
	check_interval				2
	retry_interval				2
	check_period				24x7
	check_freshness				1
	contact_groups				admins
	notification_interval		2
	notification_period			24x7
	notifications_enabled		1
	register					1
}

define service {
	host_name					$minion_h
	service_description			Check Users
	check_command				check_nrpe!check_users
	max_check_attempts			2
	check_interval				2
	retry_interval				2
	check_period				24x7
	check_freshness				1
	contact_groups				admins
	notification_interval		2
	notification_period			24x7
	notifications_enabled		1
	register					1
}

define service {
	host_name					$minion_h
	service_description			Check SSH
	check_command				check_nrpe!check_ssh
	max_check_attempts			2
	check_interval				2
	retry_interval				2
	check_period				24x7
	check_freshness				1
	contact_groups				admins
	notification_interval		2
	notification_period			24x7
	notifications_enabled		1
	register					1
}

define service {
	host_name					$minion_h
	service_description			Check Root / Disk
	check_command				check_nrpe!check_root
	max_check_attempts			2
	check_interval				2
	retry_interval				2
	check_period				24x7
	check_freshness				1
	contact_groups				admins
	notification_interval		2
	notification_period			24x7
	notifications_enabled		1
	register					1
}

define service {
	host_name					$minion_h
	service_description			Check APT Update
	check_command				check_nrpe!check_apt
	max_check_attempts			2
	check_interval				2
	retry_interval				2
	check_period				24x7
	check_freshness				1
	contact_groups				admins
	notification_interval		2
	notification_period			24x7
	notifications_enabled		1
	register					1
}

define service {
	host_name					$minion_h
	service_description			Check HTTP
	check_command				check_nrpe!check_http
	max_check_attempts			2
	check_interval				2
	retry_interval				2
	check_period				24x7
	check_freshness				1
	contact_groups				admins
	notification_interval		2
	notification_period			24x7
	notifications_enabled		1
	register					1
}" > /usr/local/nagios/etc/servers/${minion_h}.cfg
	fi
done
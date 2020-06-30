installeren van nagios:
  pkg.installed:
    - pkgs:
      - nagios-nrpe-server
      - nagios-plugins
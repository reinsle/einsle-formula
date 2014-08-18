include:
  - debian.tools

# installs einsle.list debian repository
/etc/apt/sources.list.d/einsle.list:
  file.managed:
    - source: salt://einsle/files/einsle.list.{{ grains['os']|lower }}.{{ grains['lsb_distrib_codename']|lower}}
    - user: root
    - group: root
    - mode: 0644
    - require_in:
      - cmd: apt-get_update
    - watch_in:
      - cmd: apt-get_update

# installs einsle apt-key
wget -q -O- "http://debian.einsle.de/robert_einsle_signing.asc" | apt-key add -:
  cmd.run:
    - unless: apt-key  list | grep "Robert Einsle (Signing key) <robert@einsle.de>"
    - require:
      - file: /etc/apt/sources.list.d/einsle.list
    - require_in:
      - cmd: apt-get_update
    - watch_in:
      - cmd: apt-get_update

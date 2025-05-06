#cloud-config
autoinstall:
  version: 1
  locale: en_US
  keyboard:
    layout: us
  ssh:
    install-server: true
    allow-pw: true
    authorized-keys: 
      - "${ssh_public_key}"
    allow_public_ssh_keys: true
  packages:
    - qemu-guest-agent
    - sudo
  storage:
    layout:
      name: direct
    swap:
      size: 0
  network:
    version: 2
    ethernets:
      all-en:
        dhcp4: true
        match: 
          name: en*
      all-eth:
        dhcp4: true
        match: 
          name: eth*
  user-data:
    package_upgrade: yes
    timezone: ${timezone}
    disable_root: false
    ssh_pwauth: true
    chpasswd:
      expire: false
      users:
      - {name: ubuntu, password: ${root_password}, type: text}
users:
- name: ubuntu
  groups: users
  sudo: ALL=(ALL) NOPASSWD:ALL
  ssh_authorized_keys: "${ssh_public_key}"
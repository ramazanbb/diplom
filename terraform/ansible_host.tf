#----------------- inventory.ini -----------------
resource "local_file" "ansible-inventory" {
  content  = <<-EOT
    [bastion]
    ${yandex_compute_instance.bastion-vm.network_interface.0.ip_address} public_ip=${yandex_compute_instance.bastion-vm.network_interface.0.nat_ip_address} 

    [web]
    ${yandex_compute_instance.web-vm-1.network_interface.0.ip_address}
    ${yandex_compute_instance.web-vm-2.network_interface.0.ip_address}

    [zabbix]
    ${yandex_compute_instance.zabbix-vm.network_interface.0.nat_ip_address}

    [kibana]
    ${yandex_compute_instance.kibana-vm.network_interface.0.ip_address} public_ip=${yandex_compute_instance.kibana-vm.network_interface.0.nat_ip_address} 

    [elastic]
    ${yandex_compute_instance.elasticsearch-vm.network_interface.0.ip_address}

    [web:vars]
    domain="myproject"
    
    [all:vars]
    ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand="ssh -p 22 -W %h:%p -q ubuntu@${yandex_compute_instance.bastion-vm.network_interface.0.nat_ip_address}"'
    EOT
  filename = "./inventory.ini"
}

output "k8s_workers_addresses" {
  value = {
    for name, instance in yandex_compute_instance.workers :
    name => {
      public_ip  = instance.network_interface.0.nat_ip_address
      private_ip = instance.network_interface.0.ip_address
    }
  }
  description = "Public and private IP addresses of K8s workers"
}

output "k8s_masters_addresses" {
  value = {
    for name, instance in yandex_compute_instance.masters :
    name => {
      public_ip  = instance.network_interface.0.nat_ip_address
      private_ip = instance.network_interface.0.ip_address
    }
  }
  description = "Public and private IP addresses of K8s masters"
}


#output "all_vm" {
#  value = flatten([
#    [for i in yandex_compute_instance.control-plane : {
#      name        = i.name
#      ip_external = i.network_interface[0].nat_ip_address
#      ip_internal = i.network_interface[0].ip_address
#    }],
#    [for i in yandex_compute_instance.data-plane : {
#      name        = i.name
#      ip_external = i.network_interface[0].nat_ip_address
#      ip_internal = i.network_interface[0].ip_address
#    }]
#  ])
#}
#
#output "api_endpoint" {
#  value = yandex_compute_instance.control-plane[0].network_interface[0].nat_ip_address
#}
#
#output "worker_ip" {
#  value = [
#    yandex_compute_instance.data-plane[0].network_interface[0].ip_address,
#    yandex_compute_instance.data-plane[1].network_interface[0].ip_address
#  ]
#}
#
#output "Ingress_Load_Balancer_Address" {
#  value = [
#    yandex_lb_network_load_balancer.nlb-grafana.listener.*.external_address_spec[0].*.address,
#    yandex_lb_network_load_balancer.nlb-web-app.listener.*.external_address_spec[0].*.address
#  ]
#  description = "Адрес сетевого балансировщика"
#
#}
#
#
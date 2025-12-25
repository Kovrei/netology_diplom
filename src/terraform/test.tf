output "all_vm" {
  value = flatten([
    [for i in yandex_compute_instance.masters : {
      name        = i.name
      ip_external = i.network_interface[0].nat_ip_address
      ip_internal = i.network_interface[0].ip_address
    }],
    [for i in yandex_compute_instance.workers : {
      name        = i.name
      ip_external = i.network_interface[0].nat_ip_address
      ip_internal = i.network_interface[0].ip_address
    }]
  ])
}

output "api_endpoint" {
  value = yandex_compute_instance.masters[0].network_interface[0].nat_ip_address
}


resource "yandex_compute_instance" "masters" {
  for_each = {
    for idx, vm in var.k8s_vm_master : idx => vm
  }

  name        = "${each.value.name}-${each.key + 1}"
  hostname    = "${each.value.name}-${each.key + 1}"
  platform_id = each.value.platform_id
  zone        = each.value.zone

  resources {
    cores         = each.value.cores
    memory        = each.value.memory
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = each.value.hdd_size
      type     = each.value.hdd_type
    }
  }

  scheduling_policy {
    preemptible = false
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.k8s_subnets[each.key].id
    nat       = each.value.nat_ip
  }

  metadata = local.metadata
}


resource "yandex_compute_instance" "workers" {
  for_each = {
    for idx, vm in var.k8s_vm_worker : idx => vm
  }

  name        = "${each.value.name}-${each.key + 1}"
  hostname    = "${each.value.name}-${each.key + 1}"
  platform_id = each.value.platform_id
  zone        = each.value.zone

  resources {
    cores         = each.value.cores
    memory        = each.value.memory
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = each.value.hdd_size
      type     = each.value.hdd_type
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.k8s_subnets[each.key].id
    nat       = each.value.nat_ip
  }

  metadata = local.metadata
}



#resource "yandex_compute_instance" "control-plane" {
#  count = 1
#  name  = "master-${count.index}"
#  zone  = var.subnet-zones[count.index]
#
#  resources {
#    cores  = 2
#    memory = 4
#    core_fraction = 20
#  }
#  scheduling_policy {
#    preemptible = true
#  }
#  network_interface {
#    subnet_id = yandex_vpc_subnet.subnet-zones[count.index].id
#    nat       = true
#  }
#  boot_disk {
#    initialize_params {
#      image_id = "fd8l04iucc4vsh00rkb1"
#      type     = "network-hdd"
#      size     = "50"
#    }
#  }
#  metadata = local.metadata
#}


#resource "yandex_compute_instance" "data-plane" {
#  count = 2
#  name  = "worker-${count.index}"
#  zone  = var.subnet-zones[count.index]
#  scheduling_policy {
#    preemptible = true
#  }
#  labels = {
#    index = count.index
#  }
#  resources {
#    cores  = 2
#    memory = 4
#    core_fraction = 20
#  }
#  network_interface {
#    subnet_id = yandex_vpc_subnet.subnet-zones[count.index].id
#    nat       = true
#  }
#
#
#  boot_disk {
#    initialize_params {
#      image_id = "fd8l04iucc4vsh00rkb1"
#      type     = "network-hdd"
#      size     = "50"
#    }
#  }
#  metadata = local.metadata
#}
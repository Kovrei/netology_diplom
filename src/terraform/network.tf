resource "yandex_vpc_network" "vpc_k8s" {
  name        = local.network_name
  description = "Network for my diplom"
}

resource "yandex_vpc_subnet" "k8s_subnets" {
  for_each = {
    for idx, vm in var.k8s_vm_worker : idx => vm
  }

  name           = "subnet-${each.value.zone}"
  zone           = each.value.zone
  network_id     = yandex_vpc_network.vpc_k8s.id
  v4_cidr_blocks = ["192.168.${10 + (each.key * 10)}.0/24"]
}


#resource "yandex_vpc_subnet" "subnet-zones" {
#  count          = 3
#  name           = "subnet-${var.subnet-zones[count.index]}"
#  zone           = var.subnet-zones[count.index]
#  network_id     = yandex_vpc_network.subnet-zones.id
#  v4_cidr_blocks = [var.cidr.stage[count.index]]
#}

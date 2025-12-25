resource "local_file" "hosts_cfg" {
  content = templatefile("../templates/inventory.tftpl",
    {
      master  = yandex_compute_instance.masters
      workers = yandex_compute_instance.workers
  })

  filename = "./hosts.yaml"
}


resource "null_resource" "inventory-render" {
  provisioner "local-exec" {
    command = "cp hosts.yaml ../kubespray/inventory/mycluster/hosts.yaml"
  }
  depends_on = [local_file.hosts_cfg]
}
locals {

  #metadata = {
  #  "serial-port-enable" = "1"
  #  "ssh-keys"           = "ubuntu:${file("~/.ssh/vm1.pub")}"
  #}
  #ssh-keys     = "ubuntu:${file("~/.ssh/vm1.pub")}"
  network_name = "vpc-k8s"
  subnet_name1 = "public-subnet"
  storage_name = "sa-storage"
  sg_nat_name  = "sg"
  lg_tg_name   = "lg-tg"
}


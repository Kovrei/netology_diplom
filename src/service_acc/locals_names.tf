locals {

  project_name = substr(lower(replace(coalesce(var.project_name, basename(abspath(path.root))), "/[^a-zA-Z0-9-]|-+$/", "-")), 0, 63)

  metadata = {
    "serial-port-enable" = "1"
    "ssh-keys"           = "ubuntu:${file("~/.ssh/vm1.pub")}"
  }
  ssh-keys     = "ubuntu:${file("~/.ssh/vm1.pub")}"
  network_name = "vpc-k8s"
  group_name1  = "lamp-vm"
  subnet_name1 = "public-subnet"
  ig_name      = "sa-ig"
  storage_name = "sa-storage"
  backet_name  = "${local.project_name}-backend"
  sg_nat_name  = "sg"
  lg_tg_name   = "lg-tg"
  lb_name      = "lb-1"
  smk_name     = "smk"
}

variable "project_name" {
  type        = string
  description = "Optional custom name for the project. If left blank, the project directory name will be used."
  default     = "osipenkovau"
}

###################
### common vars ###
###################


variable "token" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
  sensitive   = true
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
  sensitive   = true
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
  sensitive   = true
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "vm_web_family" {
  type    = string
  default = "ubuntu-2204-lts-oslogin"
}


#variable "subnet-zones" {
#  type    = list(string)
#  default = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
#}
#
#variable "cidr" {
#  type = map(list(string))
#  default = {
#    stage = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
#  }
#}


variable "k8s_vm_master" {
  type = list(object({
    name          = string
    platform_id   = string
    zone          = string
    nat_ip        = bool
    cores         = number
    memory        = number
    core_fraction = number
    hdd_size      = number
    name_disk     = string
    hdd_type      = string
  }))
  default = [
    {
      name          = "master"
      platform_id   = "standard-v3"
      zone          = "ru-central1-a"
      nat_ip        = true
      cores         = 2
      memory        = 4
      core_fraction = 50
      hdd_size      = 15
      name_disk     = "SSD"
      hdd_type      = "network-ssd"
    }
  ]
}

variable "k8s_vm_worker" {
  type = list(object({
    name          = string
    platform_id   = string
    zone          = string
    nat_ip        = bool
    cores         = number
    memory        = number
    core_fraction = number
    hdd_size      = number
    name_disk     = string
    hdd_type      = string
  }))
  default = [
    {
      name          = "worker"
      platform_id   = "standard-v3"
      zone          = "ru-central1-a"
      nat_ip        = true
      cores         = 2
      memory        = 4
      core_fraction = 50
      hdd_size      = 15
      name_disk     = "HDD"
      hdd_type      = "network-hdd"
    },
    {
      name          = "worker"
      platform_id   = "standard-v3"
      zone          = "ru-central1-b"
      nat_ip        = true
      cores         = 2
      memory        = 4
      core_fraction = 50
      hdd_size      = 15
      name_disk     = "SSD"
      hdd_type      = "network-hdd"
    },
    {
      name          = "worker"
      platform_id   = "standard-v3"
      zone          = "ru-central1-d"
      nat_ip        = true
      cores         = 2
      memory        = 4
      core_fraction = 50
      hdd_size      = 15
      name_disk     = "SSD"
      hdd_type      = "network-hdd"
    }
  ]
}
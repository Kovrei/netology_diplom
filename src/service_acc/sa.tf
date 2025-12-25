# Сервисный аккаунт для управления группой ВМ
resource "yandex_iam_service_account" "ig-sa" {
  name        = local.ig_name
  description = "Сервисный аккаунт для управления группой ВМ."
}

resource "yandex_resourcemanager_folder_iam_member" "compute_admin" {
  folder_id = var.folder_id
  role      = var.role_ig
  member    = "serviceAccount:${yandex_iam_service_account.ig-sa.id}"
  depends_on = [
    yandex_iam_service_account.ig-sa,
  ]
}
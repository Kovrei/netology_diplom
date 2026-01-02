output "service_account_name" {
  value = yandex_iam_service_account.sa.name
}

output "bucket_name" {
  description = "Имя созданного S3-бакета в Yandex Cloud"
  value       = yandex_storage_bucket.tfstate.bucket
}

output "access_key" {
  description = "key"
  value       = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  sensitive = true
}

output "secret_key" {
  description = "key"
  value       = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  sensitive = true
}
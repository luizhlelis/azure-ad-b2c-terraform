output "app_registration_client_secret_key_id" {
  description = "App Registration Client Secret Key Id"
  value       = azuread_application_password.django_azure_b2c_auth.key_id
  sensitive   = true
}

output "app_registration_client_secret_value" {
  description = "App Registration Client Secret Value"
  value       = azuread_application_password.django_azure_b2c_auth.value
  sensitive   = true
}
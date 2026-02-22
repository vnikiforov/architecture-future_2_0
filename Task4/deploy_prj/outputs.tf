# outputs.tf

output "mock_mode" {
  description = "Режим работы: true = mock, false = Azure"
  value       = !var.use_azure_provider
}

output "key_vault_uri" {
  description = "URI Key Vault"
  value       = var.use_azure_provider ? null : "https://kv-${var.environment}-${var.location_short}-001.vault.azure.net/"
}

output "clinics_aks_cluster_name" {
  description = "Имя AKS кластера для домена Клиники"
  value       = var.use_azure_provider ? null : "aks-${var.environment}-clinics-${var.location_short}"
}

output "clinics_sql_fqdn" {
  description = "FQDN SQL Managed Instance"
  value       = var.use_azure_provider ? null : "sqlmi-${var.environment}-clinics-${var.location_short}.database.windows.net"
}

output "ai_postgres_fqdn" {
  description = "FQDN PostgreSQL сервера"
  value       = var.use_azure_provider ? null : "psql-${var.environment}-ai-${var.location_short}.postgres.database.azure.com"
}

output "resource_groups" {
  description = "Список Resource Groups"
  value = {
    clinics     = "rg-${var.environment}-clinics-${var.location_short}"
    fintech     = "rg-${var.environment}-fintech-${var.location_short}"
    ai          = "rg-${var.environment}-ai-${var.location_short}"
    pharma      = "rg-${var.environment}-pharma-${var.location_short}"
    electronics = "rg-${var.environment}-electronics-${var.location_short}"
  }
}
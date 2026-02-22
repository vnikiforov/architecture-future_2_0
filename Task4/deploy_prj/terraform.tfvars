# terraform.tfvars
# Значения переменных для продуктивного окружения

environment      = "prod"
location         = "westeurope"
secondary_location = "northeurope"
location_short   = "weu"

tags = {
  Project     = "Future2.0"
  ManagedBy   = "Terraform"
  Environment = "prod"
  CostCenter  = "Infrastructure"
}

admin_username = "azureadmin"
# admin_password задается через переменные окружения или в pipeline

# Hub-инфраструктура
hub_resource_group_name = "rg-hub-weu"
hub_vnet_name          = "vnet-hub-weu"
hub_subnet_name        = "snet-hub-gateway"

# Сетевые CIDR
clinics_vnet_cidr        = "10.10.0.0/20"
clinics_app_subnet_cidr  = "10.10.0.0/22"
clinics_data_subnet_cidr = "10.10.4.0/22"
clinics_web_subnet_cidr  = "10.10.8.0/24"

# Другие домены (для полноты)
fintech_vnet_cidr        = "10.11.0.0/20"
ai_vnet_cidr             = "10.12.0.0/20"
pharma_vnet_cidr         = "10.13.0.0/20"
electronics_vnet_cidr    = "10.14.0.0/20"

# VM размеры
clinics_legacy_vm_size         = "Standard_D4s_v4"
clinics_legacy_os_disk_size    = 128
clinics_legacy_data_disk_size  = 512

# AKS
kubernetes_version           = "1.27"
clinics_aks_system_node_count = 2
clinics_aks_system_vm_size    = "Standard_D4s_v4"
clinics_aks_app_vm_size       = "Standard_D8s_v4"
clinics_aks_app_node_count    = 3
clinics_aks_app_min_count     = 3
clinics_aks_app_max_count     = 10
clinics_aks_service_cidr      = "172.16.0.0/16"
clinics_aks_dns_ip            = "172.16.0.10"

# Базы данных
clinics_sql_sku          = "GP_Gen5"
clinics_sql_vcores       = 8
clinics_sql_storage_gb   = 400
# clinics_sql_admin_username/password задаются отдельно

fintech_sql_sku          = "HS_Gen5_4"
fintech_sql_max_size_gb  = 1024
fintech_aks_subnet_start_ip = "10.11.0.4"
fintech_aks_subnet_end_ip   = "10.11.0.254"

ai_postgres_sku          = "GP_Standard_D4s_v3"
ai_postgres_storage_mb   = 512000

electronics_cosmos_throughput = 4000
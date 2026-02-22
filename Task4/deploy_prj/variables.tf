# variables.tf

# ====================================================================
# Базовые переменные
# ====================================================================
variable "environment" {
  description = "Окружение (dev, stage, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "Окружение должно быть dev, stage или prod"
  }
}

variable "location" {
  description = "Регион Azure для развертывания"
  type        = string
  default     = "westeurope"
}

variable "secondary_location" {
  description = "Вторичный регион для отказоустойчивости"
  type        = string
  default     = "northeurope"
}

variable "location_short" {
  description = "Короткое обозначение региона (для именования ресурсов)"
  type        = string
  default     = "weu"
}

variable "tags" {
  description = "Общие теги для всех ресурсов"
  type        = map(string)
  default = {
    Project     = "Future2.0"
    ManagedBy   = "Terraform"
    Environment = "dev"
  }
}

variable "admin_username" {
  description = "Имя администратора для VM"
  type        = string
  default     = "azureadmin"
}

variable "admin_password" {
  description = "Пароль администратора для VM"
  type        = string
  default     = "P@ssw0rd123!" # Только для тестов!
  sensitive   = true
}

# ====================================================================
# Hub-инфраструктура (создается вручную)
# ====================================================================
variable "hub_resource_group_name" {
  description = "Имя Resource Group для Hub-инфраструктуры"
  type        = string
  default     = "rg-hub-weu"
}

variable "hub_vnet_name" {
  description = "Имя Hub VNet"
  type        = string
  default     = "vnet-hub-weu"
}

variable "hub_subnet_name" {
  description = "Имя подсети в Hub для пиринга"
  type        = string
  default     = "snet-hub-gateway"
}

# ====================================================================
# Сетевые CIDR для доменов
# ====================================================================
variable "clinics_vnet_cidr" {
  description = "CIDR для VNet домена Клиники"
  type        = string
  default     = "10.10.0.0/20"
}

variable "clinics_app_subnet_cidr" {
  description = "CIDR для подсети приложений домена Клиники"
  type        = string
  default     = "10.10.0.0/22"
}

variable "clinics_data_subnet_cidr" {
  description = "CIDR для подсети данных домена Клиники"
  type        = string
  default     = "10.10.4.0/22"
}

variable "clinics_web_subnet_cidr" {
  description = "CIDR для веб-подсети домена Клиники"
  type        = string
  default     = "10.10.8.0/24"
}

variable "fintech_vnet_cidr" {
  description = "CIDR для VNet домена Финтех"
  type        = string
  default     = "10.11.0.0/20"
}

variable "ai_vnet_cidr" {
  description = "CIDR для VNet домена ИИ"
  type        = string
  default     = "10.12.0.0/20"
}

variable "ai_data_subnet_cidr" {
  description = "CIDR для подсети данных домена ИИ"
  type        = string
  default     = "10.12.0.0/24"
}

variable "pharma_vnet_cidr" {
  description = "CIDR для VNet домена Фарма"
  type        = string
  default     = "10.13.0.0/20"
}

variable "electronics_vnet_cidr" {
  description = "CIDR для VNet домена Электроника"
  type        = string
  default     = "10.14.0.0/20"
}

# ====================================================================
# VM размеры
# ====================================================================
variable "clinics_legacy_vm_size" {
  description = "Размер VM для Legacy-компонентов в домене Клиники"
  type        = string
  default     = "Standard_D4s_v4"
}

variable "clinics_legacy_os_disk_size" {
  description = "Размер OS-диска для Legacy VM (ГБ)"
  type        = number
  default     = 128
}

variable "clinics_legacy_data_disk_size" {
  description = "Размер data-диска для Legacy VM (ГБ)"
  type        = number
  default     = 256
}

# ====================================================================
# AKS параметры
# ====================================================================
variable "kubernetes_version" {
  description = "Версия Kubernetes"
  type        = string
  default     = "1.27"
}

variable "clinics_aks_system_node_count" {
  description = "Количество системных нод в AKS"
  type        = number
  default     = 2
}

variable "clinics_aks_system_vm_size" {
  description = "Размер VM для системных нод AKS"
  type        = string
  default     = "Standard_D4s_v4"
}

variable "clinics_aks_app_vm_size" {
  description = "Размер VM для нод приложений AKS"
  type        = string
  default     = "Standard_D8s_v4"
}

variable "clinics_aks_app_node_count" {
  description = "Начальное количество нод приложений"
  type        = number
  default     = 3
}

variable "clinics_aks_app_min_count" {
  description = "Минимальное количество нод приложений"
  type        = number
  default     = 3
}

variable "clinics_aks_app_max_count" {
  description = "Максимальное количество нод приложений"
  type        = number
  default     = 10
}

variable "clinics_aks_service_cidr" {
  description = "CIDR для сервисов AKS"
  type        = string
  default     = "172.16.0.0/16"
}

variable "clinics_aks_dns_ip" {
  description = "IP адрес DNS сервиса в AKS"
  type        = string
  default     = "172.16.0.10"
}

# ====================================================================
# Базы данных
# ====================================================================
variable "clinics_sql_sku" {
  description = "SKU для SQL Managed Instance"
  type        = string
  default     = "GP_Gen5"
}

variable "clinics_sql_vcores" {
  description = "Количество vCores для SQL Managed Instance"
  type        = number
  default     = 8
}

variable "clinics_sql_storage_gb" {
  description = "Размер хранилища для SQL Managed Instance (ГБ)"
  type        = number
  default     = 400
}

variable "clinics_sql_admin_username" {
  description = "Имя администратора SQL Managed Instance"
  type        = string
  default     = "sqladmin"
  sensitive   = true
}

variable "clinics_sql_admin_password" {
  description = "Пароль администратора SQL Managed Instance"
  type        = string
  default     = "SqlP@ss123!"
  sensitive   = true
}

variable "fintech_sql_sku" {
  description = "SKU для SQL Hyperscale"
  type        = string
  default     = "HS_Gen5_4"
}

variable "fintech_sql_max_size_gb" {
  description = "Максимальный размер БД (ГБ)"
  type        = number
  default     = 1024
}

variable "fintech_sql_admin_username" {
  description = "Имя администратора SQL Server"
  type        = string
  default     = "fintechadmin"
  sensitive   = true
}

variable "fintech_sql_admin_password" {
  description = "Пароль администратора SQL Server"
  type        = string
  default     = "FinP@ss123!"
  sensitive   = true
}

variable "fintech_aks_subnet_start_ip" {
  description = "Начальный IP подсети AKS для firewall правила"
  type        = string
  default     = "10.11.0.4"
}

variable "fintech_aks_subnet_end_ip" {
  description = "Конечный IP подсети AKS для firewall правила"
  type        = string
  default     = "10.11.0.254"
}

variable "ai_postgres_sku" {
  description = "SKU для PostgreSQL Flexible Server"
  type        = string
  default     = "GP_Standard_D4s_v3"
}

variable "ai_postgres_storage_mb" {
  description = "Размер хранилища PostgreSQL (МБ)"
  type        = number
  default     = 512000
}

variable "ai_postgres_admin_username" {
  description = "Имя администратора PostgreSQL"
  type        = string
  default     = "pgadmin"
  sensitive   = true
}

variable "ai_postgres_admin_password" {
  description = "Пароль администратора PostgreSQL"
  type        = string
  default     = "PgP@ss123!"
  sensitive   = true
}

variable "electronics_cosmos_throughput" {
  description = "Пропускная способность Cosmos DB (RU/s)"
  type        = number
  default     = 4000
}

# ====================================================================
# Флаг для переключения между моками и реальным Azure
# ====================================================================
variable "use_azure_provider" {
  description = "Использовать реальный Azure provider (требует auth)"
  type        = bool
  default     = false
}
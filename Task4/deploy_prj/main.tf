# main.tf
# Учебная конфигурация: по умолчанию использует null/local провайдеры
# Для работы с Azure: установить use_azure_provider = true и настроить auth

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    # === MOCK PROVIDERS (всегда доступны) ===
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    
    # === AZURE PROVIDER (опционально) ===
    # azurerm = {
    #   source  = "hashicorp/azurerm"
    #   version = "~> 3.0"
    # }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# ====================================================================
# Azure Provider (закомментирован по умолчанию)
# Раскомментировать при use_azure_provider = true и настроить auth
# ====================================================================
# provider "azurerm" {
#   features {
#     key_vault {
#       purge_soft_delete_on_destroy    = true
#       recover_soft_deleted_key_vaults = true
#     }
#   }
#   use_cli = true
#   skip_provider_registration = var.use_azure_provider ? false : true
# }

# ====================================================================
# Mock-ресурсы (имитируют Azure-инфраструктуру)
# ====================================================================

# Имитация Resource Groups через local_file
resource "local_file" "rg_clinics" {
  count    = var.use_azure_provider ? 0 : 1
  content  = jsonencode({ name = "rg-${var.environment}-clinics-${var.location_short}", location = var.location, tags = var.tags })
  filename = "${path.module}/.mock/rg-clinics.json"
}

resource "local_file" "rg_fintech" {
  count    = var.use_azure_provider ? 0 : 1
  content  = jsonencode({ name = "rg-${var.environment}-fintech-${var.location_short}", location = var.location, tags = var.tags })
  filename = "${path.module}/.mock/rg-fintech.json"
}

resource "local_file" "rg_ai" {
  count    = var.use_azure_provider ? 0 : 1
  content  = jsonencode({ name = "rg-${var.environment}-ai-${var.location_short}", location = var.location, tags = var.tags })
  filename = "${path.module}/.mock/rg-ai.json"
}

resource "local_file" "rg_pharma" {
  count    = var.use_azure_provider ? 0 : 1
  content  = jsonencode({ name = "rg-${var.environment}-pharma-${var.location_short}", location = var.location, tags = var.tags })
  filename = "${path.module}/.mock/rg-pharma.json"
}

resource "local_file" "rg_electronics" {
  count    = var.use_azure_provider ? 0 : 1
  content  = jsonencode({ name = "rg-${var.environment}-electronics-${var.location_short}", location = var.location, tags = var.tags })
  filename = "${path.module}/.mock/rg-electronics.json"
}

# Имитация Key Vault
resource "local_file" "key_vault_main" {
  count    = var.use_azure_provider ? 0 : 1
  content  = jsonencode({
    name = "kv-${var.environment}-${var.location_short}-001",
    vault_uri = "https://kv-${var.environment}-${var.location_short}-001.vault.azure.net/",
    sku = "premium"
  })
  filename = "${path.module}/.mock/key-vault.json"
}

# Имитация Spoke VNet для Clinics
resource "local_file" "clinics_vnet" {
  count    = var.use_azure_provider ? 0 : 1
  content  = jsonencode({
    name = "vnet-${var.environment}-clinics-${var.location_short}",
    address_space = [var.clinics_vnet_cidr]
  })
  filename = "${path.module}/.mock/clinics-vnet.json"
}

# Имитация AKS кластера
resource "local_file" "clinics_aks" {
  count    = var.use_azure_provider ? 0 : 1
  content  = jsonencode({
    name = "aks-${var.environment}-clinics-${var.location_short}",
    kubernetes_version = var.kubernetes_version,
    kube_config = "mock-kubeconfig-content"
  })
  filename = "${path.module}/.mock/clinics-aks.json"
}

# Имитация SQL Managed Instance
resource "local_file" "clinics_sql" {
  count    = var.use_azure_provider ? 0 : 1
  content  = jsonencode({
    name = "sqlmi-${var.environment}-clinics-${var.location_short}",
    fqdn = "sqlmi-${var.environment}-clinics-${var.location_short}.database.windows.net"
  })
  filename = "${path.module}/.mock/clinics-sql.json"
}

# Имитация PostgreSQL для AI
resource "local_file" "ai_postgres" {
  count    = var.use_azure_provider ? 0 : 1
  content  = jsonencode({
    name = "psql-${var.environment}-ai-${var.location_short}",
    fqdn = "psql-${var.environment}-ai-${var.location_short}.postgres.database.azure.com"
  })
  filename = "${path.module}/.mock/ai-postgres.json"
}

# Имитация Cosmos DB для Electronics
resource "local_file" "electronics_cosmos" {
  count    = var.use_azure_provider ? 0 : 1
  content  = jsonencode({
    name = "cosmos-${var.environment}-electronics-${var.location_short}",
    endpoint = "https://cosmos-${var.environment}-electronics-${var.location_short}.documents.azure.com:443/"
  })
  filename = "${path.module}/.mock/electronics-cosmos.json"
}

# Имитация Data Lake Storage
resource "local_file" "datalake" {
  count    = var.use_azure_provider ? 0 : 1
  content  = jsonencode({
    name = "st${var.environment}datalake${var.location_short}",
    primary_blob_endpoint = "https://st${var.environment}datalake${var.location_short}.blob.core.windows.net/"
  })
  filename = "${path.module}/.mock/datalake.json"
}

# Имитация Log Analytics Workspace
resource "local_file" "log_analytics" {
  count    = var.use_azure_provider ? 0 : 1
  content  = jsonencode({
    name = "log-${var.environment}-${var.location_short}",
    workspace_id = "00000000-0000-0000-0000-000000000000"
  })
  filename = "${path.module}/.mock/log-analytics.json"
}

# ====================================================================
# Реальные Azure-ресурсы (раскомментировать при use_azure_provider = true)
# Ниже — пример для одного ресурса, остальные добавлять по аналогии
# ====================================================================
# data "azurerm_resource_group" "hub" {
#   count = var.use_azure_provider ? 1 : 0
#   name  = var.hub_resource_group_name
# }
# 
# resource "azurerm_resource_group" "clinics" {
#   count    = var.use_azure_provider ? 1 : 0
#   name     = "rg-${var.environment}-clinics-${var.location_short}"
#   location = var.location
#   tags     = var.tags
# }
# 
# resource "azurerm_key_vault" "main" {
#   count               = var.use_azure_provider ? 1 : 0
#   name                = "kv-${var.environment}-${var.location_short}-001"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.clinics[0].name
#   tenant_id           = data.azurerm_client_config.current[0].tenant_id
#   sku_name            = "premium"
#   # ... остальные параметры ...
# }

# ====================================================================
# null_resource для демонстрации lifecycle (всегда работает)
# ====================================================================
resource "null_resource" "deployment_marker" {
  triggers = {
    environment = var.environment
    timestamp   = timestamp()
  }
  
  provisioner "local-exec" {
    command = "echo 'Deployment simulated at ${timestamp()}' >> ${path.module}/.mock/deploy.log"
  }
}
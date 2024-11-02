# configure Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "satfstateioaioeja"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

# --------------
# variable definitions
variable "resource_group_name" {
  default = "rg-resumecloudchallenge-dev"
}
variable "resource_group_location" {
  default = "eastus"
}

variable "project_name" {
  default = "resumecloudchallenge"
}


#------------------
# resource definitions
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "random_string" "resource_code" {
  length  = 4
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_storage_account" "sa" {
  name                     = "sacloud${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = "Canada Central"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  static_website {
    index_document     = "index.html"
    error_404_document = "error.html"
  }
}

resource "azurerm_application_insights" "app-insights" {
  name                = "fa-app-insights-${var.project_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "Canada Central"
  application_type    = "web"
}

resource "azurerm_app_service_plan" "asp" {
  name                = "asp-${var.project_name}"
  location            = "Canada Central"
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }

  lifecycle {
    ignore_changes = [
      kind
    ]
  }
}


resource "azurerm_function_app" "fa" {
  name                = "fa-${var.project_name}"
  location            = "Canada Central"
  resource_group_name = azurerm_resource_group.rg.name

  app_service_plan_id        = azurerm_app_service_plan.asp.id
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  os_type                    = "linux"
  version                    = "~4"

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME              = "python"
    APPINSIGHTS_INSTRUMENTATIONKEY        = azurerm_application_insights.app-insights.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.app-insights.connection_string
    AzureWebJobsFeatureFlags              = "EnableWorkerIndexing"
    AzureWebJobsStorage                   = azurerm_storage_account.sa.primary_connection_string
    # WEBSITE_RUN_FROM_PACKAGE              = "1"
    CONNECTION_STRING = azurerm_storage_account.sa.primary_connection_string
  }

  site_config {
    linux_fx_version = "python|3.9" # remember to update this to 3.11

    cors {
      allowed_origins     = [trimsuffix(azurerm_storage_account.sa.primary_web_endpoint, "/")]
      support_credentials = true
    }

  }
}

# outputs <- primary endpoint, function url, 
output "primary_web_endpoint" {
  value = trimsuffix(azurerm_storage_account.sa.primary_web_endpoint, "/")
}

output "function_url" {
  value = "https://${azurerm_function_app.fa.default_hostname}.azurewebsites.net/api"
}

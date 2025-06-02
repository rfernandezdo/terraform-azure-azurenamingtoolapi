# This file defines the required providers for the Terraform configuration.
terraform {
  required_providers {    
    http = {
      source  = "hashicorp/http"
      version = ">= 3.0.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}


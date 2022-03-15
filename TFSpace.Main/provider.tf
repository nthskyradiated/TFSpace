terraform {
  
   cloud {
     organization = "nthskyIO"

     workspaces {
       tags = ["main"]
       }
   }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">=4.5.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}


provider "azurerm" {
  # Configuration options
  alias = "azure"
  }

provider "kubernetes" {
  # Configuration options
  alias = "k8s"
}

provider "github" {
  # Configuration options
  alias = "ghub"
}

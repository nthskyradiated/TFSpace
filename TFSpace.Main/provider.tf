terraform {

  cloud {
    organization = "nthskyIO"
    workspaces {
      tags = ["main"]
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.5.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
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

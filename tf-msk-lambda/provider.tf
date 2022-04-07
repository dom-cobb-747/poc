
locals {
  project = "project"
}


terraform {
  required_version = ">= 1.1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket  = "orlando1409-app"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    profile = "aws-ct-default"
  }
}

provider "aws" {
  profile = "aws-ct-default"
  region  = "us-east-1"
}

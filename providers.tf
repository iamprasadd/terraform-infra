terraform {
  required_version = ">= 1.4.0"

  backend "s3" {
    bucket = "prasad-terraform-backend-bucket"
    key    = "terraform/dev/terraform.tfstate"  # placeholder for init
    region = "eu-north-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

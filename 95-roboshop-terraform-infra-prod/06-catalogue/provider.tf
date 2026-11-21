terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
  backend "s3" {
      bucket = "roboshop-infra-remotestate-prod"
      key = "catalogue/terraform.tfstate"
      region = "us-east-1"
      dynamodb_table = "roboshop-infra-remotelock-prod"
  }
}

provider "aws" { 
  region = "us-east-1"
}
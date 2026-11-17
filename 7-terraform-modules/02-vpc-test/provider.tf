terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
  backend "s3" {
      bucket = "roboshop-remotebucket"
      key = "vpc-test"
      region = "us-east-1"
      dynamodb_table = "roboshop-remotebucket-lock"
  }
}

provider "aws" { 
  region = "us-east-1"
}
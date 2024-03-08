terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.64.0"
    }
  }

  backend "s3" {
    bucket = "timing-backend-s3"
    key    = "session-04"
    region = "us-east-1"
    dynamodb_table = "timing-lock"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
  
}
terraform {
  required_version = ">=1.0"
  backend "local" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.region

}

resource "aws_s3_bucket" "bucket" {
  bucket = "streamify"
}

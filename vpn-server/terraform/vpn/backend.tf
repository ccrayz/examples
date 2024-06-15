terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = ">= 1.0.0"
  }

  # Using the "backend" block configures Terraform to store state in S3
  # backend "s3" {}
}

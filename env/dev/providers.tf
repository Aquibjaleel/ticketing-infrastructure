terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  #Optional: Uncomment this later once you have an S3 bucket to store your state file
  backend "s3" {
    bucket = "skillslab-tfstate-bucket-aquib-2026"
    key    = "dev/infrastructure.tfstate"
    region = "us-east-1"
  }

}

provider "aws" {
  region = "us-east-1"
}


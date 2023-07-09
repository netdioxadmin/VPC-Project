terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"

    }
  }
}
#Config The Aws Provierr
provider "aws" {
  region                  = var.region
  shared_credentials_files = ["~/.aws/credentials"]

}
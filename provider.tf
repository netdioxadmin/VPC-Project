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
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key

}
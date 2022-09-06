provider "aws" {
  region = "us-east-1"
}

module "EB" {
  source = "./modules/EB"
}
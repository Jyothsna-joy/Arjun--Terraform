/*
HCL Code to build appruner with git repo

*/

# $ terraform import aws_apprunner_connection.amktest amktest  [ Use this comand to import existing connection]
provider "aws" {
  region = "us-east-1"
}

module "AppRunner" {
  source = "./modules/"
}
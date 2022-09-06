/*
HCL Code to build appruner with git repo 
Arjun
*/

# $ terraform import aws_apprunner_connection.amktest amktest  [ Use this comand to import existing connection]
provider "aws" {
  region = "us-east-1"
}

resource "aws_apprunner_connection" "amtest" {
  connection_name = var.connection_name
  provider_type   = var.provider_type

  tags = {
    Name = var.Name
  }
}

resource "aws_apprunner_service" "amtest" {
  service_name = var.service_name

  source_configuration {
    authentication_configuration {
      connection_arn = aws_apprunner_connection.amtest.arn
    }
    code_repository {
      code_configuration {
        code_configuration_values {
          build_command = var.build_command
          port          = var.port
          runtime       = var.runtime
          start_command = var.start_command
        }
        configuration_source = var.configuration_source
      }
      repository_url = "https://github.com/ArjunManojKumar/flaskapp.git"
      source_code_version {
        type  = var.type
        value = var.value
      }
    }
  }
  tags = {
    Name = "myapp2-apprunner-service"
  }
  depends_on = [aws_apprunner_connection.amtest]
}
resource "aws_elastic_beanstalk_application" "amk" {
  name        = var.name
  description = var.description
}

resource "aws_elastic_beanstalk_environment" "AMK" {
  name                = var.name
  application         = aws_elastic_beanstalk_application.amk.name
  solution_stack_name = var.solution_stack_name

 setting {
        namespace = var.namespace
        name      = var.name2
        value     = var.value
      }
}
module "tagsmap" {
  source                = "../../../tagsmap/"
  application_name      = "DEMO APP"
  application_code      = "FDS"
  application_owner     = "Troy.Lillehoff@wu.com"
  aws_region            = "us-east-1"
  business_unit         = "WesternUnion"
  cost_center           = "1390"
  domain                = "Foundation"
  environment           = "DEV"
  patch_group           = "Foundation"
  product_tower         = "Foundation"
  production_level_code = "Development"
  request_id            = "LZ"
  security_posture      = "NON PCI"
  support_contact       = "ioc_ccoe@wu.com"
}


module "auto_scaling_group" {
  naming_prefix             = module.tagsmap.naming_prefix_upper
  common_tags               = module.tagsmap.common_tags
  source                    = "../../"
  function                  = "auto-scaling-demo"
  increment_code            = "001"
  description               = "terraform demo auto scaling group"
  name                      = "test auto scaling group"
  min_size                  = 1
  max_size                  = 2
  launch_configuration_name = "test"
  vpc_zone_identifier       = ["subnet-09bb23f006d889061"]

  ##### with lifecycle hook
  policy_hook_name                    = "Demo-hook"
  policy_hook_default_result          = "CONTINUE"
  policy_hook_heartbeat_timeout       = 2000
  policy_hook_lifecycle_transition    = "autoscaling:EC2_INSTANCE_LAUNCHING"
  policy_hook_notification_metadata   = <<EOF
  {
    "foo": "bar"
  }
  EOF
  policy_hook_notification_target_arn = "arn:aws:sqs:us-east-1:006602859727:test"
  policy_hook_role_arn                = "arn:aws:iam::006602859727:role/CA-ROL-Finops"
}

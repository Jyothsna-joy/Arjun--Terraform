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

  ##### with schedule
  schedule_name             = "Demo-Schedule"
  schedule_min_size         = 1
  schedule_max_size         = 2
  schedule_start_time       = "2022-12-11T18:00:00Z"
  schedule_end_time         = "2022-12-11T18:00:00Z"
  schedule_desired_capacity = 1
}

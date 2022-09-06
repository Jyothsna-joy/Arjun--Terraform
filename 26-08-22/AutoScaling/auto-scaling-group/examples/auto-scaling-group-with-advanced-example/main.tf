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
  default_instance_warmup   = 3600
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = false
  termination_policies      = ["OldestLaunchConfiguration"]
  suspended_processes       = ["Launch"]
  # placement_group           = "test"
  metrics_granularity       = "1Minute"
  enabled_metrics           = ["GroupMinSize"]
  wait_for_capacity_timeout = "1m"
  min_elb_capacity          = 1
  wait_for_elb_capacity     = 1
  protect_from_scale_in     = false
  max_instance_lifetime     = 86400
  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }
  warm_pool = {
    # pool_state                  = "Hibernated"
    min_size                    = 1
    max_group_prepared_capacity = 10
    instance_reuse_policy = {
      reuse_on_scale_in = false
    }
  }
  # TODO: untested, permission issue
  # mixed_instances_policy = {
  #   launch_template = {
  #     launch_template_specification = {
  #       launch_template_id = "lt-05acbda7ae208b44f"
  #     }
  #     override = [
  #       {
  #         instance_type     = "t2.nano"
  #         weighted_capacity = "2"
  #       },
  #       {
  #         instance_type     = "t2.micro"
  #         weighted_capacity = "3"
  #       }
  #     ]
  #   }
  # }

  service_linked_role_arn = "arn:aws:iam::006602859727:role/CA-ROL-Finops"
  load_balancers          = ["test-load-balancer"]
  initial_lifecycle_hook = {
    name                    = "demo-initial-hook"
    default_result          = "CONTINUE"
    heartbeat_timeout       = 2000
    lifecycle_transition    = "autoscaling:EC2_INSTANCE_LAUNCHING"
    notification_metadata   = <<EOF
      {
        "foo": "bar"
      }
    EOF
    notification_target_arn = "arn:aws:sqs:us-east-1:006602859727:test"
    role_arn                = "arn:aws:iam::123456789012:role/S3Access"
  }
}

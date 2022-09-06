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


  #### with policy

  # TODO: need more testing, wating for strcture feedback
  policy_name                     = "Demo-Policy"
  policy_adjustment_type          = "PercentChangeInCapacity"
  policy_scaling_adjustment       = 4
  policy_type                     = "SimpleScaling"
  policy_cooldown                 = 300
  policy_min_adjustment_magnitude = 1
  policy_predictive_scaling_configuration = {
    metric_specification = [{
      target_value = 10
      customized_capacity_metric_specification = [{
        metric_data_queries = [
          {
            id         = "load_sum"
            expression = "SUM(SEARCH('{AWS/EC2,AutoScalingGroupName} MetricName=\"CPUUtilization\" my-test-asg', 'Sum', 3600))"
          }
        ]
      }]
      customized_scaling_metric_specification = [{
        metric_data_queries = [
          {
            id = "scaling"
            metric_stat = {
              metric = {
                metric_name = "CPUUtilization"
                namespace   = "AWS/EC2"
                dimensions = [
                  {
                    name  = "AutoScalingGroupName"
                    value = "my-test-asg"
                  }
                ]
              }
              stat = "Average"
            }
          }
        ]
      }]
      customized_load_metric_specification = [{
        metric_data_queries = [
          {
            id          = "capacity_sum"
            expression  = "SUM(SEARCH('{AWS/AutoScaling,AutoScalingGroupName} MetricName=\"GroupInServiceIntances\" my-test-asg', 'Average', 300))"
            return_data = false
          },
          {
            id          = "load_sum"
            expression  = "SUM(SEARCH('{AWS/EC2,AutoScalingGroupName} MetricName=\"CPUUtilization\" my-test-asg', 'Sum', 300))"
            return_data = false
          },
          {
            id         = "weighted_average"
            expression = "load_sum / capacity_sum"
          }
        ]
      }]
    }]
  }
}

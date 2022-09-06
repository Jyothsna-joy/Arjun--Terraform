locals {
  name                   = "${var.naming_prefix}-ASG-${var.function}-${var.increment_code}"
  instance_refresh       = var.instance_refresh != null ? [var.instance_refresh] : []
  warm_pool              = var.warm_pool != null ? [var.warm_pool] : []
  mixed_instances_policy = var.mixed_instances_policy != null ? [var.mixed_instances_policy] : []
  tags = merge(
    var.common_tags,
    var.additional_tags,
    tomap(
      {
        "Name"        = local.name,
        "Service"     = "Auto Scaling Group",
        "Description" = var.description
      }
    )
  )
  initial_lifecycle_hook = var.initial_lifecycle_hook != null ? [var.initial_lifecycle_hook] : []
}


#TODO: incomplete
resource "aws_autoscaling_group" "main" {
  name = local.name
  dynamic "tag" {
    for_each = local.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  max_size                = var.max_size
  min_size                = var.min_size
  availability_zones      = var.availability_zones
  capacity_rebalance      = var.capacity_rebalance
  default_cooldown        = var.default_cooldown
  launch_configuration    = var.launch_configuration_name
  vpc_zone_identifier     = var.vpc_zone_identifier
  default_instance_warmup = var.default_instance_warmup
  dynamic "initial_lifecycle_hook" {
    for_each = local.initial_lifecycle_hook
    content {
      name                    = lookup(initial_lifecycle_hook.value, "name", null)
      default_result          = lookup(initial_lifecycle_hook.value, "default_result", null)
      heartbeat_timeout       = lookup(initial_lifecycle_hook.value, "heartbeat_timeout", null)
      lifecycle_transition    = lookup(initial_lifecycle_hook.value, "lifecycle_transition", null)
      notification_metadata   = lookup(initial_lifecycle_hook.value, "notification_metadata", null)
      notification_target_arn = lookup(initial_lifecycle_hook.value, "notification_target_arn", null)
      role_arn                = lookup(initial_lifecycle_hook.value, "role_arn", null)
    }
  }
  # TODO: incomplete - object/array fix need to done
  dynamic "mixed_instances_policy" {
    for_each = local.mixed_instances_policy
    content {
      dynamic "instances_distribution" {
        for_each = lookup(mixed_instances_policy.value, "instances_distribution", null) != null ? [mixed_instances_policy.value] : []
        content {
          on_demand_allocation_strategy            = lookup(instances_distribution.value, "on_demand_allocation_strategy", null)
          on_demand_base_capacity                  = lookup(instances_distribution.value, "on_demand_base_capacity", null)
          on_demand_percentage_above_base_capacity = lookup(instances_distribution.value, "on_demand_percentage_above_base_capacity", null)
          spot_allocation_strategy                 = lookup(instances_distribution.value, "spot_allocation_strategy", null)
          spot_instance_pools                      = lookup(instances_distribution.value, "spot_instance_pools", null)
          spot_max_price                           = lookup(instances_distribution.value, "spot_max_price", null)
        }
      }
      dynamic "launch_template" {
        for_each = lookup(mixed_instances_policy.value, "launch_template", null) != null ? [mixed_instances_policy.value.launch_template] : []
        content {
          dynamic "launch_template_specification" {
            for_each = lookup(launch_template.value, "launch_template_specification", null) != null ? [launch_template.value.launch_template_specification] : []
            content {
              launch_template_id   = lookup(launch_template_specification.value, "launch_template_id", null)
              launch_template_name = lookup(launch_template_specification.value, "launch_template_name", null)
              version              = lookup(launch_template_specification.value, "version", null)
            }
          }
          dynamic "override" {
            for_each = lookup(launch_template.value, "override", null) != null ? launch_template.value.override : []
            content {
              instance_type = lookup(override.value, "instance_type", null)
              dynamic "launch_template_specification" {
                for_each = lookup(override.value, "launch_template_specification", null) != null ? [override.value.launch_template_specification] : []
                content {
                  launch_template_id   = lookup(launch_template_specification.value, "launch_template_id", null)
                  launch_template_name = lookup(launch_template_specification.value, "launch_template_name", null)
                  version              = lookup(launch_template_specification.value, "version", null)
                }
              }
              weighted_capacity = lookup(override.value, "weighted_capacity", null)
              dynamic "instance_requirements" {
                for_each = lookup(override.value, "instance_requirements", null) != null ? [override.value.instance_requirements] : []
                content {
                  dynamic "accelerator_count" {
                    for_each = instance_requirements.value.accelerator_count != null ? [instance_requirements.value.accelerator_count] : []
                    content {
                      min = lookup(accelerator_count.value, "min", null)
                      max = lookup(accelerator_count.value, "max", null)
                    }
                  }
                  accelerator_manufacturers = lookup(instance_requirements.value, "accelerator_manufacturers", null)
                  accelerator_names         = lookup(instance_requirements.value, "accelerator_names", null)
                  dynamic "accelerator_total_memory_mib" {
                    for_each = lookup(instance_requirements.value, "accelerator_total_memory_mib", null) != null ? [instance_requirements.value.accelerator_total_memory_mib] : []
                    content {
                      min = lookup(accelerator_total_memory_mib.value, "min", null)
                      max = lookup(accelerator_total_memory_mib.value, "max", null)
                    }
                  }
                  accelerator_types = lookup(instance_requirements.value, "accelerator_types", null)
                  bare_metal        = lookup(instance_requirements.value, "bare_metal", null)
                  dynamic "baseline_ebs_bandwidth_mbps" {
                    for_each = lookup(instance_requirements.value, "baseline_ebs_bandwidth_mbps", null) != null ? [instance_requirements.value.baseline_ebs_bandwidth_mbps] : []
                    content {
                      min = lookup(baseline_ebs_bandwidth_mbps.value, "min", null)
                      max = lookup(baseline_ebs_bandwidth_mbps.value, "max", null)
                    }
                  }
                  burstable_performance   = lookup(instance_requirements.value, "burstable_performance", null)
                  cpu_manufacturers       = lookup(instance_requirements.value, "cpu_manufacturers", null)
                  excluded_instance_types = lookup(instance_requirements.value, "excluded_instance_types", null)
                  instance_generations    = lookup(instance_requirements.value, "instance_generations", null)
                  local_storage           = lookup(instance_requirements.value, "local_storage", null)
                  local_storage_types     = lookup(instance_requirements.value, "local_storage_types", null)
                  dynamic "memory_gib_per_vcpu" {
                    for_each = lookup(instance_requirements.value, "memory_gib_per_vcpu", null) != null ? [instance_requirements.value.memory_gib_per_vcpu] : []
                    content {
                      min = lookup(memory_gib_per_vcpu.value, "min", null)
                      max = lookup(memory_gib_per_vcpu.value, "max", null)
                    }
                  }
                  dynamic "memory_mib" {
                    for_each = lookup(instance_requirements.value, "memory_mib", null) != null ? [instance_requirements.value.memory_mib] : []
                    content {
                      min = lookup(memory_mib.value, "min", null)
                      max = lookup(memory_mib.value, "max", null)
                    }
                  }
                  dynamic "network_interface_count" {
                    for_each = lookup(instance_requirements.value, "network_interface_count", null) != null ? [instance_requirements.value.network_interface_count] : []
                    content {
                      min = lookup(memory_mib.value, "min", null)
                      max = lookup(memory_mib.value, "max", null)
                    }
                  }
                  on_demand_max_price_percentage_over_lowest_price = lookup(instance_requirements.value, "on_demand_max_price_percentage_over_lowest_price", null)
                  require_hibernate_support                        = lookup(instance_requirements.value, "require_hibernate_support", null)
                  spot_max_price_percentage_over_lowest_price      = lookup(instance_requirements.value, "spot_max_price_percentage_over_lowest_price", null)
                  dynamic "total_local_storage_gb" {
                    for_each = lookup(instance_requirements.value, "total_local_storage_gb", null) != null ? [instance_requirements.value.total_local_storage_gb] : []
                    content {
                      min = lookup(total_local_storage_gb.value, "min", null)
                      max = lookup(total_local_storage_gb.value, "max", null)
                    }
                  }
                  dynamic "vcpu_count" {
                    for_each = lookup(instance_requirements.value, "vcpu_count", null) != null ? [instance_requirements.value.vcpu_count] : []
                    content {
                      min = lookup(vcpu_count.value, "min", null)
                      max = lookup(vcpu_count.value, "max", null)
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  desired_capacity          = var.desired_capacity
  force_delete              = var.force_delete
  load_balancers            = var.load_balancers
  target_group_arns         = var.target_group_arns
  termination_policies      = var.termination_policies
  suspended_processes       = var.suspended_processes
  placement_group           = var.placement_group
  metrics_granularity       = var.metrics_granularity
  enabled_metrics           = var.enabled_metrics
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  min_elb_capacity          = var.min_elb_capacity
  wait_for_elb_capacity     = var.wait_for_elb_capacity
  protect_from_scale_in     = var.protect_from_scale_in
  service_linked_role_arn   = var.service_linked_role_arn
  max_instance_lifetime     = var.max_instance_lifetime
  dynamic "instance_refresh" {
    for_each = local.instance_refresh
    content {
      strategy = instance_refresh.value.strategy
      triggers = lookup(instance_refresh.value, "triggers", null)
      dynamic "preferences" {
        for_each = instance_refresh.value.preferences != null ? [instance_refresh.value.preferences] : []
        content {
          checkpoint_delay       = lookup(preferences.value, "checkpoint_delay", null)
          checkpoint_percentages = lookup(preferences.value, "checkpoint_percentages", null)
          instance_warmup        = lookup(preferences.value, "instance_warmup", null)
          min_healthy_percentage = lookup(preferences.value, "min_healthy_percentage", null)
        }
      }
    }
  }

  dynamic "warm_pool" {
    for_each = local.warm_pool
    content {
      pool_state                  = lookup(warm_pool.value, "pool_state", null)
      min_size                    = lookup(warm_pool.value, "min_size", null)
      max_group_prepared_capacity = lookup(warm_pool.value, "max_group_prepared_capacity", null)
      dynamic "instance_reuse_policy" {
        for_each = warm_pool.value.instance_reuse_policy != null ? [warm_pool.value.instance_reuse_policy] : []
        content {
          reuse_on_scale_in = lookup(instance_reuse_policy.value, "reuse_on_scale_in", null)
        }
      }
    }
  }
}


resource "aws_autoscaling_schedule" "main" {
  count                  = var.schedule_name != null ? 1 : 0
  autoscaling_group_name = aws_autoscaling_group.main.name
  scheduled_action_name  = var.schedule_name
  min_size               = var.schedule_min_size
  max_size               = var.schedule_max_size
  desired_capacity       = var.schedule_desired_capacity
  start_time             = var.schedule_start_time
  end_time               = var.schedule_end_time
  recurrence             = var.schedule_recurrence
  time_zone              = var.schedule_time_zone
}

resource "aws_autoscaling_lifecycle_hook" "main" {
  count                   = var.policy_hook_name != null ? 1 : 0
  autoscaling_group_name  = aws_autoscaling_group.main.name
  name                    = var.policy_hook_name
  lifecycle_transition    = var.policy_hook_lifecycle_transition
  default_result          = var.policy_hook_default_result
  notification_metadata   = var.policy_hook_notification_metadata
  heartbeat_timeout       = var.policy_hook_heartbeat_timeout
  notification_target_arn = var.policy_hook_notification_target_arn
  role_arn                = var.policy_hook_role_arn
}


# TODO: incomplete
resource "aws_autoscaling_policy" "main" {
  count                    = var.policy_name != null ? 1 : 0
  autoscaling_group_name   = aws_autoscaling_group.main.name
  name                     = var.policy_name
  policy_type              = var.policy_type
  adjustment_type          = var.policy_adjustment_type
  scaling_adjustment       = var.policy_scaling_adjustment
  cooldown                 = var.policy_cooldown
  min_adjustment_magnitude = var.policy_min_adjustment_magnitude
  dynamic "predictive_scaling_configuration" {
    for_each = var.policy_predictive_scaling_configuration != null ? [var.policy_predictive_scaling_configuration] : []
    content {
      dynamic "metric_specification" {
        for_each = lookup(predictive_scaling_configuration.value, "metric_specification", null) != null ? predictive_scaling_configuration.value.metric_specification : []
        content {
          target_value = lookup(metric_specification.value, "target_value", null)
          dynamic "customized_load_metric_specification" {
            for_each = lookup(metric_specification.value, "customized_load_metric_specification", null) != null ? metric_specification.value.customized_load_metric_specification : []
            content {
              dynamic "metric_data_queries" {
                for_each = lookup(customized_load_metric_specification.value, "metric_data_queries", null) != null ? customized_load_metric_specification.value.metric_data_queries : []
                content {
                  id         = lookup(metric_data_queries.value, "id", null)
                  expression = lookup(metric_data_queries.value, "expression", null)
                  dynamic "metric_stat" {
                    for_each = lookup(metric_data_queries.value, "metric_stat", null) != null ? metric_data_queries.value.metric_stat : []
                    content {
                      stat = lookup(metric_stat.value, "stat", null)
                      unit = lookup(metric_stat.value, "unit", null)
                      dynamic "metric" {
                        for_each = lookup(metric_stat.value, "metric", null) != null ? metric_stat.value.metric : []
                        content {
                          metric_name = lookup(metric.value, "metric_name", null)
                          namespace   = lookup(metric.value, "namespace", null)
                          dynamic "dimensions" {
                            for_each = lookup(metric.value, "dimensions", null) != null ? metric.value.dimensions : []
                            content {
                              name  = lookup(dimensions.value, "name", null)
                              value = lookup(dimensions.value, "value", null)
                            }
                          }
                        }
                      }
                    }
                  }
                  label       = lookup(metric_data_queries.value, "expression", null)
                  return_data = lookup(metric_data_queries.value, "return_data", null)
                }
              }
            }
          }
          dynamic "customized_capacity_metric_specification" {
            for_each = lookup(metric_specification.value, "customized_capacity_metric_specification", null) != null ? metric_specification.value.customized_capacity_metric_specification : []
            content {
              dynamic "metric_data_queries" {
                for_each = lookup(customized_capacity_metric_specification.value, "metric_data_queries", null) != null ? customized_capacity_metric_specification.value.metric_data_queries : []
                content {
                  id         = lookup(metric_data_queries.value, "id", null)
                  expression = lookup(metric_data_queries.value, "expression", null)
                  dynamic "metric_stat" {
                    for_each = lookup(metric_data_queries.value, "metric_stat", null) != null ? metric_data_queries.value.metric_stat : []
                    content {
                      stat = lookup(metric_stat.value, "stat", null)
                      unit = lookup(metric_stat.value, "unit", null)
                      dynamic "metric" {
                        for_each = lookup(metric_stat.value, "metric", null) != null ? metric_stat.value.metric : []
                        content {
                          metric_name = lookup(metric.value, "metric_name", null)
                          namespace   = lookup(metric.value, "namespace", null)
                          dynamic "dimensions" {
                            for_each = lookup(metric.value, "dimensions", null) != null ? metric.value.dimensions : []
                            content {
                              name  = lookup(dimensions.value, "name", null)
                              value = lookup(dimensions.value, "value", null)
                            }
                          }
                        }
                      }
                    }
                  }
                  label       = lookup(metric_data_queries.value, "expression", null)
                  return_data = lookup(metric_data_queries.value, "return_data", null)
                }
              }
            }
          }
          dynamic "customized_scaling_metric_specification" {
            for_each = lookup(metric_specification.value, "customized_scaling_metric_specification", null) != null ? metric_specification.value.customized_scaling_metric_specification : []
            content {
              dynamic "metric_data_queries" {
                for_each = lookup(customized_scaling_metric_specification.value, "metric_data_queries", null) != null ? customized_scaling_metric_specification.value.metric_data_queries : []
                content {
                  id         = lookup(metric_data_queries.value, "id", null)
                  expression = lookup(metric_data_queries.value, "expression", null)
                  dynamic "metric_stat" {
                    for_each = lookup(metric_data_queries.value, "metric_stat", null) != null ? metric_data_queries.value.metric_stat : []
                    content {
                      stat = lookup(metric_stat.value, "stat", null)
                      unit = lookup(metric_stat.value, "unit", null)
                      dynamic "metric" {
                        for_each = lookup(metric_stat.value, "metric", null) != null ? metric_stat.value.metric : []
                        content {
                          metric_name = lookup(metric.value, "metric_name", null)
                          namespace   = lookup(metric.value, "namespace", null)
                          dynamic "dimensions" {
                            for_each = lookup(metric.value, "dimensions", null) != null ? metric.value.dimensions : []
                            content {
                              name  = lookup(dimensions.value, "name", null)
                              value = lookup(dimensions.value, "value", null)
                            }
                          }
                        }
                      }
                    }
                  }
                  label       = lookup(metric_data_queries.value, "expression", null)
                  return_data = lookup(metric_data_queries.value, "return_data", null)
                }
              }
            }
          }
          dynamic "predefined_load_metric_specification" {
            for_each = lookup(metric_specification.value, "predefined_load_metric_specification", null) != null ? metric_specification.value.predefined_load_metric_specification : []
            content {
              predefined_metric_type = predefined_load_metric_specification.value.predefined_metric_type
              resource_label         = lookup(predefined_load_metric_specification.value, "resource_label", null)
            }
          }
          dynamic "predefined_metric_pair_specification" {
            for_each = lookup(metric_specification.value, "predefined_metric_pair_specification", null) != null ? metric_specification.value.predefined_metric_pair_specification : []
            content {
              predefined_metric_type = predefined_metric_pair_specification.value.predefined_metric_type
              resource_label         = lookup(predefined_metric_pair_specification.value, "resource_label", null)
            }
          }
          dynamic "predefined_scaling_metric_specification" {
            for_each = lookup(metric_specification.value, "predefined_scaling_metric_specification", null) != null ? metric_specification.value.predefined_scaling_metric_specification : []
            content {
              predefined_metric_type = predefined_scaling_metric_specification.value.predefined_metric_type
              resource_label         = lookup(predefined_scaling_metric_specification.value, "resource_label", null)
            }
          }
        }
      }
    }
  }
  estimated_instance_warmup = var.policy_estimated_instance_warmup
  enabled                   = var.policy_enabled
  metric_aggregation_type   = var.policy_metric_aggregation_type
  dynamic "step_adjustment" {
    for_each = var.policy_step_adjustment
    content {
      scaling_adjustment          = step_adjustment.value.scaling_adjustment
      metric_interval_lower_bound = lookup(step_adjustment.value, "metric_interval_lower_bound", null)
      metric_interval_upper_bound = lookup(step_adjustment.value, "metric_interval_upper_bound", null)
    }
  }
  dynamic "target_tracking_configuration" {
    for_each = var.policy_target_tracking_configuration
    content {
      target_value     = target_tracking_configuration.value.target_value
      disable_scale_in = target_tracking_configuration.value.disable_scale_in
      dynamic "predefined_metric_specification" {
        for_each = lookup(target_tracking_configuration.value, "predefined_metric_specification", null) != null ? target_tracking_configuration.value.predefined_metric_specification : []
        content {
          predefined_metric_type = predefined_metric_specification.value.predefined_metric_type
          resource_label         = lookup(predefined_metric_specification.value, "resource_label", null)
        }
      }
      dynamic "customized_metric_specification" {
        for_each = lookup(target_tracking_configuration.value, "customized_metric_specification", null) != null ? target_tracking_configuration.value.customized_metric_specification : []
        content {
          metric_name = customized_metric_specification.value.metric_name
          namespace   = customized_metric_specification.value.namespace
          statistic   = customized_metric_specification.value.statistic
          unit        = customized_metric_specification.value.unit
          dynamic "metric_dimension" {
            for_each = lookup(customized_metric_specification.value, "metric_dimension", null) != null ? customized_metric_specification.value.metric_dimension : []
            content {
              name  = metric_dimension.value.name
              value = metric_dimension.value.value
            }
          }
        }
      }
    }
  }
}


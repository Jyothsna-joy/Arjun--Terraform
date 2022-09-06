# Terraform AWS Module for Auto Scaling Group

This module can be used to launch an s3 bucket.

## Table of Contents

- [Usage](#usage)
- [Examples](#examples)
- [Requirements](#requirements)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [Authors](#authors)

## Usage

```
module "autoScalingGroup" {
  source = "git::https://gitlab.wuintranet.net/terraform-module-registry/aws/s3-bucket?ref=v1.0.0"
  # add your inputs here...
}
```

## Examples

- [AutoScaling with Basic Configuration](examples/auto-scaling-group-with-basic-example/)
- [AutoScaling with Advanced Configuration](examples/auto-scaling-group-with-advanced-example/)
- [AutoScaling with Lifecycle hook](examples/auto-scaling-group-with-lifecycle-hook-example/)
- [AutoScaling with Policy hook](examples/auto-scaling-group-with-policy-example/)
- [AutoScaling with Schedule hook](examples/auto-scaling-group-with-schedule-example/)

## Requirements

| Name      | Version |
| --------- | ------- |
| terraform | 1.2.0   |
| aws       | 4.19.0  |

## Inputs

### Auto Scaling Group

| Name                      | Description                                                                                                                                                                                                                                                                    | Type         | Default     |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------ | ----------- |
| additional_tags           | Mention additional tags if any. Number of additional tags can not exceed a limit of 37.                                                                                                                                                                                        | map          | { }         |
| description               | Provide value for the tag: Description                                                                                                                                                                                                                                         | string       |             |
| function                  | Function/scope of the s3. Same value will be used for tag : Name                                                                                                                                                                                                               | string       |             |
| increment_code            | Increment code to append to the instance name.                                                                                                                                                                                                                                 | string       |             |
| max_size                  | (Required) The maximum size of the Auto Scaling Group.                                                                                                                                                                                                                         | number       |             |
| min_size                  | (Required) The minimum size of the Auto Scaling Group.                                                                                                                                                                                                                         | number       |             |
| availability_zones        | (Optional) A list of one or more availability zones for the group. Used for EC2-Classic, attaching a network interface via id from a launch template and default subnets                                                                                                       | list(string) |             |
| capacity_rebalance        | (Optional) Indicates whether capacity rebalance is enabled. Otherwise, capacity rebalance is disabled.                                                                                                                                                                         | bool         | false       |
| default_cooldown          | (Optional) The amount of time, in seconds, after a scaling activity completes before another scaling activity can start.                                                                                                                                                       | number       |             |
| launch_configuration_name | (Optional) The name of the launch configuration to use.                                                                                                                                                                                                                        | string       |             |
| vpc_zone_identifier       | (Optional) A list of subnet IDs to launch resources in. Subnets automatically determine which availability zones the group will reside. Conflicts with availability_zones.                                                                                                     | list(string) |             |
| default_instance_warmup   | (Optional) The amount of time, in seconds, until a newly launched instance can contribute to the Amazon CloudWatch metrics. This delay lets an instance finish initializing before Amazon EC2 Auto Scaling aggregates instance metrics, resulting in more reliable usage data. | number       |             |
| launch_template           | (Optional) Nested argument with Launch template specification to use to launch instances.                                                                                                                                                                                      | number       |             |
| initial_lifecycle_hook    | (Optional) One or more Lifecycle Hooks to attach to the Auto Scaling Group before instances are launched.                                                                                                                                                                      | number       |             |
| mixed_instances_policy    | (Optional) Configuration block containing settings to define launch targets for Auto Scaling groups.                                                                                                                                                                           | object       |             |
| health_check_grace_period | (Optional, Default: 300) Time (in seconds) after instance comes into service before checking health.                                                                                                                                                                           | number       | 300         |
| health_check_type         | (Optional) "EC2" or "ELB". Controls how health checking is done.                                                                                                                                                                                                               | string       | EC2         |
| desired_capacity          | (Optional) The number of Amazon EC2 instances that should be running in the group.                                                                                                                                                                                             | number       |             |
| force_delete              | (Optional) Allows deleting the Auto Scaling Group without waiting for all instances in the pool to terminate.                                                                                                                                                                  | bool         | false       |
| load_balancers            | (Optional) A list of elastic load balancer names to add to the autoscaling group names.                                                                                                                                                                                        | list(string) | []          |
| target_group_arns         | (Optional) A set of aws_alb_target_group ARNs, for use with Application or Network Load Balancing.                                                                                                                                                                             | list(string) | []          |
| termination_policies      | (Optional) A list of policies to decide how the instances in the Auto Scaling Group should be terminated.The allowed values are OldestInstance, NewestInstance, OldestLaunchConfiguration, ClosestToNextInstanceHour, OldestLaunchTemplate, AllocationStrategy, Default        | list(string) | ["Default"] |
| suspended_processes       | (Optional) A list of processes to suspend for the Auto Scaling Group. The allowed values are Launch, Terminate, HealthCheck, ReplaceUnhealthy, AZRebalance, AlarmNotification, ScheduledActions, AddToLoadBalancer, InstanceRefresh                                            | list(string) | []          |
| placement_group           | (Optional) The name of the placement group into which you'll launch your instances, if any.                                                                                                                                                                                    | string       |             |
| metrics_granularity       | (Optional) The granularity to associate with the metrics to collect. The only valid value is 1Minute                                                                                                                                                                           | string       | 1Minute     |
| enabled_metrics           | (Optional) A list of metrics to collect.                                                                                                                                                                                                                                       | list(string) |             |
| wait_for_capacity_timeout | (Optional) A maximum duration that Terraform should wait for ASG instances to be healthy before timing out.                                                                                                                                                                    | string       | 10m         |
| min_elb_capacity          | (Optional) Setting this causes Terraform to wait for this number of instances from this Auto Scaling Group to show up healthy in the ELB only on creation. Updates will not wait on ELB instance number changes.                                                               | number       |             |
| wait_for_elb_capacity     | (Optional) Setting this will cause Terraform to wait for exactly this number of healthy instances from this Auto Scaling Group in all attached load balancers on both create and update operations.                                                                            | number       |             |
| protect_from_scale_in     | (Optional) Indicates whether newly launched instances are automatically protected from termination by Amazon EC2 Auto Scaling when scaling in. For more information about preventing instances from terminating on scale in,                                                   | bool         |             |
| service_linked_role_arn   | (Optional) The ARN of the service-linked role that the ASG will use to call other AWS services                                                                                                                                                                                 | string       |             |
| max_instance_lifetime     | (Optional) The maximum amount of time, in seconds, that an instance can be in service, values must be either equal to 0 or between 86400 and 31536000 seconds.                                                                                                                 | number       |             |
| instance_refresh          | (Optional) If this block is configured, start an Instance Refresh when this Auto Scaling Group is updated.                                                                                                                                                                     | object       |             |
| warm_pool                 | (Optional) If this block is configured, add a Warm Pool to the specified Auto Scaling group.                                                                                                                                                                                   | object       |             |

### Schedule

| Name                      | Description                                                                                                                                                              | Type   | Default |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------ | ------- |
| schedule_name             | (Required) The name of this scaling action.                                                                                                                              | string |         |
| schedule_start_time       | (Optional) The time for this action to start, in "YYYY-MM-DDThh:mm:ssZ" format in UTC/GMT only (for example, 2014-06-01T00:00:00Z ).                                     | string |         |
| schedule_end_time         | (Optional) The time for this action to end, in "YYYY-MM-DDThh:mm:ssZ" format in UTC/GMT only (for example, 2014-06-01T00:00:00Z )                                        | string |         |
| schedule_recurrence       | (Optional) The time when recurring future actions will start. Start time is specified by the user following the Unix cron syntax format.                                 | string |         |
| schedule_time_zone        | (Optional) The timezone for the cron expression. Valid values are the canonical names of the IANA time zones (such as Etc/GMT+9 or Pacific/Tahiti).                      | string |         |
| schedule_min_size         | (Optional) The minimum size for the Auto Scaling group. Default 0. Set to -1 if you don't want to change the minimum size at the scheduled time.                         | string |         |
| schedule_max_size         | (Optional) The maximum size for the Auto Scaling group. Default 0. Set to -1 if you don't want to change the maximum size at the scheduled time.                         | string |         |
| schedule_desired_capacity | (Optional) The number of EC2 instances that should be running in the group. Default 0. Set to -1 if you don't want to change the desired capacity at the scheduled time. | string |         |

### Lifecycle Hook

| Name                                | Description                                                                                                                                                                                                  | Type   | Default |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------ | ------- |
| policy_hook_name                    | (Required) The name of the lifecycle hook.                                                                                                                                                                   | string |         |
| policy_hook_lifecycle_transition    | (Required) The instance state to which you want to attach the lifecycle hook.                                                                                                                                | string |         |
| policy_hook_default_result          | (Optional) Defines the action the Auto Scaling group should take when the lifecycle hook timeout elapses or if an unexpected failure occurs. The value for this parameter can be either CONTINUE or ABANDON. | string |         |
| policy_hook_heartbeat_timeout       | (Optional) Defines the amount of time, in seconds, that can elapse before the lifecycle hook times out.                                                                                                      | number |         |
| policy_hook_notification_target_arn | (Optional) The ARN of the notification target that Auto Scaling will use to notify you when an instance is in the transition state for the lifecycle hook.                                                   | string |         |
| policy_hook_role_arn                | (Optional) The ARN of the IAM role that allows the Auto Scaling group to publish to the specified notification target.                                                                                       | string |         |
| policy_hook_notification_metadata   | (Optional) Contains additional information that you want to include any time Auto Scaling sends a message to the notification target.                                                                        | string |         |

### Policy

| Name                                    | Description                                                                                                                                                                            | Type         | Default |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | ------- |
| policy_name                             | (Required) The name of the policy.                                                                                                                                                     | string       |         |
| policy_adjustment_type                  | (Optional) Specifies whether the adjustment is an absolute number or a percentage of the current capacity.                                                                             | string       |         |
| policy_type                             | (Optional) The policy type, either "SimpleScaling", "StepScaling", "TargetTrackingScaling", or "PredictiveScaling". If this value isn't provided, AWS will default to "SimpleScaling." | string       |         |
| policy_predictive_scaling_configuration | (Optional) The predictive scaling policy configuration to use with Amazon EC2 Auto Scaling.                                                                                            | object       |         |
| estimated_instance_warmup               | (Optional) The estimated time, in seconds, until a newly launched instance will contribute CloudWatch metrics.                                                                         | string       |         |
| policy_enabled                          | (Optional) Indicates whether the scaling policy is enabled or disabled. Default: true.                                                                                                 | string       |         |
| policy_min_adjustment_magnitude         | (Optional) Minimum value to scale by when adjustment_type is set to PercentChangeInCapacity.                                                                                           | number       |         |
| policy_cooldown                         | (Optional) The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start.                                                          | number       |         |
| policy_scaling_adjustment               | (Optional) The number of instances by which to scale.                                                                                                                                  | number       |         |
| policy_metric_aggregation_type          | (Optional) The aggregation type for the policy's metrics. Valid values are "Minimum", "Maximum", and "Average". Without a value, AWS will treat the aggregation type as "Average".     | string       |         |
| policy_step_adjustment                  | (Optional) A set of adjustments that manage group scaling.                                                                                                                             | list(object) |         |
| policy_target_tracking_configuration    | (Optional) A target tracking policy.                                                                                                                                                   | list(object) |         |

## Outputs

| Name               | Description               |
| ------------------ | ------------------------- |
| arn                | arn of autoscaling group  |
| availability_zones | Availability zones of ASG |
| default_cooldown   | Default cooldown of ASG   |
| desired_capacity   | Desired Capacity of ASG   |
| id                 | Id of the ASG             |
| name               | Name of the ASG           |

## Authors

- Gayathri.KS@wu.com

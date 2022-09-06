output "arn" {
  value = aws_autoscaling_group.main.arn
}

output "availability_zones" {
  value = aws_autoscaling_group.main.availability_zones
}

output "default_cooldown" {
  value = aws_autoscaling_group.main.default_cooldown
}

output "desired_capacity" {
  value = aws_autoscaling_group.main.desired_capacity
}

output "id" {
  value = aws_autoscaling_group.main.id
}

output "name" {
  value = aws_autoscaling_group.main.name
}

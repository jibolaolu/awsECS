resource "aws_appautoscaling_target" "Ecs-Auto-Target" {
  max_capacity       = 6
  min_capacity       = 3
  resource_id        = "service/${aws_ecs_cluster.ECS-Main_Cluster.name}/${aws_ecs_service.web-app-Service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

#Automatic Scalling up one by one
resource "aws_appautoscaling_policy" "Scale-up" {
  name               = "${var.ecs-name}-ScaleUp"
  resource_id        = "service/${aws_ecs_cluster.ECS-Main_Cluster.name}/${aws_ecs_service.web-app-Service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      scaling_adjustment          = 1
      metric_interval_lower_bound = 0
    }
  }
}

#Automatic scaling Down one by one
resource "aws_appautoscaling_policy" "Scale-down" {
  name               = "${var.ecs-name}-ScaleDown"
  resource_id        = "service/${aws_ecs_cluster.ECS-Main_Cluster.name}/${aws_ecs_service.web-app-Service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      scaling_adjustment          = -1
      metric_interval_upper_bound = 0
    }
  }
}


#Cloud-Watch Alarm that trigger on Auto-Scaling up
resource "aws_cloudwatch_metric_alarm" "Service_cpu_high" {
  alarm_name          = "${var.ecs-name}-CPU-Utilization-High"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "${var.ecs-name}-CPU-Utilz"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "85"

  dimensions = {
    ClusterName = aws_ecs_cluster.ECS-Main_Cluster.name
    ServiceName = aws_ecs_service.web-app-Service.name
  }
  tags = {
    Name = "${var.ecs-name}-CPU-High"
  }
  alarm_actions = [aws_appautoscaling_policy.Scale-up.arn]
}

resource "aws_cloudwatch_metric_alarm" "Service_cpu_low" {
  alarm_name          = "${var.ecs-name}-CPU-Utilization-Low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "${var.ecs-name}-CPU-Utilz"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    ClusterName = aws_ecs_cluster.ECS-Main_Cluster.name
    ServiceName = aws_ecs_service.web-app-Service.name
  }
  alarm_actions = [aws_appautoscaling_policy.Scale-down.arn]
}
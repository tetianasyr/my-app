resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/my-petapp"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_stream" "ecs_log_stream" {
  name           = "ecs-log-stream"
  log_group_name = aws_cloudwatch_log_group.ecs_log_group.name
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_high" {
  alarm_name          = "${var.app_name}-${var.environment}-high-cpu-utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "85"

  dimensions = {
    ClusterName = aws_ecs_cluster.ecs_cluster.name
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_sns_topic" "alerts" {
  name = "ecs-alerts"
}

# resource "aws_sns_topic_subscription" "alert_subscription" {
#   topic_arn = aws_sns_topic.alerts.arn
#   protocol  = "email"
#   endpoint  = "tetiana.syrova@example.com" # change to your email
# }
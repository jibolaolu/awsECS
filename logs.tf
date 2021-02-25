#Setting up a cloud watch to stream and retain logs
resource "aws_cloudwatch_log_group" "ECS-app-log-Group" {
  name              = "/ecs/web-app"
  retention_in_days = 14
  tags = {
    Name = "ECS-WebApp-Cloudwatch"
  }
}

resource "aws_cloudwatch_log_stream" "ECS-log-Stream" {
  log_group_name = aws_cloudwatch_log_group.ECS-app-log-Group.name
  name           = var.ecs-log-stream
}
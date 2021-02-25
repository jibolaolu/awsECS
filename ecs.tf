#Creating the ECS
resource "aws_ecs_cluster" "ECS-Main_Cluster" {
  name = "ECS-CLUSTER"
  tags = {
    Name = "ECS-Cluster"
  }
}

#Data template and the variables

data "template_file" "web-app" {
  template = file("./templates/web-app.json.tpl")

  vars = {
    app_image      = var.app_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    region         = var.aws_region
  }
}

resource "aws_ecs_task_definition" "web-app-task-definition" {
  family                   = "web-app-task"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  requires_compatibilities = ["FARGATE"]
  container_definitions    = data.template_file.web-app.rendered

  tags = {
    Name = "ECS-TASK-DEFINITION"
  }
}

resource "aws_ecs_service" "web-app-Service" {
  name            = "web-app-SERVICE"
  task_definition = aws_ecs_task_definition.web-app-task-definition.id
  cluster         = aws_ecs_cluster.ECS-Main_Cluster.id
  desired_count   = "3"
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.ECR-Private-Subnet.*.id
    security_groups  = [aws_security_group.ECS-TASKS-SG.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.ECS-Target_Group.arn
    container_name   = "web-app"
    container_port   = var.app_port
  }

  tags = {
    Name = "ECS-SERVICE"
  }
  depends_on = [aws_alb_listener.ECS-Frontend-Listner, aws_iam_role_policy_attachment.ecs_task_execution_role]
}
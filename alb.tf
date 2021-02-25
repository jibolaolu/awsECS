resource "aws_alb" "ECS-ALB" {
  subnets         = aws_subnet.ECR-Public-Subnet.*.id
  security_groups = [aws_security_group.ECS-ALB.id]
  name            = "ECS-LOAD-Balancer"
  tags = {
    Name = "Ecs-DEMO-ALB"
  }
}

resource "aws_alb_target_group" "ECS-Target_Group" {
  name        = "Web-App-Target-Group"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.ecs_vpc.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
  tags = {
    Name = "ECS-Target-Group"
  }
}

resource "aws_alb_listener" "ECS-Frontend-Listner" {
  load_balancer_arn = aws_alb.ECS-ALB.id
  port              = "3000"

  default_action {
    target_group_arn = aws_alb_target_group.ECS-Target_Group.id
    type             = "forward"
  }
}
#ALB Security Group for Application Load Balancer
resource "aws_security_group" "ECS-ALB" {
  name        = "Web-App-Load-Balancer-SG"
  description = "This controls the access to the ALB"
  vpc_id      = aws_vpc.ecs_vpc.id

  ingress {
    from_port   = var.app_port
    protocol    = "tcp"
    to_port     = var.app_port
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ECS-ALB-SG"
  }
}

#Security Group for ECS Tasks
resource "aws_security_group" "ECS-TASKS-SG" {
  name        = "ECS-Tasks"
  description = "Allows traffice from ALB only"
  vpc_id      = aws_vpc.ecs_vpc.id
  ingress {
    from_port       = var.app_port
    protocol        = "tcp"
    to_port         = var.app_port
    security_groups = [aws_security_group.ECS-ALB.id]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB-TASK-SG"
  }
}
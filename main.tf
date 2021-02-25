resource "aws_vpc" "ecs_vpc" {
  cidr_block           = "10.5.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "ECS-DEMO-VPC"
  }
}

resource "aws_internet_gateway" "ECS-IGW" {
  vpc_id = aws_vpc.ecs_vpc.id

  tags = {
    Name = "ECR-DEMO-IGW"
  }
}

resource "aws_eip" "ECS-DEMO-EIP" {
  count = length(var.az_count)
  vpc   = true
  depends_on = [aws_internet_gateway.ECS-IGW]
  tags = {
    Name = "ECR-DEMO-EIP"
  }
}

resource "aws_nat_gateway" "ECR" {
  count         = length(var.az_count)
  allocation_id = element(aws_eip.ECS-DEMO-EIP.*.id, count.index)
  subnet_id     = element(aws_subnet.ECR-Public-Subnet.*.id, count.index)
}
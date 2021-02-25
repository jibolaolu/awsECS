resource "aws_subnet" "ECR-Public-Subnet" {
  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = element(var.public_subnet_cidr, count.index)
  map_public_ip_on_launch = true
  availability_zone       = element(var.az_count, count.index)

  tags = {
    Name = "ECS-Public-Subnet-${count.index + 1}"
  }
}


resource "aws_subnet" "ECR-Private-Subnet" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = element(var.private_subnet_cidr, count.index)
  availability_zone = element(var.az_count, count.index)

  tags = {
    Name = "ECS-Private-Subnet-${count.index + 1}"
  }
}


#Create Public Route Table
resource "aws_route_table" "ECS-Public-Route-Table" {
  vpc_id = aws_vpc.ecs_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ECS-IGW.id
  }
  tags = {
    Name = "Public-RT"
  }
}

#Create a route table Association
resource "aws_route_table_association" "ECS_RT_Association" {
  count          = length(var.public_subnet_cidr)
  route_table_id = aws_route_table.ECS-Public-Route-Table.id
  subnet_id      = element(aws_subnet.ECR-Public-Subnet.*.id, count.index)
}

#Private Route-Table
resource "aws_route_table" "ECS-Private-RT" {
  count  = length(var.az_count)
  vpc_id = aws_vpc.ecs_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.ECR.*.id, count.index)
  }
}

# Private Route-Table Association
resource "aws_route_table_association" "Private_RT_Association" {
  count          = length(var.az_count)
  route_table_id = element(aws_route_table.ECS-Private-RT.*.id, count.index)
  subnet_id      = element(aws_subnet.ECR-Private-Subnet.*.id, count.index)
}
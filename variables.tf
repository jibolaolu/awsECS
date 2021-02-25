variable "az_count" {
  description = "Total number of AZ to cover in this region"
  type        = list
  default     = ["eu-west-2a", "eu-west-2b"]
}

variable "public_subnet_cidr" {
  description = "List of Public CIDR"
  type        = list
  default     = ["10.5.1.0/24", "10.5.2.0/24"]
}

variable "private_subnet_cidr" {
  description = "List of Private Subnet CIDR"
  type        = list
  default     = ["10.5.3.0/24", "10.5.4.0/24"]
}

variable "app_image" {
  default = "100753669199.dkr.ecr.eu-west-2.amazonaws.com/ecr-demo:v1"

}

variable "app_port" {
  default = "3000"
}

variable "fargate_cpu" {
  default = "1024"
}
variable "fargate_memory" {
  default = "2048"
}

variable "aws_region" {
  default = "eu-west-2"
}

variable "ecs_task_execution_role_name" {
  default = "ECS-Demo-Role"
}

variable "ecs-log-stream" {
  default = "ECS-Log-Stream"
}

variable "ecs-name" {
  default = "ECS-Demo"
}




terraform {
  backend "s3" {
    bucket = "seunadio-tfstate"
    key    = "ECS/FARGATE.tfstate"
    region = "eu-west-2"
  }
}

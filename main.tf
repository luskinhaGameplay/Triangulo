provider "aws" {
  access_key = var.accessKeyId
  secret_key =  var.accessKeySecret
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "ecs_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Subnets públicas
resource "aws_subnet" "ecs_subnet_a" {
  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "ecs_subnet_b" {
  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}

# Internet Gateway
resource "aws_internet_gateway" "ecs_gw" {
  vpc_id = aws_vpc.ecs_vpc.id
}

# Tabela de rotas
resource "aws_route_table" "ecs_rt" {
  vpc_id = aws_vpc.ecs_vpc.id
}

resource "aws_route" "ecs_inet" {
  route_table_id         = aws_route_table.ecs_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ecs_gw.id
}

resource "aws_route_table_association" "ecs_assoc_a" {
  subnet_id      = aws_subnet.ecs_subnet_a.id
  route_table_id = aws_route_table.ecs_rt.id
}

resource "aws_route_table_association" "ecs_assoc_b" {
  subnet_id      = aws_subnet.ecs_subnet_b.id
  route_table_id = aws_route_table.ecs_rt.id
}

# Security Group para liberar a porta 3031
resource "aws_security_group" "ecs_sg" {
  vpc_id = aws_vpc.ecs_vpc.id
  name   = "ecs-triangulo-sg"

  ingress {
    from_port   = 3031
    to_port     = 3031
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Cluster ECS
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs-triangulo-cluster"
}

# Task Definition
resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "td-triangulo"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::814147156818:role/ecsTaskExecutionRole"

  container_definitions = <<DEFINITION
[
  {
    "name": "app-triangulo",
    "image": "luskinhagameplay/app-triangulo:latest",
    "essential": true,
    "cpu": 256,
    "memory": 512,
    "portMappings": [
      {
        "containerPort": 3031,
        "hostPort": 3031,
        "protocol": "tcp"
      }
    ]
  }
]
DEFINITION
}

# Service
resource "aws_ecs_service" "ecs_service" {
  name            = "ecs-triangulo-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.ecs_subnet_a.id, aws_subnet.ecs_subnet_b.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}

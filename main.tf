provider "aws" {
  region = "us-east-1"
}

# ✅ Define Variables for Flexibility
variable "ecs_cluster_name" { default = "myapp-cluster" }
variable "ecs_service_name" { default = "myapp-service" }
variable "ecs_task_family"  { default = "myapp-task" }
variable "cpu" { default = "256" }
variable "memory" { default = "512" }
variable "container_port" { default = "3000" }
variable "image_url" { default = "246651824707.dkr.ecr.us-east-1.amazonaws.com/myapp-repo:latest" }
variable "ecs_task_execution_role_arn" { default = "arn:aws:iam::246651824707:role/ecsTaskExecutionRole" }

# ✅ Store Terraform State in S3
terraform {
  backend "s3" {
    bucket         = "myapp-terraform-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}

# ✅ Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "myapp-vpc" }
}

# ✅ Create Public Subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}

# ✅ Create Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

# ✅ Create Route Table for Public Subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id
  route { cidr_block = "0.0.0.0/0" gateway_id = aws_internet_gateway.my_igw.id }
}

# ✅ Associate Route Table with Public Subnets
resource "aws_route_table_association" "public_subnet_1_assoc" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_2_assoc" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# ✅ Create ECS Cluster
resource "aws_ecs_cluster" "my_cluster" {
  name = var.ecs_cluster_name
}

# ✅ Use Existing IAM Role
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = var.ecs_task_execution_role_arn
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ✅ Define ECS Task Definition
resource "aws_ecs_task_definition" "my_task" {
  family                   = var.ecs_task_family
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  container_definitions    = jsonencode([
    {
      name      = "myapp"
      image     = var.image_url
      cpu       = tonumber(var.cpu)
      memory    = tonumber(var.memory)
      essential = true
      portMappings = [{ containerPort = tonumber(var.container_port) hostPort = tonumber(var.container_port) }]
    }
  ])
}

# ✅ Define Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Allow inbound HTTP traffic"
  vpc_id      = aws_vpc.my_vpc.id
  ingress { from_port = 80 to_port = 80 protocol = "tcp" cidr_blocks = ["YOUR_IP/32"] }
  ingress { from_port = 443 to_port = 443 protocol = "tcp" cidr_blocks = ["YOUR_IP/32"] }
  egress { from_port = 0 to_port = 0 protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }
}

# ✅ Define ALB, Target Group, and Listener
resource "aws_lb" "my_alb" {
  name               = "myapp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

resource "aws_lb_target_group" "my_target_group" {
  name     = "myapp-tg"
  port     = var.container_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
  target_type = "ip"
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action { type = "forward" target_group_arn = aws_lb_target_group.my_target_group.arn }
}

# ✅ Define ECS Service
resource "aws_ecs_service" "my_service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
    security_groups = [aws_security_group.alb_sg.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.my_target_group.arn
    container_name   = "myapp"
    container_port   = var.container_port
  }
}

# ✅ Enable CloudWatch Logs & Alarms
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/myapp"
  retention_in_days = 30
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
}

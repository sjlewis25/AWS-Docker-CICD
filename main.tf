provider "aws" {
  region = "us-east-1"
}

resource "aws_ecs_cluster" "my_cluster" {
  name = "myapp-cluster"
}

resource "aws_ecs_task_definition" "my_task" {
  family                   = "myapp-task"
  requires_compatibilities = ["FARGATE"]
  memory                   = "512"
  cpu                      = "256"
  network_mode             = "awsvpc"


  execution_role_arn = "arn:aws:iam::246651824707:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = "myapp"
      image     = "246651824707.dkr.ecr.us-east-1.amazonaws.com/myapp-repo:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "my_service" {
  name            = "myapp-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets = ["subnet-0a136d0a04055b687", "subnet-093f6d577cbd37f06"]
    security_groups = ["sg-04175018d3aaca9f9"]
    assign_public_ip = true
  }
}

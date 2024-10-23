# ECS Cluster
resource "aws_ecs_cluster" "app_cluster" {
  name = "app-cluster"
}

# Task Definition for Microservice 1 (Flask App)
resource "aws_ecs_task_definition" "microservice1_task" {
  family                   = "microservice1"
  network_mode              = "awsvpc"
  execution_role_arn        = aws_iam_role.ecs_task_execution_role.arn
  requires_compatibilities  = ["FARGATE"]
  cpu                       = "256"
  memory                    = "512"
  container_definitions     = jsonencode([
    {
      name        = "microservice1"
      image       = "your-docker-repo/microservice1:latest"
      essential   = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])

  tags = {
    Name = "microservice1-task"
  }
}

# ECS Service for Microservice 1
resource "aws_ecs_service" "microservice1_service" {
  name            = "microservice1-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.microservice1_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = module.vpc.public_subnets
    security_groups = [aws_security_group.ecs_sg.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "microservice1"
    container_port   = 80
  }

  tags = {
    Name = "microservice1-service"
  }
}

resource "aws_security_group" "ecs_sg" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-sg"
  }
}

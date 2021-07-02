
resource "aws_ecs_task_definition" "task" {
  family                   = var.app_name
  container_definitions    = <<DEFINITION
  [
    {
      "name": "web",
      "image": "${var.image}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ],
      "environment": ${jsonencode(var.env)},
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = var.execution_role_arn
}

# Add ECS Service
resource "aws_ecs_service" "service" {
  name            = var.app_name
  cluster         = var.ecs_cluster
  task_definition = aws_ecs_task_definition.task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "web"
    container_port   = 80
  }

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = true
    security_groups  = [var.security_group]
  }
}

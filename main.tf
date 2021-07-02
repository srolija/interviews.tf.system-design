terraform {
  required_providers {
    aws = {
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

# Apps are defined in terraform.tfvars
module "app" {
  source = "./modules/ecs-app"

  for_each = var.apps

  image    = each.value.image
  app_name = each.key
  env = flatten([
    [
      {
        "name" : "DB_PORT",
        "value" : aws_rds_cluster.db.port
      },
      {
        "name" : "DB_HOST",
        "value" : aws_rds_cluster.db.endpoint
      },
      {
        "name" : "DB_NAME",
        "value" : aws_rds_cluster.db.database_name
      },
      {
        "name" : "DB_USER",
        "value" : aws_rds_cluster.db.master_username
      },
      {
        "name" : "DB_PASSWORD",
        "value" : aws_rds_cluster.db.master_password
      },
    ],
    each.value.env
  ])

  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  ecs_cluster        = aws_ecs_cluster.apps.id

  vpc_id = aws_vpc.main.id
  subnets = [
    "${aws_subnet.subnet_a.id}",
    "${aws_subnet.subnet_b.id}"
  ]

  domain = "${each.key}.inf.srolija.com"

  alb_dns_name     = aws_alb.shared_load_balancer.dns_name
  alb_listener_arn = aws_lb_listener.front_end.arn
  security_group   = aws_security_group.service_security_group.id
}

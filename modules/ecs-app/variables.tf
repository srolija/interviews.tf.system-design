
# App Details
variable "image" {
  type = string
}

variable "app_name" {
  type = string
}

variable "env" {
  type = list(object({
    name : string,
    value : string
  }))
  default = []
}

# ECS
variable "execution_role_arn" {
  type = string
}

variable "ecs_cluster" {
  type = string
}


# VPC
variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}


# DNS
variable "dns_zone_id" {
  type    = string
  default = "Z04419433981P71VCRC75"
}

variable "domain" {
  type = string
}


# ALB
variable "alb_dns_name" {
  type = string
}

variable "alb_listener_arn" {
  type = string
}

variable "security_group" {
  type = string
}

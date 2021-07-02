
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Create Aurora Cluster
resource "aws_rds_cluster" "db" {
  cluster_identifier      = "main-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.10.0"
  availability_zones      = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  database_name           = "mydb"
  master_username         = "my_user"
  master_password         = random_password.db_password.result
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  db_subnet_group_name    = aws_db_subnet_group.aurora_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.db_security_group.id]
}

# Add single instance to Aurora Cluster
resource "aws_rds_cluster_instance" "only_instance" {
  count                = 1
  identifier           = "main-cluster-${count.index}"
  cluster_identifier   = aws_rds_cluster.db.id
  instance_class       = "db.t3.small"
  engine               = aws_rds_cluster.db.engine
  engine_version       = aws_rds_cluster.db.engine_version
  db_subnet_group_name = aws_db_subnet_group.aurora_subnet_group.name
}


resource "aws_db_subnet_group" "aurora_subnet_group" {
  name = "tf-rds-aurora"
  subnet_ids = [
    aws_subnet.subnet_a.id,
    aws_subnet.subnet_b.id,
    aws_subnet.subnet_c.id
  ]
}

# Allows access to Aurora only from ECS
resource "aws_security_group" "db_security_group" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Allow from services security group
    security_groups = ["${aws_security_group.service_security_group.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
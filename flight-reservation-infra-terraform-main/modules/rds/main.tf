############################################
# Get Default VPC
############################################
data "aws_vpc" "default" {
  default = true
}

############################################
# Get Default Subnets
############################################
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

############################################
# DB Subnet Group
############################################
resource "aws_db_subnet_group" "vanraj_db_subnet_group" {
  name       = "vanraj-db-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "VanRaj DB Subnet Group"
  }
}

############################################
# Security Group
############################################
resource "aws_security_group" "vanraj_rds_sg" {
  name        = "vanraj-rds-sg"
  description = "Security Group for VanRaj MySQL RDS"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "MySQL"

    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "VanRaj-RDS-SG"
  }
}

############################################
# RDS MySQL Instance
############################################
resource "aws_db_instance" "vanraj_db" {

  identifier = "vanraj-db"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"

  db_name  = "flightdb"

  username = "admin"
  password = "VanRaj12345"

  parameter_group_name = "default.mysql8.0"

  publicly_accessible = true

  vpc_security_group_ids = [
    aws_security_group.vanraj_rds_sg.id
  ]

  db_subnet_group_name = aws_db_subnet_group.vanraj_db_subnet_group.name

  backup_retention_period = 1

  skip_final_snapshot = true

  deletion_protection = false

  tags = {
    Name = "VanRaj-MySQL-RDS"
    Env  = "dev"
  }
}

############################################
# Outputs
############################################
output "rds_endpoint" {
  value = aws_db_instance.vanraj_db.endpoint
}

output "database_name" {
  value = aws_db_instance.vanraj_db.db_name
}

output "database_port" {
  value = aws_db_instance.vanraj_db.port
}

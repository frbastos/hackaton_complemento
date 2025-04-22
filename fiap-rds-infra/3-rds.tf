resource "aws_db_subnet_group" "processadordb" {
  name       = local.rds_name
  subnet_ids = local.subnets_public

  tags = {
    Name = "${local.env}-${local.rds_name}-processadordb"
  }
}

resource "aws_db_parameter_group" "processadordb" {
  name   = local.rds_name
  family = local.rds_family

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "processadordb" {
  identifier             = local.rds_name
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = local.rds_engine
  engine_version         = local.rds_engine_version
  username               = local.rds_username
  password               = local.rds_password
  db_subnet_group_name   = aws_db_subnet_group.processadordb.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  parameter_group_name   = aws_db_parameter_group.processadordb.name
  publicly_accessible    = true
  skip_final_snapshot    = true
  apply_immediately      = true
}

output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.processadordb.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.processadordb.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.processadordb.username
  sensitive   = true
}



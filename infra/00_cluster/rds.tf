resource "aws_db_subnet_group" "rds-subnet-group" {
  name       = "rds-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "epam-diploma-rds-subnet-group"
  }
}


resource "aws_db_parameter_group" "rds-params" {
  name   = "rds-param-group"
  family = "postgres13"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "rds-instance" {
  identifier             = "pyappdb"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "13.3"
  username               = "app"
  #password               = var.db_password
  password               = "12345678"
  db_subnet_group_name   = aws_db_subnet_group.rds-subnet-group.name
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  parameter_group_name   = aws_db_parameter_group.rds-params.name
  publicly_accessible    = true
  skip_final_snapshot    = true

}



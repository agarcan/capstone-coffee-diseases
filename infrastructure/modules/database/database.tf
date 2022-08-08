resource "aws_db_instance" "coffeeleaves_db" {

  identifier             = var.identifier
  allocated_storage      = var.storage
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  vpc_security_group_ids = ["${aws_security_group.coffee-db-bastion-sg.id}"]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group_coffee.name
  skip_final_snapshot = "true"
  publicly_accessible = "false"

}

resource "aws_db_subnet_group" "db_subnet_group_coffee" {
  name        = "db_subnet_group_coffee"
  subnet_ids  = [var.privsubnet1_id, var.privsubnet2_id]
}


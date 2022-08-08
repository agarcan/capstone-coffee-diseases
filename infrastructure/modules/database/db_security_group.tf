resource "aws_security_group" "coffee-db-bastion-sg"{
  name = "coffee-db-bastion-sg"
  description = "security group rulling the connection between the ec2 and the db"
  vpc_id = var.coffeeleaves_vpc_id
  
  ingress {
    description = "allow access to db"
    from_port         = 3306
    protocol          = "TCP"
    to_port           = 3306
    cidr_blocks       = ["0.0.0.0/0"]
  }

  egress {
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
}
}

resource "aws_security_group" "coffee_vpc_sg" {
  name        = "coffee_vpc_sg"
  description = "security group ruling access to the ec2"
  vpc_id      = aws_vpc.coffeeleaves_vpc.id

  ingress {
    description = "allow ssh"
    from_port        = 22   
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}


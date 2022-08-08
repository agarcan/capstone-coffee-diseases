resource "aws_vpc" "coffeeleaves_vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true
  instance_tenancy = "default"

  tags = {
    Name = "coffeeleaves_vpc"
  }
}

resource "aws_internet_gateway" "coffeeleaves_igw" {
  vpc_id = aws_vpc.coffeeleaves_vpc.id
}



  

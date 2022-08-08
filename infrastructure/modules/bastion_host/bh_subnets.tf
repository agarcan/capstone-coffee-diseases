
resource "aws_subnet" "privsubnet1" {
    vpc_id = aws_vpc.coffeeleaves_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = var.az_bh_a
    map_public_ip_on_launch = false
}

resource "aws_subnet" "pubsubnet" {
    vpc_id = aws_vpc.coffeeleaves_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = var.az_bh_b
}

resource "aws_subnet" "privsubnet2" {
    vpc_id = aws_vpc.coffeeleaves_vpc.id
    cidr_block = "10.0.3.0/24"
    availability_zone = var.az_bh_c
    map_public_ip_on_launch = false
}

resource "aws_route_table" "coffeepubroutetable" {
  vpc_id = aws_vpc.coffeeleaves_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.coffeeleaves_igw.id
  }
}

resource "aws_route_table_association" "coffeelinkpub" {
  subnet_id      = aws_subnet.pubsubnet.id
  route_table_id = aws_route_table.coffeepubroutetable.id
}


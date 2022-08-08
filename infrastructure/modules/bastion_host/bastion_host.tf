resource "aws_instance" "coffee_leaves_bastion_host" {
  ami               = var.ami
  instance_type     = var.instance_type
  availability_zone = var.az_bh_b
  subnet_id         =  aws_subnet.pubsubnet.id
  associate_public_ip_address = true
  root_block_device {
    volume_size           = 30
    delete_on_termination = true
  }
  key_name = var.pem_key_name
  tags = {
    Name = "coffee_leaves_bastion_host"
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.coffee_vpc_sg.id
  network_interface_id = aws_instance.coffee_leaves_bastion_host.primary_network_interface_id
}

resource "tls_private_key" "bh-key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "bh-pair-key" {
  key_name   = var.pem_key_name
  public_key = tls_private_key.bh-key.public_key_openssh
 
  provisioner "local-exec" {    # Generate "terraform-key-pair.pem" in current directory
    command = <<-EOT
      echo '${tls_private_key.bh-key.private_key_pem}' > ./'${var.pem_key_name}'.pem
      chmod 400 ./'${var.pem_key_name}'.pem
    EOT
  }
 
}


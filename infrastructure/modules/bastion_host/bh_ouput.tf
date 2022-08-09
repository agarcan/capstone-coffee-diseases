output "bh_private_id" {
  value = aws_instance.coffee_leaves_bastion_host.private_ip
}

output "bh_public_id" {
  value = aws_instance.coffee_leaves_bastion_host.public_ip
}

output "coffeeleaves_vpc_id" {
  value = aws_vpc.coffeeleaves_vpc.id
}

output "privsubnet1_id"{
  value = aws_subnet.privsubnet1.id
}

output "privsubnet2_id"{
  value = aws_subnet.privsubnet2.id
}

output "pubsubnet_id"{
  value = aws_subnet.pubsubnet.id
}

output "bh_sg_id"{
  value = aws_security_group.coffee_vpc_sg.id
}

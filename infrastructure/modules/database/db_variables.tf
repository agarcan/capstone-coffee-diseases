
variable "region" {
     description = "Region of AWS VPC"
}
variable "identifier" {
  default     = "coffeeleavesdb"
}

variable "storage" {
  default     = "10"
  description = "Storage size in GB"
}

variable "engine" {
  default     = "mysql"
}

variable "engine_version" {
  default = "5.7.21"
}

variable "instance_class" {
  default     = "db.t2.micro"
  description = "Instance class"
}

variable "db_name" {
  type        = "string"
  default     = "db_coffeeleaves"
}

variable "username" {
  type        = "string"   
  default     = "add_username_here"
}

variable "password" {
  description = "password, provide through your ENV variables"
  type    = "string"
  default = "add_password_here"
}

variable "coffeeleaves_vpc_id" {}

variable "privsubnet1_id" {}

variable "privsubnet2_id" {}
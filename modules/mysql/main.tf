variable "db_name" {}
variable "admin_username" {}
variable "admin_password" {}

resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro" # Free-tier eligible
  db_name              = var.db_name
  username             = var.admin_username
  password             = var.admin_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}
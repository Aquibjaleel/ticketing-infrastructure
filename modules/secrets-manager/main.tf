variable "secret_name" {}

resource "aws_secretsmanager_secret" "app_secret" {
  name = var.secret_name
}
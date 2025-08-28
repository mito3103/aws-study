variable "prefix" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "rds_sg" {
  type = string
}

variable "dbsubnetgroup" {
  type = string
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "データベースのパスワード"
}

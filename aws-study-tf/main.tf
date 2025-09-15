module "vpc" {
  source = "./modules/vpc"
  prefix = var.prefix
}

module "ec2" {
  source            = "./modules/ec2"
  public_subnet_ids = module.vpc.public_subnet_ids
  ec2_sg            = module.sg.ec2_sg.id
  prefix            = var.prefix
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
  prefix = var.prefix
}

module "rds" {
  source            = "./modules/rds"
  private_subnet_id = module.vpc.private_subnet_id
  rds_sg            = module.sg.rds_sg.id
  dbsubnetgroup     = module.vpc.dbsubnetgroup
  db_password       = var.db_password
  prefix            = var.prefix
}

module "alb" {
  source            = "./modules/alb"
  public_subnet_ids = module.vpc.public_subnet_ids
  prefix            = var.prefix
  alb_sg            = module.sg.alb_sg.id
  vpc_id            = module.vpc.vpc_id
  ec2_id            = module.ec2.ec2_id
}

module "cw" {
  source    = "./modules/cw"
  prefix    = var.prefix
  ec2_id    = module.ec2.ec2_id
  sns_topic = module.sns.sns_topic
}

module "sns" {
  source = "./modules/sns"
  prefix = var.prefix
  email  = var.email
}

module "waf" {
  source = "./modules/waf"
  prefix = var.prefix
  alb    = module.alb.alb
}

variable "prefix" {
  type = string
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "データベースのパスワード"
}

variable "email" {
  type        = string
  description = "SNS通知先です"
}

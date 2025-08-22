
module "vpc" {
  source = "./modules/vpc"

  prefix = var.prefix
}

module "ec2" {
  source           = "./modules/ec2"
  public_subnet_id = module.vpc.public_subnet_id
  awsstudytfec2sg  = module.sg.awsstudytfec2sg.id
  prefix           = var.prefix
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

variable "prefix" {
  type = string
}

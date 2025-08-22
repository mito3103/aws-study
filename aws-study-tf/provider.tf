
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #version = "5.80.0" プラグインのバージョン指定
    }
  }

  required_version = ">= 1.2" #Terraform本体のバージョン指定
}

provider "aws" {
  region = "ap-northeast-1"
}




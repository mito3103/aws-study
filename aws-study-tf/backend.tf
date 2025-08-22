terraform {
  backend "s3" {
    bucket = "aws-study-tf-605066737242"
    region = "ap-northeast-1"
    key    = "aws-study-tf/terraform.tfstate"
  }
}

resource "aws_instance" "this" {
  ami           = "ami-0f95ad36d6d54ceba"
  instance_type = "t2.micro"
  #disable_api_termination = true
  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.ec2_sg]
  key_name               = "aws-study-tf-key" #今回は既存のキーペアを使用

  tags = {
    Name = "${var.prefix}-ec2"
  }
}



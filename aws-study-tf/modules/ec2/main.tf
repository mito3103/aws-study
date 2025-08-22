
resource "aws_instance" "awsstudytfec2" {
  ami           = "ami-0f95ad36d6d54ceba"
  instance_type = "t2.micro"
  #disable_api_termination = true
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.awsstudytfec2sg]
  key_name               = "aws-study-tf-key" #今回は既存のキーペアを使用

  tags = {
    Name = "${var.prefix}-ec2"
  }
}



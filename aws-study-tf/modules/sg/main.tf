
# EC2グループ
resource "aws_security_group" "awsstudytfec2sg" {
  description = "Security group for public EC2 instances"
  vpc_id      = var.vpc_id

  tags = {
    Name = "sandbox-terraform-public"
  }
}

resource "aws_security_group_rule" "public_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = aws_security_group.awsstudytfec2sg.id
  #source_security_group_id = [albのSGを作成後入力]
  cidr_blocks = ["0.0.0.0/0"] #自分のIPに変更する
  description = "Allow HTTP My Adress"
}

# SSH (22) を許可
resource "aws_security_group_rule" "public_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.awsstudytfec2sg.id
  cidr_blocks       = ["0.0.0.0/0"] #自分のIPに変更する
  description       = "Allow SSH My Adress"
}


# RDSセキュリティグループ
# resource "aws_security_group" "awsstudytfrdssg" {
#   description = "Security group for RDS"
#   vpc_id      = var.vpc_id

#   tags = {
#     Name = "sandbox-terraform-private" #名前変更すべし
#   }
# }

# resource "aws_security_group_rule" "private_private_sg" {
#   type                     = "ingress"
#   from_port                = 0
#   to_port                  = 0
#   protocol                 = "-1"
#   security_group_id        = aws_security_group.private.id
#   source_security_group_id = aws_security_group.private.id
#   description              = "Allow all traffic from private security group"
# }

# # パブリックSGからの全トラフィックを許可
# resource "aws_security_group_rule" "private_public_sg" {
#   type                     = "ingress"
#   from_port                = 0
#   to_port                  = 0
#   protocol                 = "-1"
#   security_group_id        = aws_security_group.private.id
#   source_security_group_id = aws_security_group.public.id
#   description              = "Allow all traffic from public security group"
# }


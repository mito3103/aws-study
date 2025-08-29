# EC2セキュリティグループ
resource "aws_security_group" "ec2_sg" {
  description = "Security group for public EC2 instances"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.prefix}-ec2-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public" {
  description                  = "Allow from alb to ec2 "
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.alb_sg.id
  security_group_id            = aws_security_group.ec2_sg.id
}

resource "aws_vpc_security_group_ingress_rule" "public_ssh" {
  description       = "Allow SSH My Adress"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "111.189.136.62/32"
}

resource "aws_vpc_security_group_egress_rule" "public_outbound" {
  description       = "Allow All Outbound"
  ip_protocol       = -1
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
}


#RDSセキュリティグループ
resource "aws_security_group" "rds_sg" {
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.prefix}-rds-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2_rds_sg" {
  description                  = "Allow DB Access from EC2"
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  security_group_id            = aws_security_group.rds_sg.id
  referenced_security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_vpc_security_group_egress_rule" "rds_ec2_sg" {
  description       = "Allow all outbound"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.rds_sg.id
}

#ALBセキュリティグループ
resource "aws_security_group" "alb_sg" {
  description = "Security group for ALB"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.prefix}-alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_alb" {
  description       = "Allow HTTP My Adress"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "111.189.136.62/32"
}

resource "aws_vpc_security_group_egress_rule" "alb_public" {
  description       = "Allow all outbound"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.alb_sg.id
}

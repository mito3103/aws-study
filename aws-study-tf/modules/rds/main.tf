resource "aws_db_instance" "this" {
  allocated_storage               = 20
  storage_type                    = "gp2"
  engine                          = "mysql"
  engine_version                  = "8.0.39"
  instance_class                  = "db.t4g.micro"
  identifier                      = "${var.prefix}-rds"
  db_name                         = "awsstudy"
  allow_major_version_upgrade     = false
  multi_az                        = false
  username                        = "root"
  password                        = var.db_password # 環境変数で取り扱う
  parameter_group_name            = "default.mysql8.0"
  skip_final_snapshot             = true
  publicly_accessible             = false
  storage_encrypted               = true
  vpc_security_group_ids          = [var.rds_sg]
  db_subnet_group_name            = var.dbsubnetgroup
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery", "iam-db-auth-error"]
  license_model                   = "general-public-license"
  monitoring_interval             = "60"
  monitoring_role_arn             = aws_iam_role.monitoring.arn

  tags = {
    Name = "${var.prefix}-rds"
  }
}

# 拡張モニタリング用IAMロール
resource "aws_iam_role" "monitoring" {
  name = "rds-monitoring-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_policy" {
  role       = aws_iam_role.monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

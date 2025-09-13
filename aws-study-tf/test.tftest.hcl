variables {
  db_password = "dummy_pass"
  email       = "example@domain.invalid"
}

#VPCテスト
run "vpc" {
  command = plan

  module {
    source = "./modules/vpc"
  }
}

run "check_vpc_cidr" {
  command = plan

  assert {
    condition     = run.vpc.vpc_cidr_block == "10.0.0.0/16"
    error_message = "VPC CIDR block is not the expected value of 10.0.0.0/16"
  }
}

run "check_pub_subnet_cidr" {
  command = plan

  assert {
    condition = alltrue([
      contains(run.vpc.pub_subnet_cidr_blocks, "10.0.0.0/24"),
      contains(run.vpc.pub_subnet_cidr_blocks, "10.0.1.0/24")
    ])
    error_message = "Expected CIDR blocks 10.0.0.0/24 and 10.0.1.0/24 were not found in the plan."
  }
}

run "check_enable_dns_support" {
  command = plan

  assert {
    condition     = run.vpc.enable_dns_support == true
    error_message = "enable_dns_support is not the expected value of true"
  }
}

run "check_pub_subnet_count" {
  command = plan

  assert {
    condition = length(run.vpc.public_subnet_ids) == 2

    error_message = "サブネットの数が異なっています"
  }
}


#SGテスト
run "sg" {
  command = plan

  module {
    source = "./modules/sg"
  }

  variables {
    vpc_id = 12345 #run.vpc.vpc_id
  }
}

run "check_ec2_sg" {
  command = plan

  assert {
    condition = alltrue([
      anytrue([
        for rule in run.sg.ec2_sg_rules :
        rule.from_port == 8080 && rule.to_port == 8080
      ]),
      anytrue([
        for rule in run.sg.ec2_sg_rules :
        rule.from_port == 22 && rule.to_port == 22
      ])
    ])

    error_message = "8080ポートまたは22ポートが正しく公開されていません"
  }
}

#EC2テスト
run "ec2" {
  command = plan

  variables {
    ec2_sg            = 12345          #run.sg.ec2_sg.id
    public_subnet_ids = [12345, 67890] #run.vpc.public_subnet_ids
  }

  module {
    source = "./modules/ec2"
  }
}

run "check_instance_type" {
  command = plan

  assert {
    condition = run.ec2.instance_type == "t2.micro"

    error_message = "インスタンスタイプが異なっています。"
  }
}

#RDSテスト
run "rds" {
  command = plan

  variables {
    rds_sg            = 12345 #run.sg.rds_sg.id
    dbsubnetgroup     = 12345 #run.vpc.dbsubnetgroup
    private_subnet_id = 12345 #run.vpc.private_subnet_id
  }

  module {
    source = "./modules/rds"
  }
}

run "check_instance_class" {
  command = plan

  assert {
    condition     = run.rds.instance_class == "db.t4g.micro"
    error_message = "インスタンスクラスが誤っています"
  }
}

run "check_db_name" {
  command = plan

  assert {
    condition     = run.rds.db_name == "awsstudy"
    error_message = "データベース名が間違っています"
  }
}

run "check_publicly_accessible" {
  command = plan

  assert {
    condition     = run.rds.publicly_accessible == false
    error_message = "rdsがパブリックからアクセス可能になっています。注意してください。"
  }
}

#ALBテスト
run "alb" {
  command = plan

  module {
    source = "./modules/alb"
  }

  variables {
    alb_sg            = 12345          #run.sg.alb_sg
    vpc_id            = 12345          #run.vpc.vpc_id
    ec2_id            = 12345          #run.ec2.ec2_id
    public_subnet_ids = [12345, 67890] #run.vpc.public_subnet_ids
  }
}

run "check_load_balancer_type" {
  command = plan

  assert {
    condition = run.alb.load_balancer_type == "application"

    error_message = "ロードバランサ―タイプが誤っています"
  }
}

run "alb_target_port" {
  command = plan

  assert {
    condition = run.alb.alb_target_port == 8080

    error_message = "ターゲットポートが誤っています"
  }
}

run "alb_listener_port" {
  command = plan

  assert {
    condition = run.alb.alb_listener_port == 80

    error_message = "リスナーポートが誤っています"
  }
}

run "alb_listener_action" {
  command = plan

  assert {
    condition = run.alb.alb_listener_type == "forward"

    error_message = "リスナーのデフォルトアクションが異なっています。"
  }
}

#SNSテスト
run "sns" {
  command = plan

  module {
    source = "./modules/sns"
  }
}

run "sns_protocol" {
  command = plan

  assert {
    condition = run.sns.sns_protocol == "email"

    error_message = "SNSの通知先が誤っています。"
  }
}

#CWテスト
run "cw" {
  command = plan

  variables {
    ec2_id    = 12345                                                #run.ec2.ec2_id
    sns_topic = "arn:aws:sns:ap-northeast-1:123456789012:dummytopic" #run.sns_protocol.sns_topic
  }

  module {
    source = "./modules/cw"
  }
}

run "comparison_operator" {
  command = plan

  assert {
    condition = run.cw.comparison_operator == "GreaterThanThreshold"

    error_message = "比較演算子が誤っています"
  }
}

run "check_cw_statistic" {
  command = plan

  assert {
    condition = run.cw.statistic == "Average"

    error_message = "統計方法が誤っています"
  }
}

#WAFテスト
run "waf" {
  command = plan

  variables {
    alb = "arn:aws:sns:ap-northeast-1:123456789012:dummy-arn" #run.alb.alb.arn
  }

  module {
    source = "./modules/waf"
  }
}

run "check_scope" {
  command = plan

  assert {
    condition = run.waf.scope == "REGIONAL"

    error_message = "スコープが異なっています"
  }
}

run "check_metrics_enabled" {
  command = plan

  assert {
    condition = run.waf.cw_metrics_enabled == true

    error_message = "CloudWatchへのメトリクス設定が誤っています"
  }
}

run "check_rule_visibility_config" {
  command = plan

  assert {
    condition = alltrue(
      run.waf.rule_metrics_enabled
    )
    error_message = "すべてのWAFルールで visibility_config.cloudwatch_metrics_enabled が true ではありません"
  }
}


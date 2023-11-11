resource "aws_s3_bucket" "bucket" { 
  bucket = var.bucket_name 
  tags = { 
    Name = var.bucket_name 
  } 
} 

resource "aws_s3_bucket_acl" "acl_bucket" { 
  bucket = aws_s3_bucket.bucket.id 
  acl    = var.acl 
} 

resource "aws_s3_bucket_versioning" "versioning_bucket" { 
  bucket = aws_s3_bucket.bucket.id 
  versioning_configuration { 
    status = var.versioning 
  } 
} 

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_bucket" { 
  bucket = aws_s3_bucket.bucket.id 
  rule { 
    apply_server_side_encryption_by_default { 
      sse_algorithm = var.encryption 
    } 
  } 
} 

resource "aws_s3_bucket" "bucket2" { 
  bucket = var.bucket2_name 
  tags = { 
    Name = var.bucket2_name 
  } 
} 

resource "aws_s3_bucket_acl" "acl_bucket2" { 
  bucket = aws_s3_bucket.bucket2.id 
  acl    = var.acl 
} 

resource "aws_s3_bucket_versioning" "versioning_bucket2" { 
  bucket = aws_s3_bucket.bucket2.id 
  versioning_configuration { 
    status = var.versioning 
  } 
} 

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_bucket2" { 
  bucket = aws_s3_bucket.bucket2.id 
  rule { 
    apply_server_side_encryption_by_default { 
      sse_algorithm = var.encryption 
    } 
  } 
} 

resource "aws_s3_bucket" "bucket3" { 
  bucket = var.bucket3_name 
  tags = { 
    Name = var.bucket3_name 
  } 
} 

resource "aws_s3_bucket_acl" "acl_bucket3" { 
  bucket = aws_s3_bucket.bucket3.id 
  acl    = var.acl 
} 

resource "aws_s3_bucket_versioning" "versioning_bucket3" { 
  bucket = aws_s3_bucket.bucket3.id 
  versioning_configuration { 
    status = var.versioning 
  } 
} 

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_bucket3" { 
  bucket = aws_s3_bucket.bucket3.id 
  rule { 
    apply_server_side_encryption_by_default { 
      sse_algorithm = var.encryption 
    } 
  } 
} 

resource "aws_instance" "ec2" { 
  ami           = var.ami 
  instance_type = var.instance_id 
  subnet_id     = var.subnet 
  user_data     = <<-EOF 
                    #!/bin/bash 
                    sudo apt-get update 
                    sudo apt-get install -y clamav 
                    sudo freshclam 
                  EOF 
  tags = { 
    Name = var.ec2_name 
  } 
} 

resource "aws_instance" "ec2_2" { 
  ami           = var.ami 
  instance_type = var.instance_id 
  subnet_id     = var.subnet 
  user_data     = <<-EOF 
                    #!/bin/bash 
                    sudo apt-get update 
                    sudo apt-get install -y clamav 
                    sudo freshclam 
                  EOF 
  tags = { 
    Name = var.ec2_2_name 
  } 
} 

resource "aws_ecs_cluster" "ecs" { 
  name = var.ecs_name 
  setting { 
    name  = "containerInsights" 
    value = var.container 
  } 
} 

resource "aws_launch_template" "launchtemplate" { 
  name_prefix   = var.launchtemplate 
  image_id      = var.ami 
  instance_type = var.instance_id 
  user_data = base64encode(<<EOF 
#!/bin/bash 
echo ECS_CLUSTER=${aws_ecs_cluster.ecs.name} >> /etc/ecs/ecs.config 
EOF 
  ) 
} 

resource "aws_autoscaling_group" "asg" { 
  name_prefix = var.asg 
  min_size              = 1 
  max_size              = 3 
  vpc_zone_identifier   = [var.subnet] 
  protect_from_scale_in = true 
  launch_template { 
    id      = aws_launch_template.launchtemplate.id 
    version = "$Latest" 
  } 
} 

resource "aws_ecs_capacity_provider" "eccp" { 
  name = var.eccp 
  auto_scaling_group_provider { 
    auto_scaling_group_arn = aws_autoscaling_group.asg.arn 
    managed_termination_protection = "ENABLED" 
    managed_scaling { 
      status                    = "ENABLED" 
      target_capacity           = 2 
      minimum_scaling_step_size = 1 
      maximum_scaling_step_size = 2 
    } 
  } 
} 

resource "aws_ecs_service" "service" { 
  name            = var.service_name 
  cluster         = aws_ecs_cluster.ecs.id 
  task_definition = aws_ecs_task_definition.tdn.arn 
  desired_count   = 1 
  ordered_placement_strategy { 
    type  = "binpack" 
    field = "cpu" 
  } 
} 

resource "aws_ecs_task_definition" "tdn" { 
  family                = var.family_ecs 
  container_definitions = <<TASK_DEFINITION 
  [ 
        { 
            "essential": true, 
            "name": "tomcat-webserver", 
            "image": "tomcat", 
            "memory": 2048, 
            "cpu": 1024, 
            "portMappings": [ 
                { 
                    "hostPort": 80, 
                    "containerPort": 8080, 
                    "protocol": "tcp" 
                } 
            ], 
            "logConfiguration": { 
                "logDriver": "awslogs", 
                "options": { 
                    "awslogs-group": "/ecs/tomcat-container-logs", 
                    "awslogs-region": "eu-west-2" 
                } 
            } 
        } 
    ] 
       TASK_DEFINITION 
} 

# Declaring the data sources 
data "aws_availability_zones" "available" { 
  state = "available" 
} 

resource "aws_db_instance" "mssql" { 
  count = 2 
  identifier        = "mssql-${count.index}" 
  #db_name           = var.db 
  engine            = var.engine 
  engine_version    = var.dbversion 
  instance_class    = var.instance_class 
  allocated_storage = var.storage 
  multi_az          = true 
  storage_type      = var.storage_type 
  license_model             = "license-included" 
  auto_minor_version_upgrade = true 
  parameter_group_name = aws_db_parameter_group.db_pg.name 
  db_subnet_group_name = aws_db_subnet_group.db_sg.name 
  username = var.user 
  password = var.pwd 
  port     = 1433 
   
  backup_retention_period = 7 
  skip_final_snapshot     = true 
   
  tags = { 
    Name = "mssql" 
  } 
} 

resource "aws_db_parameter_group" "db_pg" { 
  name   = "db-pg" 
  family = "sqlserver-se-15.0" 
 # parameter { 
    # name  = "blocked_process_threshold" 
    # value = "60" 
#  } 
} 

resource "aws_db_subnet_group" "db_sg" { 
  name       = "db-sg" 
  subnet_ids = [var.subnet, var.subnet2] 
  tags = { 
    Name = "db subnet group" 
  } 
} 

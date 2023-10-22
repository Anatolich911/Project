# Creates VPC
module "vpc" {
  source                  = "terraform-aws-modules/vpc/aws"
  name                    = "app"
  cidr                    = "10.0.0.0/16"
  azs                     = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets         = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets          = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  enable_nat_gateway      = true
  enable_vpn_gateway      = false
  single_nat_gateway      = false
  map_public_ip_on_launch = true
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# Creates Sec Group
resource "aws_security_group" "aws-to-gcp" {
  name        = "aws-to-gcp"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

# Creates ASG 
module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name                      = "aws-to-gcp"
  security_groups           = [aws_security_group.aws-to-gcp.id]
  min_size                  = 2
  max_size                  = 10
  desired_capacity          = 2
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = module.vpc.public_subnets

  # Launch template
  launch_template_name        = "aws-to-gcp"
  launch_template_description = "Launch template example"
  update_default_version      = true

  image_id          = data.aws_ami.aws.id
  instance_type     = "t3.micro"
  ebs_optimized     = true
  enable_monitoring = true
  user_data = base64encode(<<-EOF
#!/bin/bash 
sudo yum install php php-mysqlnd httpd wget unzip -y
sudo wget  https://wordpress.org/latest.zip -P /var/www/html/
sudo unzip /var/www/html/latest.zip -d /var/www/html/
sudo mv /var/www/html/wordpress/* /var/www/html/
sudo chown -R apache:apache /var/www/html/
sudo setenforce 0 
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sudo sed -i "s/'DB_NAME', 'database_name_here'/'DB_NAME', 'wordpress'/g" /var/www/html/wp-config.php
sudo sed -i "s/'DB_USER', 'username_here'/'DB_USER', 'wordpress'/g" /var/www/html/wp-config.php
sudo sed -i "s/'DB_PASSWORD', 'password_here'/'DB_PASSWORD', 'wordpress'/g" /var/www/html/wp-config.php
sudo sed -i "s/'DB_HOST', 'localhost'/'DB_HOST', '${aws_route53_record.db.fqdn}'/g" /var/www/html/wp-config.php
rm -rf /var/www/html/latest.zip
sudo systemctl restart httpd 
sudo systemctl status httpd 
  EOF
  )
  # IAM role & instance profile
  create_iam_instance_profile = false
  target_group_arns           = module.alb.target_group_arns

}












# create db subnet group
resource "aws_db_subnet_group" "aws-to-gcp" {
  name       = "aws-to-gcp"
  subnet_ids = module.vpc.public_subnets
}

# Creates DB instance
resource "aws_db_instance" "default" {
  allocated_storage      = 10
  db_name                = "wordpress"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  username               = "wordpress"
  password               = "wordpress"
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.aws-to-gcp.name
  vpc_security_group_ids = [aws_security_group.aws-to-gcp.id]
  publicly_accessible    = true
}

# Creates ALB
module "alb" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "~> 8.0"
  name               = "aslb"
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups = [
    aws_security_group.aws-to-gcp.id
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]


  target_groups = [
    {
      name             = var.project_name
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]
}

# Creates domain record for the app
resource "aws_route53_record" "wordpress" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "wordpress.${data.aws_route53_zone.selected.name}"
  type    = "CNAME"
  ttl     = "300"
  records = [
    module.alb.lb_dns_name
  ]
}

# Creates domain record for db
resource "aws_route53_record" "db" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "db.${data.aws_route53_zone.selected.name}"
  type    = "CNAME"
  ttl     = "300"
  records = [
    google_sql_database_instance.main.public_ip_address
  ]
}

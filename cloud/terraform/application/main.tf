resource "aws_instance" "web" {
  ami             = var.instance_ami
  instance_type   = var.instance_type
  count           = var.instance_count
  key_name        = var.instance_key_name

  security_groups = [
    aws_security_group.app_security_group.name
  ]

  tags            = {
    Name  = "${var.stage}_application"
    Owner = "technical-test-tp"
    Stage = var.stage
  }
}

resource "aws_security_group" "app_security_group" {
  name        = "${var.stage}-technical-test-tp-app-security-group"
  description = "Allow connection on port 22 and 8080 for webapp"

  ingress {
    description = "SSH access port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP web app"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_cluster" "application_cluster" {
  cluster_id           = "${var.stage}-technical-test-tp-cluster"
  engine               = "redis"
  node_type            = var.cluster_instance_type
  num_cache_nodes      = var.cluster_num_cache
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
  security_group_ids   = [
    aws_security_group.cluster_security_group.id
  ]
}

resource "aws_security_group" "cluster_security_group" {
  name        = "${var.stage}-technical-test-tp-cluster-security-group"
  description = "Allow connection on port 6379 for Elasticache cluster"

  ingress {
    description = "Cluster port"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    security_groups = [
      aws_security_group.app_security_group.id
    ]
  }
}

resource "aws_elb" "application_elb" {
  name               = "${var.stage}-technical-test-tp-elb"
  availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/api/healthcheck"
    interval            = 30
  }

  instances                   = aws_instance.web.*.id
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "${var.stage}-technical-test-tp-elb"
  }
}
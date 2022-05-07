terraform {
  required_version = ">=1.0"
  backend "local" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.region

}

# ==========: BUCKET (LAKE) :==========
resource "aws_s3_bucket" "bucket" {
  bucket = "songstreams"
}

# ==========: NETWORK PREFERENCES :==========
resource "aws_vpc" "songstreams_vpc" {
  cidr_block = "192.168.0.0/16"
  tags = {
    "name" = "songstreams"
  }
}
resource "aws_subnet" "songstreams_subnet" {
  vpc_id     = aws_vpc.songstreams_vpc.id
  cidr_block = "192.168.10.0/24"
  tags = {
    "name" = "songstreams"
  }
}

resource "aws_network_interface" "songstreams_network" {
  subnet_id = aws_subnet.songstreams_subnet.id

}

resource "aws_security_group" "songstreams_security_group" {
  name   = "songstreams"
  vpc_id = aws_vpc.songstreams_vpc.id
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["102.89.0.0/16"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# ==========: KAFKA :==========
resource "aws_instance" "kafka_instance" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  network_interface {
    network_interface_id = aws_network_interface.songstreams_network.id
    device_index         = 0
  }

  tags = {
    "name" = "kafka_instance"
  }
}

# ==========: SPARK CLUSTER :==========
resource "aws_emr_cluster" "name" {
  name          = "songstreams_spark"
  release_label = "emr-5.35.0"
  applications  = ["Spark"]
  ec2_attributes {
    subnet_id                         = aws_subnet.songstreams_subnet.id
    emr_managed_master_security_group = aws_security_group.songstreams_security_group.id
    emr_managed_slave_security_group  = aws_security_group.songstreams_security_group.id
    instance_profile                  = var.arn
  }
  master_instance_group {
    instance_type  = "m4.large"
    instance_count = 1
    ebs_config {
      size                 = "32"
      type                 = "gp2"
      volumes_per_instance = 1
    }
  }
  core_instance_group {
    instance_type  = "m4.large"
    instance_count = 2

    ebs_config {
      size                 = "32"
      type                 = "gp2"
      volumes_per_instance = 1
    }
  }
  service_role = var.service_role
  auto_termination_policy {
    idle_timeout = 3600
  }
}

# ==========: REDSHIFT :==========
resource "aws_redshift_cluster" "songstreams_redshift_staging" {
  cluster_identifier     = "songstreams-staging"
  database_name          = var.db_staging
  master_username        = var.dbUsername
  master_password        = var.dbPassword
  node_type              = "dc2.large"
  vpc_security_group_ids = [aws_security_group.songstreams_security_group.id]
  cluster_type           = "single-node"
  port                   = var.dbPort

}
resource "aws_redshift_cluster" "songstreams_redshift_prod" {
  cluster_identifier     = "songstreams-prod"
  database_name          = var.db_prod
  master_username        = var.dbUsername
  master_password        = var.dbPassword
  node_type              = "dc2.large"
  vpc_security_group_ids = [aws_security_group.songstreams_security_group.id]
  cluster_type           = "single-node"
  port                   = var.dbPort

}

# ==========: AIRFLOW :==========
resource "aws_mwaa_environment" "airflow" {
  dag_s3_path        = var.dagsPath
  execution_role_arn = var.service_role
  name               = "songstreams"
  network_configuration {
    security_groups_ids = [aws_security_group.songstreams_security_group.id]
    subnet_ids          = aws_subnet.songstreams_subnet.id
  }
  source_bucket_arn = aws_s3_bucket.bucket.arn
}

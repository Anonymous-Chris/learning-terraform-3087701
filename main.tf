data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

//step 1
data "aws_vpc" "default"{
  default = true
}

resource "aws_instance" "blog" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type
  
  //step 6
  vpc_security_group_ids = [aws_security_group.blog.id]

  tags = {
    Name = "Learning Terraform"
  }
}

//step 2
resource "aws_security_group" "blog"{
  name        = "blog"
  description = "allow http and https in. allow everything out"

  vpc_id      = data.aws_vpc.default.id
}

//step 3
resource "aws_security_group_rule" "blog_http_in"{
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]

  security_group_id = aws_security_group.blog.id 
}

//step 4
resource "aws_security_group_rule" "blog_https_in"{
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]

  security_group_id = aws_security_group.blog.id 
}

//step 5
resource "aws_security_group_rule" "blog_everything_out"{
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]

  security_group_id = aws_security_group.blog.id 
}
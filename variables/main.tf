resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = var.instance_tenancy
  enable_dns_hostnames = var.dns_hostnames
  enable_dns_support = var.dns_support

  tags = var.tags
}

# security group for postgress  RDS, 5432
resource "aws_security_group" "allow_postgress" {
  name        = "allow_postgress"
  description = "Allow postgress inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = var.postgress_port
    to_port          = var.postgress_port
    protocol         = "tcp"
    cidr_blocks      = var.cidr_list
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.tags
}

# This will create under default vpc
# AMI ID bare different for different regions 
  resource "aws_instance" "server" {
  count = 3 # create four similar EC2 instances
  ami           = "ami-00b8917ae86a424c9"
  instance_type = "t2.micro"
  tags = {
    Name = var.instance_names[count.index]
  }
}


/* resource "aws_key_pair" "terraform" {
  key_name   = "terraform"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
} */

resource "aws_instance" "condition" {
    ami = "ami-00b8917ae86a424c9"
    instance_type = var.env == "PROD" ? "t2.micro" : "t2.micro"
}

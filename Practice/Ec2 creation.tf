provider "aws" {
    region = "us-east-1"  # Set your desired AWS region
}

resource "aws_instance" "example" {
    ami           = "ami-00b8917ae86a424c9"  # Specify an appropriate AMI ID
    instance_type = "t2.micro"
    key_name = "DEVAWS"

    tags = {
        Name = "Web-server"
    }
}
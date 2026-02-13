provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-0360c520857e3138f"
  instance_type = var.instance_type
  key_name      = "Rajesh(Virginia)"
  tags = {
    Name        = "${var.env}-My_instance"
    Environment = var.env
  }
}
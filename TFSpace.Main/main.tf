

resource "aws_vpc" "Production" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Production VPC"
  }
}
resource "aws_subnet" "mainsub" {
  vpc_id            = aws_vpc.Production.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"


  tags = {
    Name = "Main-Sub"
  }
}

resource "aws_subnet" "devsub" {
  vpc_id            = aws_vpc.Production.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"


  tags = {
    Name = "Dev-Sub"

  }
}

resource "aws_network_interface" "UbuntuNI" {
  subnet_id       = aws_subnet.mainsub.id
  private_ips     = ["10.0.1.25"]

}
resource "aws_instance" "TF-Ubuntu1" {
  ami               = "ami-04505e74c0741db8d"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "TFSpace.key"
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.UbuntuNI.id
  }
  user_data = <<-EOF
 		#! /bin/bash
         sudo apt update -y
         sudo apt install apache2 -y
         sudo systemctl start apache2
 		    echo "<h1>Deployed on NthSky-ubuntu-web via Terraform</h1><br><h1>I Like Pizza!</h1>" | sudo tee /var/www/html/index.html
 	    EOF
  tags = {
    Name = "TF-Ubuntu1"
  }
}
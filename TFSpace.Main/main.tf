

resource "aws_vpc" "TFSpace_Prod" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "TFSpace Production VPC"
  }
}
resource "aws_subnet" "TFSpace_Prod_Sub" {
  vpc_id            = aws_vpc.TFSpace_Prod.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "TFSpace_Prod_Subnet"
  }
}

resource "aws_subnet" "TFSpace_Dev_Sub" {
  vpc_id            = aws_vpc.TFSpace_Prod.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"



  tags = {
    Name = "TFSpace_Dev_Subnet"

  }
}

resource "aws_security_group" "TFSpace_allow_web" {
  name        = "TFSpace_allow_web"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.TFSpace_Prod.id

  ingress {
    description = "Https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "Http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "TFSpace_allow_web"
  }
}
resource "aws_network_interface" "TFSpace_UbuntuNI" {
  subnet_id   = aws_subnet.TFSpace_Prod_Sub.id
  private_ips = ["10.0.1.25"]
  security_groups = [aws_security_group.TFSpace_allow_web.id]
}

resource "aws_internet_gateway" "TFSpace_GW" {
  vpc_id = aws_vpc.TFSpace_Prod.id

  tags = {
    Name = "TFSpace.Gateway"
  }
}
resource "aws_route_table_association" "TFSpace_RTA" {
  subnet_id      = aws_subnet.TFSpace_Prod_Sub.id
  route_table_id = aws_route_table.TFSpace_Route.id
}
resource "aws_route_table" "TFSpace_Route" {
  vpc_id = aws_vpc.TFSpace_Prod.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.TFSpace_GW.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.TFSpace_GW.id
  }

  tags = {
    Name = "TFSpace_Route"
  }
}
resource "aws_eip" "TFSpace_eip" {

  vpc                       = true
  network_interface         = aws_network_interface.TFSpace_UbuntuNI.id
  associate_with_private_ip = "10.0.1.25"
  depends_on                = [aws_internet_gateway.TFSpace_GW, aws_instance.TFSpace_Ubuntu1]
}

resource "aws_instance" "TFSpace_Ubuntu1" {
  ami               = "ami-04505e74c0741db8d"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "TFSpace.key"
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.TFSpace_UbuntuNI.id
  }

  user_data = <<-EOF
 		#! /bin/bash
         sudo apt update -y
         sudo apt install apache2 -y
         sudo systemctl start apache2
 		    echo "<h1>Deployed on NthSky-ubuntu-web via Terraform</h1><br><h1>I Like Pizza!</h1>" | sudo tee /var/www/html/index.html
 	    EOF
  tags = {
    Name = "TFSpace_Ubuntu1"
  }
}

output "TFSpace_Public_IP" {
  value = aws_eip.TFSpace_eip.public_ip
}

output "TFSpace_Private_IP" {
  value = aws_eip.TFSpace_eip.private_ip
}

output "TFSpace_MachineID" {
  value = aws_instance.TFSpace_Ubuntu1.id
}
output "TFSpace_Ubuntu1_State" {
  value = aws_instance.TFSpace_Ubuntu1.instance_state
}


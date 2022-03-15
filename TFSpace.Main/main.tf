resource "aws_instance" "TF-Ubuntu1" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"
  tags = {
    Name = "TF-Ubuntu1"
  }
}
 resource "aws_vpc" "Production" {
    cidr_block = "10.0.0.0/16"
     tags = {
      Name = "Production VPC"
     }
  }
   resource "aws_subnet" "mainsub" {
   vpc_id     = aws_vpc.Production.id
   cidr_block = "10.0.1.0/24"
   availability_zone = "us-east-1a"


   tags = {
     Name = "Main-Sub"
   }
 }

  resource "aws_subnet" "devsub" {
   vpc_id     = aws_vpc.Production.id
   cidr_block = "10.0.2.0/24"
   availability_zone = "us-east-1a"


   tags = {
     Name = "Dev-Sub"

   }
 }
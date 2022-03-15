resource "aws_instance" "TF-Ubuntu1" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"
  tags = {
    Name = "TF-Ubuntu1"
  }
}
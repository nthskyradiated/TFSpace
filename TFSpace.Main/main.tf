resource "aws_instance" "TF-Ubuntu1" {
  ami           = "04505e74c074"
  instance_type = "t3.micro"

  tags = {
    Name = "TF-Ubuntu1"
  }
}
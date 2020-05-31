resource "aws_key_pair" "proof-of" {
  key_name = "proof-of"
  
  public_key = "${file("${var.public_key_file}")}"
}


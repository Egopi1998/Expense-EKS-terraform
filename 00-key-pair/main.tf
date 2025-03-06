resource "tls_private_key" "terraform" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "terraform" {
  key_name   = "terraform"
  public_key = tls_private_key.terraform.public_key_openssh

  tags = merge(
    var.common_tags,
    {
        name = "${var.project_name}-${var.environment}"
    }
  )  
}

resource "local_file" "terraform" {
  content = tls_private_key.terraform.private_key_pem
  filename = "../terraform.pem"
}
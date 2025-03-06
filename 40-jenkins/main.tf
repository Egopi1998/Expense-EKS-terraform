resource "aws_instance" "jenkins" {
  ami = data.aws_ami.ami_info.id
  instance_type = "t3.small"
  vpc_security_group_ids = [ data.aws_security_group.default_vpc_sg_id.id ]
  associate_public_ip_address = true
  user_data = file("jenkins.sh")
  tags = {
    Name = "Jenkins"
  }
}
output "public_ip" {
  value = aws_instance.jenkins.public_ip
}
resource "aws_route53_record" "jenkins" {
  zone_id = data.aws_route53_zone.selected.zone_id
  allow_overwrite = true
  name    = "jenkins.${var.zone_id}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.jenkins.public_ip]
}

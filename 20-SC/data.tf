data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc_id"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_security_group" "default_vpc_sg_id" {
  name = "default"  # Replace with the actual name if different
  vpc_id = data.aws_vpc.default.id
}
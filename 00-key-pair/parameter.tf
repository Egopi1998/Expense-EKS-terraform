resource "aws_ssm_parameter" "key_pair" {
  name  = "/${var.project_name}/${var.environment}/devops"
  type  = "String"
  value = aws_key_pair.terraform.key_name
}
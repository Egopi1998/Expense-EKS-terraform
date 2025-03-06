resource "aws_ssm_parameter" "private_sg_id" {
  name  = "/${var.project_name}/${var.environment}/private_sg_id"
  type  = "String"
  value = module.private.sg_id
}

resource "aws_ssm_parameter" "public_sg_id" {
  name  = "/${var.project_name}/${var.environment}/public_sg_id"
  type  = "String"
  value = module.public.sg_id
}

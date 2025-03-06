locals {
  private_subnet_ids = data.aws_ssm_parameter.private_subnet_ids.value
  private_sg_id      = data.aws_ssm_parameter.private_sg_id.value
  vpc_id             = data.aws_ssm_parameter.vpc_id.value
}
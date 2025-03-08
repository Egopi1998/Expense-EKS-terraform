module "public" {
  source = "git::https://github.com/Egopi1998/terraform-aws-SG-module.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for Bastion and public access"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "public_${var.project_name}"
  ingress_rules = var.public_ingress_rules
}

module "private" {
  source = "git::https://github.com/Egopi1998/terraform-aws-SG-module.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for private resources"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "private_${var.project_name}"
  ingress_rules = var.private_ingress_rules
  depends_on = [ module.public ]
}



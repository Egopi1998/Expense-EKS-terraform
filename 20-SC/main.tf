module "public" {
  source = "git::https://github.com/Egopi1998/terraform-aws-SG-module.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for Bastion and public access"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "public_${var.project_name}"
  ingress_rules = [
    {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "private" {
  source = "git::https://github.com/Egopi1998/terraform-aws-SG-module.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for private resources"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "private_${var.project_name}"
  ingress_rules = [
    { # Bastion to DB
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      security_groups = [module.public.sg_id]
    },
    { # Bastion to control plane api server
      from_port = 443
      to_port = 443
      protocol = "tcp"
      security_groups = [module.public.sg_id]
    },
    { # ELB to node appliaction on 80 port
      from_port = 80
      to_port = 80
      protocol = "tcp"
      security_groups = [module.public.sg_id]
    },
    { # ELB to nodes 
      from_port = 30000
      to_port = 32767
      protocol = "tcp"
      security_groups = [module.public.sg_id]
    },
    { # allow all traffic from VPC
      from_port = 0
      to_port = 65535
      protocol = "tcp" #accept all protocols
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]
}
# private sg accepting traffic from private sg
resource "aws_security_group_rule" "private-private" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = module.private.sg_id
  source_security_group_id = module.private.sg_id # ✅ Allow traffic within the same SG
}



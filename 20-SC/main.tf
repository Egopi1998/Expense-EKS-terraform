module "public" {
  source = "git::https://github.com/Egopi1998/terraform-aws-SG-module.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for Bastion and public access"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "public"
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
  sg_name = "private"
  ingress_rules = [
    {  # EKS nodes should accept all traffic from nodes with in VPC CIDR range. #cluster to node communication
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
# private sg accepting traffic from public sg on node port range
/* resource "aws_security_group_rule" "public-private_node_port" {
  type                     = "ingress"
  from_port                = 30000
  to_port                  = 32767
  protocol                 = "tcp"
  security_group_id        = module.private.sg_id
  source_security_group_id = module.public.sg_id # from where traffic is coming from
} */
# private sg accepting traffic from public sg on port 80 because we are creating a load balancer with public sg
resource "aws_security_group_rule" "private-public_https" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = module.private.sg_id
  source_security_group_id = module.public.sg_id # from where traffic is coming from
}
resource "aws_security_group_rule" "private-public_db" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = module.private.sg_id
  source_security_group_id = module.public.sg_id # from where traffic is coming from
}
# private sg accepting traffic from public sg on port 443 because we are creating a load balancer with public sg, also to allow traffic from public bastion to k8s api
resource "aws_security_group_rule" "private-public_K8s_api_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = module.private.sg_id
  source_security_group_id = module.public.sg_id # from where traffic is coming from
}

resource "aws_security_group_rule" "public_default_vpc_sg_id_jenkins" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = data.aws_security_group.default_vpc_sg_id.id
  source_security_group_id = module.public.sg_id # from where traffic is coming from
}


locals {
    public_ingress_rules =  [
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
locals {
  private_ingress_rules = [
    { # allow all traffic from  private sg to private sg
      from_port = 0
      to_port = 65535
      protocol = "tcp"
      cidr_blocks = []
      security_groups = "self"
    },
    { # Bastion to DB
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      cidr_blocks = []
      security_groups = module.public.sg_id
    },
    { # Bastion to control plane api server
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = []
      security_groups = module.public.sg_id
    },
    { # ELB to node appliaction on 80 port
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = []
      security_groups = module.public.sg_id
    },
    { # ELB to nodes 
      from_port = 30000
      to_port = 32767
      protocol = "tcp"
      cidr_blocks = []
      security_groups = [module.public.sg_id]
    },
    { # allow all traffic from VPC
      from_port = 0
      to_port = 65535
      protocol = "-1" #accept all protocols
      cidr_blocks = ["10.0.0.0/16"]
      security_groups = []
    }
  ]
}
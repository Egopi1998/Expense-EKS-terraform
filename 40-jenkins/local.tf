# locals {
#   subnets = slice(data.aws_subnets.default.ids, 0, 2)
# }

# locals {
#   associate_public_ip_address = var.instance_name[count.index] == "frontend" ? true : false
# }
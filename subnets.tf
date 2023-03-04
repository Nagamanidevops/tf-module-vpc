module "subnets"{
  source                        = "./subnets"
  
    availability_zone           = var.availability_zone
    default_vpc_id              = var.default_vpc_id
    env                         = var.env
    
    for_each                    = var.subnets
    cidr_block                  = each.value.cidr_block
    name                        = each.value.name
    # internet_gw                 =  each.value.internet_gw ? aws_internet_gateway.gw.id : null
    internet_gw                 =  lookup(each.value, "internet_gw", false)? aws_internet_gateway.gw.id : null
   
    # nat_gw = lookup(each.value, "nat_gw", false)


    
     vpc_id                     =  aws_vpc.main.id
     vpc_peering_connection_id  =  aws_vpc_peering_connection.peer.id
     tags                       = local.common_tags
     }
     
     
     
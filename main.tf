resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = merge(
   local.common_tags, 
   { Name = "${var.env}-vpc" }
  )
}

resource "aws_subnet" "main" {
  count = length(var.subnets_cidr)    
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnets_cidr[count.index]

  tags = merge(
   local.common_tags, 
   { Name = "${var.env}-subnet -${count.index+1}"} 
  )
  }
  
  
resource "aws_vpc_peering_connection" "peer" {
  peer_owner_id = data.aws_caller_identity.current.account_id
  peer_vpc_id   = var.default_vpc_id
 # peer_vpc_id   = "vpc-00682b9d34c0f8605"
  vpc_id        = aws_vpc.main.id
  auto_accept   = true
  tags = merge(
    local.common_tags,
    { Name = "${var.env}-peering" }
  )

}

resource "aws_route" "default" {
  route_table_id            = aws_vpc.main.default_route_table_id
 # route_table_id            = data.aws_vpc.default.main_route_table_id
  destination_cidr_block    = "172.31.0.0/16"
 # vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
 # pcx-00df54d61d43b8a48


}

resource "aws_route" "default-vpc" {
  route_table_id            = data.aws_vpc.default.main_route_tableid
  destination_cidr_block    = var.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}



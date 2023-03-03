resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = merge(
   local.common_tags, 
   { Name = "${var.env}-vpc" }
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


resource
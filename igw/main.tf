resource "aws_internet_gateway" "tf_tut_igw" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Name    = "tf_tut_igw"
    Project = "tf_tutorial"
  }
}

resource "aws_route_table" "tf_tut_route_table" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Name    = "tf_tut_route_table"
    Project = "tf_tutorial"
  }
}

resource "aws_route" "tf_tut_default_route" {
  route_table_id         = aws_route_table.tf_tut_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.tf_tut_igw.id
}

resource "aws_route_table_association" "tf_tut_public_assoc" {
  subnet_id      = data.terraform_remote_state.subnet.outputs.tf_tut_subnet_id
  route_table_id = aws_route_table.tf_tut_route_table.id
}

resource "aws_security_group" "tf_tut_SG" {
  name        = "tf_tut_SG"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Name    = "tf_tut_SG"
    Project = "tf_tutorial"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.tf_tut_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443

  tags = {
    Name    = "tf_tut_SG_allow_tls_ipv4"
    Project = "tf_tutorial"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.tf_tut_SG.id
  cidr_ipv4         = "66.31.137.204/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22

  tags = {
    Name    = "tf_tut_SG_allow_ssh_ipv4"
    Project = "tf_tutorial"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.tf_tut_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports

  tags = {
    Name    = "tf_tut_SG_egress_rule_ipv4"
    Project = "tf_tutorial"
  }
}

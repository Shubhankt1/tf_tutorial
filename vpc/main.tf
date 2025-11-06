resource "aws_vpc" "tf_tut_vpc" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "tf_tut_vpc"
    Project = "tf_tutorial"
  }
}

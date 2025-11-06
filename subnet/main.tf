resource "aws_subnet" "tf_tut_subnet" {
  vpc_id                  = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block              = "10.0.0.64/26"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name    = "tf_tut_subnet"
    Project = "tf_tutorial"
  }
}

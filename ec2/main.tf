resource "aws_key_pair" "tf_tut_ec2_key_ST" {
  key_name   = "tf_tut_ec2_key_ST"
  public_key = file("~/.ssh/tf_tut_ec2_key.pub")

  tags = {
    # Name    = "tf_tut_ec2_key_ST"
    Project = "tf_tutorial"
  }
}

resource "aws_instance" "tf_tut_instance" {
  ami                    = data.aws_ami.tf_tut_server_ami.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.tf_tut_ec2_key_ST.id
  vpc_security_group_ids = [data.terraform_remote_state.sec_group.outputs.security_group_id]
  subnet_id              = data.terraform_remote_state.subnet.outputs.tf_tut_subnet_id

  user_data = file("./userdata.sh")

  tags = {
    Name    = "tf_tut_instance"
    Project = "tf_tutorial"
  }
}

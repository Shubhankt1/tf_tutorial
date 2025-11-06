data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../vpc/terraform.tfstate"
  }
}

data "terraform_remote_state" "subnet" {
  backend = "local"

  config = {
    path = "../subnet/terraform.tfstate"
  }
}

data "terraform_remote_state" "sec_group" {
  backend = "local"

  config = {
    path = "../sg/terraform.tfstate"
  }
}

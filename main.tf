provider "aws" {
  access_key = "${module.i411.aws_access_key}"
  secret_key = "${module.i411.aws_secret_key}"
  region     = "us-east-1"
}


module "i411" {
  source = "../terraform-module-411"
}


resource "aws_instance" "jenkins_host" {
  ami = "${module.i411.ami["ubuntu"]}"
}
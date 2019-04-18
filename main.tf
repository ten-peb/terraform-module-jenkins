

module "i411" {
  source = "../terraform-module-411"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${module.i411.region}"
}


resource "aws_security_group" "ports_for_jenkins" {
  name        = "Jenkins 22/80/8080"
  description = "Allow traffic for Jenkins"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 8080
    to_port     = 8080
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  revoke_rules_on_delete = "true"
}

resource "aws_instance" "jenkins_host" {
  ami = "${module.i411.ami["ubuntu"]}"
  instance_type="t2.large"
  subnet_id = "${module.i411.subnet[module.i411.environment]}"
  key_name = "${module.i411.key_name[module.i411.environment]}"
  
}

resource "aws_ebs_volume" "jenkins_data_volume" {
  size = 80
  availability_zone = "${aws_instance.jenkins_host.availability_zone}"
}

resource "aws_volume_attachment" "jenkins_ebs" {
  device_name = "/dev/sdd"
  volume_id = "${aws_ebs_volume.jenkins_data_volume.id}"
  instance_id = "${aws_instance.jenkins_host.id}"

}

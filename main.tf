

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
  vpc_id = "${module.i411.default_vpc[var.environment]}"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
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
resource "aws_ebs_volume" "jenkins_data_volume" {
  size = 80
  availability_zone = "${aws_instance.jenkins_host.availability_zone}"
}

resource "aws_volume_attachment" "jenkins_ebs" {
  device_name = "/dev/sdd"
  volume_id = "${aws_ebs_volume.jenkins_data_volume.id}"
  instance_id = "${aws_instance.jenkins_host.id}"

}

resource "aws_instance" "jenkins_host" {
  ami = "${module.i411.ami["ubuntu"]}"
  instance_type="t2.large"
  subnet_id = "${module.i411.subnet[module.i411.environment]}"
  key_name = "${module.i411.key_name[module.i411.environment]}"

  root_block_device {
    volume_size = 20 
  }


  tags {
    "Name" = "jenkins-s1-${var.environment}"
  }
  security_groups = ["${aws_security_group.ports_for_jenkins.id}"]


  connection {
    user = "ubuntu" ,
    private_key = "${file("/data/home/peter/.ssh/s1-dv1.pem")}"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -vp /opt/atjobs",
      "sudo mkdir -vp /opt/bin",
      "sudo mkdir -vp /opt/puppet-manifests",
      "sudo mkdir -vp /opt/syssetup",
      "sudo mkdir /var/log/provision",
      "sudo chown ubuntu /opt/bin",
      "sudo chown ubuntu /opt/syssetup",
      "sudo chown ubuntu /opt/puppet-manifests",
      "sudo chown ubuntu /opt/atjobs"
    ]
  }
  provisioner "file" {
    source = "scripts/bin/",
    destination = "/opt/bin/"
  }
  provisioner "remote-exec" {
     inline = [
        "sudo chmod 755 /opt/bin/*.sh"
     ]
  }
  provisioner "file" {
    source = "scripts/syssetup/",
    destination = "/opt/syssetup/"
  
 }
  provisioner "file" {
    source = "scripts/puppet-manifests/",
    destination = "/opt/puppet-manifests/"
  
 }
  provisioner "file" {
    source = "scripts/atjobs/",
    destination = "/opt/atjobs/"
  
 }
  provisioner "remote-exec" {
    inline = [
      "sudo /opt/bin/finish-script.sh"
    ]
  }
}


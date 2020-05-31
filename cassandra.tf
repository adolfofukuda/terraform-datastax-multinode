resource "aws_instance" "cassandra_master" {
  instance_type = "${var.instance_type}"
  ami = "${var.ami}"
  private_ip = "10.2.5.170"
  subnet_id = "${aws_subnet.main.id}"
  vpc_security_group_ids = ["${module.cassandra_security_group.security_group_id}", "${aws_security_group.allow_internet_access.id}", "${aws_security_group.allow_all_ssh_access.id}"]
  depends_on = ["aws_internet_gateway.gw"]

  tags {
    Name    = "cassandra-proof-of_0"
    project = "proof-of"
    Type    = "cassandra"
  }

  key_name = "${aws_key_pair.proof-of.key_name}"
  
  provisioner "file" {
    source = "provisioning/setup_cassandra.sh"
    destination = "/tmp/setup_cassandra.sh"
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("${var.private_key_file}")}"
    }
  }

  provisioner "file" {
    source = "provisioning/dsbulk-1.5.0.tar.gz"
    destination = "~/dsbulk-1.5.0.tar.gz"
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("${var.private_key_file}")}"
    }
  }

  provisioner "file" {
    source = "provisioning/extrato.sql"
    destination = "~/extrato.sql"
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("${var.private_key_file}")}"
    }
  }

  provisioner "file" {
    source = "provisioning/gend.py"
    destination = "~/gend.py"
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("${var.private_key_file}")}"
    }
  }

  provisioner "remote-exec" {
    inline = ["chmod +x /tmp/setup_cassandra.sh",
      "bash /tmp/setup_cassandra.sh 0",
      "sleep 1",
      "tar -xzvf ~/dsbulk-1.5.0.tar.gz",
      "sleep 1",
      "export PATH=~/dsbulk-1.5.0/bin:$PATH"]
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("${var.private_key_file}")}"
    }
  }
}


resource "aws_instance" "cassandra_1" {
  instance_type = "${var.instance_type}"
  ami = "${var.ami}"
  private_ip = "10.2.5.171"
  subnet_id = "${aws_subnet.main.id}"
  vpc_security_group_ids = ["${module.cassandra_security_group.security_group_id}", "${aws_security_group.allow_internet_access.id}", "${aws_security_group.allow_all_ssh_access.id}"]
  depends_on = ["aws_internet_gateway.gw", "aws_instance.cassandra_master"]

  tags {
    Name    = "cassandra-proof-of_1"
    project = "proof-of"
    Type    = "cassandra"
  }

  key_name = "${aws_key_pair.proof-of.key_name}"

  provisioner "file" {
    source = "provisioning/setup_cassandra.sh"
    destination = "/tmp/setup_cassandra.sh"
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("${var.private_key_file}")}"
    }
  }

  provisioner "remote-exec" {
    inline = ["chmod +x /tmp/setup_cassandra.sh",
      "bash /tmp/setup_cassandra.sh 1",
      "sleep 1"]
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("${var.private_key_file}")}"
    }
  }
}


resource "aws_instance" "cassandra_2" {
  instance_type = "${var.instance_type}"
  ami = "${var.ami}"
  private_ip = "10.2.5.172"
  subnet_id = "${aws_subnet.main.id}"
  vpc_security_group_ids = ["${module.cassandra_security_group.security_group_id}", "${aws_security_group.allow_internet_access.id}", "${aws_security_group.allow_all_ssh_access.id}"]
  depends_on = ["aws_internet_gateway.gw", "aws_instance.cassandra_1"]

  tags {
    Name    = "cassandra-proof-of_2"
    project = "proof-of"
    Type    = "cassandra"
  }

  key_name = "${aws_key_pair.proof-of.key_name}"

  provisioner "file" {
    source = "provisioning/setup_cassandra.sh"
    destination = "/tmp/setup_cassandra.sh"
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("${var.private_key_file}")}"
    }
  }

  provisioner "remote-exec" {
    inline = ["chmod +x /tmp/setup_cassandra.sh",
      "bash /tmp/setup_cassandra.sh 2",
      "sleep 1"]
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("${var.private_key_file}")}"
    }
  }

}


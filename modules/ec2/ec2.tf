resource "aws_instance" "instance" {
  ami = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  network_interface {
    device_index = 0
    network_interface_id = "${var.nic_id}"
  
  }
  tags = {
      "Name" = "${var.instance_name}"
      "Managed by" = "terraform"
  }
}

output "private_ip" {
  value = "${aws_instance.instance.private_ip}"
}

output "public_ip" {
    value = "${aws_instance.instance.public_ip}"
  
}
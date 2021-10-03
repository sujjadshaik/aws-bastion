resource "aws_vpc" "my-app"{
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    
    tags = {
      "Name" = "${var.vpc_name}"
      "Managed by" = "terraform"

    }
}

resource "aws_subnet" "my-subnet" {
    vpc_id = "${aws_vpc.my-app.id}"
    cidr_block = "${var.subnet_cidr}"
    availability_zone = "${var.availability_zone}"
    map_public_ip_on_launch = true
    tags = {
      "Name" = "${var.subnet_name}"
      "Managed by" = "terraform"
    }
  
}

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.my-app.id}"

    tags = {
      "Name" = "${var.gt_name}"
    }
  
}

resource "aws_route_table" "rt" {
    vpc_id = "${aws_vpc.my-app.id}"

    route  {
        cidr_block = "0.0.0.0/0"
        
        gateway_id = "${aws_internet_gateway.gw.id}"
      
    }
    tags = {
        "Name" = "${var.rt_name}"
        "Managed by" = "terraform"
    } 
  
}

resource "aws_route_table_association" "rt_associa" {
    subnet_id = "${aws_subnet.my-subnet.id}"
    route_table_id = "${aws_route_table.rt.id}"
  
}


resource "aws_security_group" "bastion-sc" {
    name = "${var.bastion_sc_name}"
    description = "bastion security group"
    vpc_id = "${aws_vpc.my-app.id}"

    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      "Name" = "Bastion sc"
      "Managed by" = "terraform"
    }
  
}


resource "aws_security_group" "app-sc" {
    name = "${var.sc_name}"
    description = "app security group"
    vpc_id = "${aws_vpc.my-app.id}"

    ingress  {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [ "${aws_security_group.bastion-sc.id}" ]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        "Name" = "app sc"
        "Managed by" = "terraform"
    }
  
}

resource "aws_network_interface" "app-nic" {
    subnet_id = "${aws_subnet.my-subnet.id}"
    security_groups = [ "${aws_security_group.app-sc.id}" ] 
      
    tags = {
      "Name" = "${var.app_nic_name}"
    }
  
}

resource "aws_network_interface" "bastion-nic" {
    subnet_id = "${aws_subnet.my-subnet.id}"
    security_groups = [ "${aws_security_group.bastion-sc.id}" ]
    tags = {
      "Name" = "${var.bastion_nic_name}"
    }
  
}


output "app-nic" {
  value = "${aws_network_interface.app-nic.id}"
}

output "bastion-nic" {
    value = "${aws_network_interface.bastion-nic.id}"
  
}
# aws-bastion-terraform
![alt tag](https://github.com/sujjadshaik/aws-bastion/blob/ecc802e2b0c9d17a547e0394e523461382b08b06/bastion.PNG)

## bastion security group
```
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
```
## application security group
```
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
```

provider "aws" {
    access_key = "XXXXXXXXXXXXXXXXXXXXXXX"
    secret_key = "XXXXXXXXXXXXXXXXXXXX"
    region = "us-east-2"
  
}

module "networking" {
    source = "./modules/networking"
    vpc_name = "app-vpc"
    subnet_name = "app-subnet"
    availability_zone = "us-east-2a"
    gt_name = "app-gt"
    rt_name = "app-rt"
    bastion_sc_name = "bastion-sc"
    sc_name = "app-sc"
    app_nic_name = "app-nic"
    bastion_nic_name = "bastion-nic"
    
  
}

module "app-ec2" {
    source = "./modules/ec2"
    instance_name = "app"
    ami_id = "ami-00399ec92321828f5"
    nic_id = "${module.networking.app-nic}"
    key_name = "aws-keypair"
    depends_on = [
      module.networking
    ]
    
  
}

module "bastion-ec2" {
    source = "./modules/ec2"
    instance_name = "bastion"
    ami_id = "ami-00399ec92321828f5"
    nic_id = "${module.networking.bastion-nic}"
    key_name = "aws-keypair"
    depends_on = [
      module.networking
    ]
    
  
}
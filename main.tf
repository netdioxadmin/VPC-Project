# Creatin VPC
resource "aws_vpc" "projectvpc" {
  cidr_block           = var.vpc_subnet
  enable_dns_hostnames = true
  tags = {
    Name = var.projectname
  }
}

#Public Subnet 1
resource "aws_subnet" "projectvpc_publicsub_1" {
  vpc_id                  = aws_vpc.projectvpc.id
  cidr_block              = var.publicsubnet1
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"
  tags = {
    Name = "${var.projectname}-public_1"
  }

}
#Public Subnet 2
resource "aws_subnet" "projectvpc_publicsub_2" {
  vpc_id                  = aws_vpc.projectvpc.id
  cidr_block              = var.publicsubnet2
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}b"
  tags = {
    Name = "${var.projectname}-public_2"
  }


}
# Private Subnet 1
resource "aws_subnet" "projectvpc_privatesub_1" {
  vpc_id            = aws_vpc.projectvpc.id
  cidr_block        = var.privatesubnet1
  availability_zone = "ap-south-1a"
  tags = {
    Name = "${var.projectname}-private_1"
  }

}
# Private Subnet 2 
resource "aws_subnet" "projectvpc_privatesub_2" {
  vpc_id            = aws_vpc.projectvpc.id
  cidr_block        = var.privatesubnet2
  availability_zone = "ap-south-1b"
  tags = {
    Name = "${var.projectname}-private_2"
  }

}

# igw creation

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.projectvpc.id
  tags = {
    Name = "${var.projectname}-igw"
  }
}

# Creating Elastic IP for Nat Gateway 
resource "aws_eip" "natip1" {
  tags = {
    Name = "${var.projectname}-eip-1"
  }

}
# Creating Elastic IP for Nat Gateway 
resource "aws_eip" "natip2" {
  tags = {
    Name = "${var.projectname}-eip-2"
  }

}
# Creating Nat Gateway 1
resource "aws_nat_gateway" "ngw1" {
  allocation_id = aws_eip.natip1.id
  subnet_id     = aws_subnet.projectvpc_publicsub_1.id
  tags = {
    Name = "${var.projectname}-ngw-1"
  }

}
# Creating Nat Gateway 2
resource "aws_nat_gateway" "ngw2" {
  allocation_id = aws_eip.natip2.id
  subnet_id     = aws_subnet.projectvpc_publicsub_2.id
  tags = {
    Name = "${var.projectname}-ngw-2"
  }

}
################ ROUTE TABLE FOR PUBLIC SUBNET #######################
# Route Table for Public Subnet - 1 and 2 
resource "aws_route_table" "public1" {
  vpc_id = aws_vpc.projectvpc.id

  tags = {
    Name = "${var.projectname}-PUBLIC-RTB-1"
  }
}
# Route for Public Subnet -1
resource "aws_route" "personalinetroute" {
  route_table_id         = aws_route_table.public1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Assoicate Public subnet 1 to Route table
resource "aws_route_table_association" "publicsubnet1" {
  subnet_id      = aws_subnet.projectvpc_publicsub_1.id
  route_table_id = aws_route_table.public1.id
}

# Assoicate Public subnet 2 to Route table
resource "aws_route_table_association" "publicsubnet2" {
  subnet_id      = aws_subnet.projectvpc_publicsub_2.id
  route_table_id = aws_route_table.public1.id
}
############################## ROUTE TABLE FOR PRIVATE SUBNET - 1 ###############
# Route Table for Private Subnet 
resource "aws_route_table" "pvtrtb1" {
  vpc_id = aws_vpc.projectvpc.id
  tags = {
    Name = "${var.projectname}-PVTRTB-1"
  }
}

# Route table for Private subnet-1
resource "aws_route" "personalpvtroute1" {
  route_table_id         = aws_route_table.pvtrtb1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw1.id
}
# Associate Association  Private - Subnet -1
resource "aws_route_table_association" "pvtsubnet1" {
  subnet_id      = aws_subnet.projectvpc_privatesub_1.id
  route_table_id = aws_route_table.pvtrtb1.id
}
####################### ROUTE TABLE FOR PRIVATE SUBNET - 2 ####################
# Route Table for Private Subnet 
resource "aws_route_table" "pvtrtb2" {
  vpc_id = aws_vpc.projectvpc.id
  tags = {
    Name = "${var.projectname}-PVTRTB-2"
  }
}
# Associate Association  Private - Subnet -2 
resource "aws_route_table_association" "pvtsubnet2" {
  subnet_id      = aws_subnet.projectvpc_privatesub_2.id
  route_table_id = aws_route_table.pvtrtb2.id
}
# Route table for Private subnet-2
resource "aws_route" "personalpvtroute2" {
  route_table_id         = aws_route_table.pvtrtb2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw2.id
}
########################################Creating Launch Template ###############################
#Fetching Ubuntu Image Regardless Region
data "aws_ami" "ubuntult" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
# Creating Launch Template
resource "aws_launch_template" "personallt" {
  name                   = "${var.projectname}-launchtemplate"
  description            = "${var.projectname}-launchtemplate"
  image_id               = data.aws_ami.ubuntult.id
  instance_type          = var.instance_type
  key_name               = var.keyname
  vpc_security_group_ids = ["${aws_security_group.tmplsg.id}"]
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.projectname}-template-instance"
    }
  }
}
# Creating a Auto Scaling Group
resource "aws_autoscaling_group" "personalAG" {
  name                      = "${var.projectname}-AG"
  max_size                  = 4
  min_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 20
  force_delete              = true
  launch_template {
    id      = aws_launch_template.personallt.id
    version = "$Latest"
  }
  vpc_zone_identifier = [aws_subnet.projectvpc_privatesub_1.id, aws_subnet.projectvpc_privatesub_2.id]
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [load_balancers, target_group_arns]
  }
}


##################### LOAD BALANCING ######################
# Creating Target Group
resource "aws_lb_target_group" "personalprojecttg" {
  name                 = "Front-End"
  target_type          = "instance"
  port                 = "80"
  protocol             = "HTTP"
  vpc_id               = aws_vpc.projectvpc.id
  deregistration_delay = 20
  health_check {
    enabled             = true
    interval            = 10
    path                = "/"
    timeout             = 3
    unhealthy_threshold = 2
    healthy_threshold   = 5
    port                = "traffic-port"
    protocol            = "HTTP"
    matcher             = 200

  }

}

# Creating Load Balancer
resource "aws_lb" "personallbpublic" {
  name                       = "Personal-LB-Public"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.tmplsg.id]
  subnets                    = [aws_subnet.projectvpc_publicsub_1.id, aws_subnet.projectvpc_publicsub_2.id]
  enable_deletion_protection = false

}
# Creating Listner
resource "aws_lb_listener" "personalblistner" {
  load_balancer_arn = aws_lb.personallbpublic.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.personalprojecttg.arn
  }

}
# Attaching Instance to AutoScaling Group
resource "aws_autoscaling_attachment" "personal-attach" {
  autoscaling_group_name = aws_autoscaling_group.personalAG.name
  lb_target_group_arn    = aws_lb_target_group.personalprojecttg.arn
}

# Creating A Baston Instance pulling Image details with filter
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
# Creating ec2 instance Bastion 
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.projectvpc_publicsub_1.id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  key_name               = var.keyname
  tags = {
    Name    = "Bastion"
    project = "${var.projectname}"
  }
}

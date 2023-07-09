# Listing Availablity Zone
data "aws_availability_zones" "available" {
  state = "available"
}

output "az_list" {
  value = data.aws_availability_zones.available[*].names

}

# Listing Running Instances
data "aws_instances" "personallb" {
  instance_tags = {
    Name = "${var.projectname}-template-instance"
  }
  instance_state_names = ["running", "stopped"]
}

output "privateIP" {
  value = data.aws_instances.personallb.private_ips
}

# Writing Private IP'S to a file 
resource "local_file" "privateips" {
  content  = join("\n", data.aws_instances.personallb.private_ips)
  filename = "${var.projectname}-LB-Instance-Privateip"
}
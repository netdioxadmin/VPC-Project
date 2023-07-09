# Overview

This project contains Terraform code to create and configure infrastructure resources on AWS. The Terraform code sets up a Virtual Private Cloud (VPC) with public and private subnets across two availability zones. It also provisions NAT gateways included in each Public Subnet, an Auto Scaling Group, a Security Group for Launch Templates, and an Application Load Balancer. The server takes traffic from internet through the load balancer. The server running inside the private subnet communicate to outside using a NAT gateway.

# Service Used In the Project.

- EC2
- VPC
- AWS Load Balancer
- Target-Group
- Bastion Host or Jump Server
- NAT Gateway
- Auto Scaling Group
- Launch Template

#Features
The project provides the following features:

- Creation of a VPC with public and private subnets
- Distribution of resources across two availability zones for high availability
- Configuration of NAT gateways to provide outbound internet access for private subnets
- Automatic scaling of instances based on demand with the Auto Scaling Group
- Definition of a Security Group to control inbound and outbound traffic for Launch Templates
- Configuration of an Application Load Balancer for load balancing traffic across instances

## **Prerequisites**

Before using this Terraform code, ensure that you have the following prerequisites:

- An AWS account with appropriate permissions to create and manage resources
- Terraform installed on your local machine (version 0.12 or above)

## **Getting Started**

To use this project, follow the steps below:

1. Clone the repository to your local machine:
    
    ```bash
    git clone https://github.com/netdioxadmin/VPC-Project.git
    ```
    
2. Change into the project directory:
    
    ```bash
    cd project
    ```
    
3. Open the **`main.tf`** file and customize any configuration options according to your requirements.
4. Initialize the Terraform project:
    
    ```bash
    terraform init
    ```
    
5. Review the execution plan:
    
    ```bash
    terraform plan
    ```
    
6. If the execution plan looks satisfactory, apply the changes:
    
    ```bash
    terraform apply
    ```
    
    Confirm the changes by typing **`yes`** when prompted.
    
7. Once the provisioning is complete, the Terraform output will display the availability zones and save the private IP addresses of the instances to a file.

## **Files and Directory Structure**

The project directory contains the following files:

- **`main.tf`**: The main Terraform configuration file that defines the infrastructure resources.
- **`variables.tf`**: Contains variable definitions used in the Terraform configuration.
- **`outputs.tf`**: Defines the outputs that are displayed after running **`terraform apply`**.
- **`README.md`**: This documentation file.

## **Outputs**

After successfully applying the Terraform configuration, the following outputs will be displayed:

- **`availability_zones`**: Lists the availability zones where the resources are provisioned.
- **`privateIP`**: Contains the private IP addresses of the instances created. These IP addresses are also saved to a file.

## **Cleaning Up**

To clean up and destroy the resources created by this Terraform project, run the following command:

```
terraform destroy
```

Confirm the destruction by typing **`yes`** when prompted.

**Note:** Be cautious when using the **`destroy`** command, as it permanently deletes all resources created by this project.

## **License**

This project is licensed under the **[MIT License](https://chat.openai.com/LICENSE)**. Feel free to modify and distribute this code as needed.

## **Contributing**

Contributions to this project are welcome. If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## **Acknowledgements**

Special thanks to the Terraform community for their valuable contributions and support.


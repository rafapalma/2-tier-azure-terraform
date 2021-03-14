# Two-tier Architecture with Terraform on Azure

This project is a deployment of a two-tier architecture on Microsoft Azure using Terraform.  

The architecture is composed by 3 instances:  
- Bastion Host  
- Web Server  
- Application Server  

The Bastion Host will be sitted in the public subnet with SSH access allowed from white-listed IPs, which can be set in the Terraform setup.

The Web server will be sitted in the public subnet with HTTP/HTTPS access allowed from the Internet. Only SSH connections from the Bastion Host is allowed.

The App server will be sitted in the private subnet with HTTP/HTTPS access allowed from the Web server. Only SSH connections from the Bastion Host is allowed.


## Getting Started

These instructions will get you a copy of the project up and running on your local machine for testing purposes.


### Requirements

For this deployment is required the following to run:  
- Terraform  


## Usage

### Installing Terraform:

On Ubuntu/Debian:

Add the HashiCorp GPG key:  
> `curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -`

Add the official HashiCorp Linux repository:
> `sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"`

Update and Install:
> `sudo apt-get update && sudo apt-get install terraform`


### Setting-up your deployment

1. Add your subscription-id, client-id, client-secret and tenant-id in the file ***terraform.tfvars***

2. Copy your private and public key files in the folder ***keys***

3. Edit the ***virtual_machine.tf*** file, update the public-key filename in the ***os_profile_linux_config*** for each virtual machine.

4. You can customize your deployment editing the variables in the file ***variables.tf***, changing parameters like:
   - AMI map  
   - Service Ports  
   - White-list of IPs/Ports to access the Bastion Host.  

  
## Deployment

To deploy the infrastructure, run the command in the root folder:

> `terraform init`  
> `terraform apply`  

Terraform will show you the plan and all the resources that will be deployed in your account.

Type *yes* when you see the output below:

> ```
> Do you want to perform these actions?
>   Terraform will perform the actions described above.
>   Only 'yes' will be accepted to approve.
> 
>   Enter a value:
> ```

When Terraform is done with the deployment, it will output in the CLI the DNS-Names and IPs of the instances.

To test the deployment, you can access the public DNS name of the Web instance, you should see the message ***Azure VM deployed with Terraform!!!***.


## Contributing

To contribute to this deployment, clone this repo and commit your code in a separate branch.

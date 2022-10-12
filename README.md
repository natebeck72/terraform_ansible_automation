# Terraform Ansible Automation
This is the Docker container with Terraform/Ansible and the deployment/configuration jobs.


Instructions

1. Download the latest version of the docker container from the docker hub 
2. Start the docker container with a mounted volume (ie. I use a local directory that holds my variable files and I mount it to /credentials inside the container)
3. Connect to the CLI
4. Run the command "az login" and follow the prompt to log the user session into azure, once logged in it will show you the subscriptions you have access to.
5. If needed run "az account set --subscription *subscriptionid*" where the subscriptionid = the id of the sub you want to be your default
6. Ensure that you have a name.tfvars file in your mounted volume, it will need to have the following variables:

- customername = 
- location = 
- admin_username = 
- admin_password = 
- SE_Email = 
- user_identifier = 
- panorama_sn = 

### NOTE 
if you have access to the wildcard certificate for the POV domain, you will also need the following fields

- cert_passphrase =
- cert_url = 

Definitions of variables

| Variable | Description|
| --- | --- |
| customername | name of the customer, used in the naming of azure objects and some panorama objects |
| location | the Azure location of where you want the resource group located, if unsure run *az account list-locations -o table* you want the Name field not Displayname |
| admin_username | This is the username of the account that will get pushed into both the ngfw and the panorama as an administrator |
| admin_password | This is the password for the above account, it will need to follow the palo alto minimum requirements - 11 characters, 1 of each uppercase, lowercase, number, special character |
| SE_Email | This is used to tag the azure elements with the SE's email address, this is required if it is a corporate owned subscription, otherwise the elements will be shut down |
| user_identifer | Usually the username portion of the email, used in the naming of the resource group in azure so that if the subscription is shared, that you know WHO deployed what |
| panorama_sn | This is the SN for the panorama, it is required that you have one to run this, as it will license and configure the panorama. If you don't include a valid sn here it will fail |
| cert_passphrase | This is the passphrase for the pkcs12 cert file, only to be used when you have access to the wildcard cert file |
| cert_url | This is the public url location for the pkcs12 file, only to be used when you have access to the wildcard cert file |


7. Run the terraform plan 
- Change directory to the /TF_POC_AutomationDocker directory on the docker container
- terraform plan --var-file=/credentials/name.tfvar -out=tfplan.out
- terraform apply "tfplan.out"

This will create a plan file and then apply that, I usually do that so that I can see if there are any error's

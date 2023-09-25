# terraform-gcp-test

You need to have a GCP account and a project created in order to run this script. Also you need to add json key (credentials) to your project and set the path to it in the terraform.tfvars file.

#Terraform
terraform init
terraform plan
terraform apply -var-file=terraform.tfvars

optional:
terraform destroy

Make sure you have Cloud SQL Admin API enabled

# Screenshots

$terraform init
![terraform init Screenshot](./screenshots/terraform_init.png?raw=true "terraform init Screenshot")

$terraform plan
![terraform plan Screenshot](./screenshots/terraform_plan.png?raw=true "terraform plan Screenshot")

$terraform apply
![terraform apply Screenshot](./screenshots/terraform_apply_prombt_yes.png?raw=true "terraform apply Screenshot")
![terraform apply Screenshot](./screenshots/terraform_apply_inprogress.png?raw=true "terraform apply Screenshot")
![terraform apply Screenshot](./screenshots/terraform_apply_done.png?raw=true "terraform apply Screenshot")

$terraform result in GCP dashboard
![terraform result in GCP dashboard Screenshot](./screenshots/gcp_dashboard.png?raw=true "terraform result in GCP dashboard Screenshot")

#terraform destroy
![terraform destroy Screenshot](./screenshots/terraform_destroy.png?raw=true "terraform destroy Screenshot")
![terraform destroy Screenshot](./screenshots/terraform_destroy_done.png?raw=true "terraform destroy Screenshot")

# Answers

5.1: I structured the terraform script as blocks for each resource. I used env variables in my code but I also attached the alternative to it in case this was a part of CICD.

5.2: You can use the buitl-in GCP monitor and logs. Personally I prefer to have additional tools like Grafana to monitor the infrastructure. As well as DataDog to monitor the application.

5.3: Since it is a web app I would rather use a serverless instances (Cloud Run) to loadbalance. Also since it is Pay-as-you-go it will be cheaper than using a VM instance and will be automatically scale. I would also use a CDN to cache the static content and reduce the load on the server. CloudSQL is a good choice but depends on the scale of the application we can use a heavier database like AlloyDB or Cloud Spanner.

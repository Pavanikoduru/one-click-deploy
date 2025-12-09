# DevOps One-Click Deployment

## Deploy
$ chmod +x scripts/deploy.sh
$ ./scripts/deploy.sh

## Test
Visit ALB DNS output from Terraform or run:
$ ./scripts/test.sh

## Destroy (IMPORTANT)
$ ./scripts/destroy.sh


Step 1: Navigate to Terraform Directory
cd /root/one-click-deploy/terraform

Step 2: Initialize Terraform

This will download providers and modules.

terraform init

Step 3: Validate Terraform Configuration

Check if your .tf files are valid.

terraform validate

Step 4: Generate Terraform Execution Plan

Preview the resources Terraform will create.

terraform plan

Step 5: Apply Terraform Plan

Apply the plan to create AWS resources.

terraform apply


Terraform will ask for confirmation. Type yes.

Step 6: Get Outputs (Optional)

If you have outputs defined (like ALB DNS), run:

terraform output


Example:

terraform output alb_dns_name

Step 7: Check EC2 Instances
aws ec2 describe-instances --filters "Name=vpc-id,Values=<your-vpc-id>"

Step 8: Deploy Node.js Application

Navigate to Node.js app folder:

cd /root/one-click-deploy/app


Install dependencies (if any):

npm install

Start the server:

node server.js

Step 9: Access Application

Open a browser and go to your ALB DNS Name:

http://<alb_dns_name>:8080

Step 10: Updating Application

If you modify code or Terraform:

git add .
git commit -m "Updated code"
git push origin main


For Terraform changes:

terraform plan
terraform apply

Step 11: Clean Up (Optional)

Destroy all resources when not needed:

terraform destroy


Confirm with yes.


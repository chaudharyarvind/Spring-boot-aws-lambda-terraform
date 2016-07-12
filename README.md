
# Spring boot microservice using Lamda and deploy code using Terraform
The example service demonstrate running spring boot micro service on AWS lambda and api gateway.
You can play with spring boot service locally and create and deploy on AWS using terraform.
## Installation
First run gradle build to build the application jar.
`
./gradlew build
`
## Terraform
Install the terraform.

`brew install terraform
`

You need to set up the AWS access key and api key in the environment before running the terraform.  

Go to AWS directory and run

`
terraform apply
`

Once all done test it by 

``
curl -H "Content-Type: application/json" -X POST https://<api-endpoint>/notifications -d '{"title":"firstNotification","text":"hello world"}'
``

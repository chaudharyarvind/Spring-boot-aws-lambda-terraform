provider "aws" {
  region = "${var.region}"
}

module "deploy-function" {
  source = "./lambda-deploy"
}

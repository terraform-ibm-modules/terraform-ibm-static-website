variable "cos_instance_name" {
  description = "Give your Cloud Object Storage (COS) instance a unique name. Lite accounts are limited to one instance of COS, and you might need to delete the previously created instance."
  type    = string
  default = "sample-solution-cos-instance"
}

variable "cos_bucket_name" {
  description = "Name the bucket that will be created on your Cloud Object Storage instance. Bucket names must be globally unique across IBM Cloud, and must be 3-63 characters in length. The name can include lowercase alphanumeric characters as well as nonconsecutive dashes and hyphens, but must start and end with alphanumeric characters."
  type    = string
}

variable "cos_plan_type" {
  description = "Enter a plan type for your Cloud Object Storage instance. The Lite plan is recommended for most users."
  type    = string
  default = "lite"
}

variable "resource_group" {
  description = "Enter the name of the existing resource group in which you would like your resources to be deployed."
  type    = string
  default = "default"
}

variable "ibmcloud_api_key" {
  description = "Select a Secret Manager secret containing the API key you will use to deploy."
  type      = string
  sensitive = true
}

variable "region" {
  description = "Enter the region where you'd like your resources to be deployed."
  type    = string
  default = "us-south"
}

variable "app_repo_name" {
  description = "Enter a name for the new repository that's created to store your application files."
  type    = string
  default = "sample-solution-app-repo"
}

variable "git_token" {
  description = "Provide an IBM hosted GitLab access token from your account"
  type      = string
  sensitive = true
}

variable "resource_group" {
  type = string
}

variable "ibmcloud_api_key" {
  type = string
}

variable "ibmcloud_iam_endpoint" {
  type = string
}

variable "s3_endpoint_public" {
  type = string
}

variable "cos_bucket_instance_id" {
  type = string
}

variable "cos_bucket_name" {
  type = string
}

variable "pipeline_repo_url" {
  type    = string
}

variable "pipeline_branch" {
  type    = string
  default = "main"
}

variable "pipeline_folder" {
  type    = string
  default = ".tekton"
}


variable "app_repo_base_url" {
  type = string
}

variable "app_repo_name" {
  type = string
}

variable "pipeline_name" {
  type    = string
  default = "sample-solution-pipeline"
}

variable "toolchain_name" {
  type    = string
  default = "sample-solution-toolchain"
}

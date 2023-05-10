variable "cos_instance_name" {
    type    =   string
}

variable "cos_bucket_name" {
    type    =   string
}

variable "cos_plan_type" {
    type    =   string
}

variable "bucket_location" {
    type    =   string
}

variable "bucket_storage_class" {
    type    =   string
    default =   "smart" 
}

variable "resource_group" {
    type    =   string
}

variable "ibmcloud_api_key" {
    type    =   string
}

variable "ibmcloud_iam_endpoint" {
    type    =   string
}
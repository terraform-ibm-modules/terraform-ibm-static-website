locals {
  s3_public_endpoint=length(regexall("https:", "${ibm_cos_bucket.cos_bucket_instance.s3_endpoint_public}")) > 0 ? ibm_cos_bucket.cos_bucket_instance.s3_endpoint_public : "https://${ibm_cos_bucket.cos_bucket_instance.s3_endpoint_public}"
}

data "ibm_iam_access_group" "public_access" {
  access_group_name = "Public Access"
}

data "ibm_resource_group" "cos_resource_group" {
  name = var.resource_group
}

resource "ibm_resource_instance" "cos_instance" {
  name              = var.cos_instance_name
  service           = "cloud-object-storage"
  plan              = var.cos_plan_type
  location          = "global"
  resource_group_id = data.ibm_resource_group.cos_resource_group.id

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

resource "ibm_cos_bucket" "cos_bucket_instance" {
  bucket_name          = var.cos_bucket_name
  resource_instance_id = ibm_resource_instance.cos_instance.id
  region_location      = var.bucket_location
  storage_class        = var.bucket_storage_class
}

resource "null_resource" "cos_instance_init" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/cos.sh"
    environment = {
      APIKEY                = var.ibmcloud_api_key
      IBMCLOUD_IAM_ENDPOINT = var.ibmcloud_iam_endpoint
      INSTANCE_ID           = ibm_resource_instance.cos_instance.id
      S3_ENDPOINT           = local.s3_public_endpoint
      BUCKET_NAME           = var.cos_bucket_name
      INDEX_FILE            = "${path.module}/html/index.html"
    }
  }
}

resource "ibm_iam_access_group_policy" "cos_public_access_policy" {
  access_group_id = data.ibm_iam_access_group.public_access.groups.0.id

  roles = [ "Object Reader" ]

  resources {
    service = "cloud-object-storage"
    resource_instance_id = ibm_resource_instance.cos_instance.guid
    resource_type = "bucket"
    resource = ibm_cos_bucket.cos_bucket_instance.bucket_name
  }
}
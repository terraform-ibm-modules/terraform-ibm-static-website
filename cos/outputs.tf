output "website_url" {
  value = "${replace(local.s3_public_endpoint, "://s3", "://${var.cos_bucket_name}.s3-web")}/index.html"
}

output "cos_bucket_instance_id" {
    value = resource.ibm_resource_instance.cos_instance.id
}

output "cos_bucket_name" {
    value = var.cos_bucket_name
}

output "cos_s3_endpoint" {
    value = local.s3_public_endpoint
}
output "website_url" {
  value = "${replace(module.cos.cos_s3_endpoint, "://s3", "://${var.cos_bucket_name}.s3-web")}/index.html"
}

output "git_repo_url" {
  value = module.toolchain.git_repo_url
}
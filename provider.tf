provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

provider "gitlab" {
  base_url        = "https://${var.region}.git.cloud.ibm.com"
  token           = var.git_token
}

locals {
  pipeline_repo_url = var.pipeline_repo_url
}

data "ibm_resource_group" "toolchain_resource_group" {
  name = var.resource_group
}

resource "ibm_cd_toolchain" "toolchain_instance" {
  name              = var.toolchain_name
  resource_group_id = data.ibm_resource_group.toolchain_resource_group.id
}

resource "ibm_cd_toolchain_tool_hostedgit" "app_repo_integration_instance" {
  toolchain_id = ibm_cd_toolchain.toolchain_instance.id
  initialization {
    type         = "new_if_not_exists"
    repo_name    = var.app_repo_name
    private_repo = false
  }
  parameters {
    enable_traceability       = false
    toolchain_issues_enabled  = false
  }
}

resource "gitlab_repository_file" "index_html" {
  project        = "${ibm_cd_toolchain_tool_hostedgit.app_repo_integration_instance.parameters[0].owner_id}/${ibm_cd_toolchain_tool_hostedgit.app_repo_integration_instance.parameters[0].repo_name}"
  file_path      = "index.html"
  branch         = "main"
  content        = filebase64("${path.module}/html/index.html")
  commit_message = "add index.html"
}

resource "ibm_cd_toolchain_tool_pipeline" "pipeline_integration_instance" {
  toolchain_id = ibm_cd_toolchain.toolchain_instance.id
  parameters {
    name = var.pipeline_name
  }
}

resource "ibm_cd_tekton_pipeline" "pipeline_instance" {
  pipeline_id = split("/", ibm_cd_toolchain_tool_pipeline.pipeline_integration_instance.id)[1]
  worker {
    id = "public"
  }
}

resource "ibm_cd_toolchain_tool_hostedgit" "pipeline_repo_integration_instance" {
  toolchain_id = ibm_cd_toolchain.toolchain_instance.id
  initialization {
    type      = "link"
    repo_url  = local.pipeline_repo_url
  }
  parameters {
    enable_traceability       = false
    toolchain_issues_enabled  = false
  }
}

resource "ibm_cd_tekton_pipeline_definition" "tekton_pipeline_definition" {
  pipeline_id = ibm_cd_tekton_pipeline.pipeline_instance.id
  source {
    type = "git"
    properties {
      branch  = var.pipeline_branch
      path    = var.pipeline_folder
      url     = local.pipeline_repo_url
    }
  }
}

resource "ibm_cd_tekton_pipeline_trigger" "tekton_pipeline_trigger" {
  pipeline_id = ibm_cd_tekton_pipeline.pipeline_instance.id
  type           = "scm"
  name           = "grit commit trigger"
  event_listener = "commit-listener"
  source {
    type = "git"
    properties {
      url     = ibm_cd_toolchain_tool_hostedgit.app_repo_integration_instance.parameters[0].repo_url
      branch  = "main"
    }
  }
  events = [ "push" ]
}

resource "ibm_cd_tekton_pipeline_property" "tekton_pipeline_property_repo_url" {
    pipeline_id = ibm_cd_tekton_pipeline.pipeline_instance.id
    name        = "git-repo-url"
    type        = "text"
    value       = ibm_cd_toolchain_tool_hostedgit.app_repo_integration_instance.referent[0].ui_href
}

resource "ibm_cd_tekton_pipeline_property" "tekton_pipeline_property_apikey" {
    pipeline_id = resource.ibm_cd_tekton_pipeline.pipeline_instance.id
    name        = "iam-api-key"
    type        = "secure"
    value       = var.ibmcloud_api_key
}

resource "ibm_cd_tekton_pipeline_property" "tekton_pipeline_property_bucket_name" {
    pipeline_id = resource.ibm_cd_tekton_pipeline.pipeline_instance.id
    name        = "bucket-name"
    type        = "text"
    value       = var.cos_bucket_name
}

resource "ibm_cd_tekton_pipeline_property" "tekton_pipeline_property_cos_instance" {
    pipeline_id = resource.ibm_cd_tekton_pipeline.pipeline_instance.id
    name        = "cos-instance-id"
    type        = "text"
    value       = var.cos_bucket_instance_id
}

resource "ibm_cd_tekton_pipeline_property" "tekton_pipeline_property_s3_endpoint" {
    pipeline_id = resource.ibm_cd_tekton_pipeline.pipeline_instance.id
    name        = "s3-endpoint"
    type        = "text"
    value       = var.s3_endpoint_public
}

resource "ibm_cd_tekton_pipeline_property" "tekton_pipeline_property_iam_endpoint" {
    pipeline_id = resource.ibm_cd_tekton_pipeline.pipeline_instance.id
    name        = "ibmcloud-iam-endpoint"
    type        = "text"
    value       = var.ibmcloud_iam_endpoint
}

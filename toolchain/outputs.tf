output "git_repo_url" {
    value = ibm_cd_toolchain_tool_hostedgit.app_repo_integration_instance.referent[0].ui_href
}
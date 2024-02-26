terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "~>1.59"
    }
    gitlab = {
      source = "gitlabhq/gitlab"
      version = "16.3.0"
    }
  }

  required_version = ">= 1.4.6"
}
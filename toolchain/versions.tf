terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "1.50.0"
    }
    gitlab = {
      source = "gitlabhq/gitlab"
      version = "3.15.1"
    }
  }

  required_version = ">= 1.2.6"
}
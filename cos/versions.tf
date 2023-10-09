terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "1.50.0"
    }
  }

  required_version = ">= 1.2.6, <1.6.0"
}
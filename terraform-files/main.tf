provider "ibm" {
  bluemix_api_key    = "${var.ibm_bx_api_key}"
  softlayer_username = "${var.ibm_sl_username}"
  softlayer_api_key  = "${var.ibm_sl_api_key}"
}


data "ibm_resource_group" "rg" {
  name = "${var.resource_group}"
}

data "ibm_org" "org" {
  org = "${var.cf_org}"
}

data "ibm_space" "space" {
  org   = "${var.cf_org}"
  space = "${var.cf_space}"
}

data "ibm_account" "account" {
  org_guid = "${data.ibm_org.org.id}"
}
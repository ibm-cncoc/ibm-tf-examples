# Cloud Object Storage
resource "ibm_resource_instance" "cos" {
  name              = "${var.pfx}-${var.cos_name}"
  service           = "cloud-object-storage"
  plan              = "${var.cos_plan}"
  location          = "${var.cos_location}"
  tags              = ["${var.tags}"]
  resource_group_id = "${data.ibm_resource_group.rg.id}"
  parameters = {
    "HMAC" = true
  }
}

#create resource key for COS
resource "ibm_resource_key" "cos-resourceKey" {
  name                 = "${ibm_resource_instance.cos.name}-key"
  role                 = "Reader"
  resource_instance_id = "${ibm_resource_instance.cos.id}"
  parameters = {
    "HMAC" = true
  }

  //User can increase timeouts 
  timeouts {
    create = "15m"
    delete = "15m"
  }
}

locals {
  apikey = "${lookup(ibm_resource_key.cos-resourceKey.credentials,"apikey")}"
}

output "cos-creds" {
value = "${ibm_resource_key.cos-resourceKey.credentials}"
sensitive = true
}

output "cos_instance_name" {
    value = "${ibm_resource_instance.cos.name}"
}
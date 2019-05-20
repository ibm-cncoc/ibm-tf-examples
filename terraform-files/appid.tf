resource "ibm_resource_instance" "appid" {
  name              = "${var.pfx}-${var.appid_name}"
  service           = "appid"
  plan              = "graduated-tier"
  location          = "${var.region}"
  tags              = ["${var.tags}"]
  resource_group_id = "${data.ibm_resource_group.rg.id}"
  provisioner "local-exec" {
    command = "sh scripts/appid.sh"
    environment {
      APIKEY = "${var.ibm_bx_api_key}"
      EMAIL = "${var.appid_user["email"]}"
      PASSWORD = "${var.appid_user["password"]}"
      FIRST = "${var.appid_user["first"]}"
      LAST = "${var.appid_user["last"]}"
      TENANT = "${ibm_resource_instance.appid.id}"
      DOMAIN = "${lower(var.cluster_name)}.${var.region}.containers.appdomain.cloud/appid_callback"
      CLUSTER = "${ibm_container_cluster.cluster.name}"
      CLUSTER_NAMESPACE = "${local.active-namespace}" 
    }
  }
  depends_on        =
  [
    "ibm_container_cluster.cluster"
  ]
}
output "AppID-instance-name" {
 value         =  "${ibm_resource_instance.appid.name}"
 description   =  "AppID instance created"
}
output "AppID-instance-CRN" {
 value         =  "${ibm_resource_instance.appid.id}"
 description   =  "AppID instance created"
  
 }


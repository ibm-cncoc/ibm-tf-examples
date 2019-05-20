resource "ibm_resource_instance" "logdnaat" {
  name              = "${var.pfx}-at-${var.logdnaat["name"]}"
  service           = "logdnaat"
  plan              = "${var.logdnaat["plan"]}"
  location          = "${var.region}"
  resource_group_id = "${data.ibm_resource_group.rg.id}"
  tags              = ["${var.tags}"]

  provisioner "local-exec" {
    command = "ibmcloud cs logging-config-create --cluster ${ibm_container_cluster.cluster.name} --logsource kube-audit --org '${var.cf_org}' --space ${var.cf_space}"
  }

}


output "logDNA-AT-instance" {
  value = "${ibm_resource_instance.logdnaat.name}"
  description = "Created logDNA-AT instance"
}
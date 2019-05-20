resource "ibm_container_cluster" "cluster" {
  name              = "${var.cluster_name}"
  region            = "${var.region}"
  datacenter        = "${var.zones[0]}"
  resource_group_id = "${data.ibm_resource_group.rg.id}"

  private_vlan_id = "${element(local.private_vlan_ids,0)}"
  public_vlan_id  = "${element(local.public_vlan_ids,0)}"

  hardware          = "shared"
  machine_type      = "u2c.2x4"
  default_pool_size = 1
  disk_encryption   = true
  kube_version      = "${var.kube_version}"
  billing           = "${var.billing}"
  tags              = ["${var.tags}"]

  depends_on = [
    "ibm_network_vlan.private_vlan_new",
    "ibm_network_vlan.public_vlan_new",
    "ibm_resource_instance.key_protect"
  ]

provisioner "local-exec" {
    command = "bash scripts/keyprotect.sh"
    environment {
      APIKEY = "${var.ibm_bx_api_key}"
      KEYPROTECT = "${ibm_resource_instance.key_protect.id}"
      KEY_NAME = "${ibm_resource_instance.key_protect.name}-key"
      KEY_DESCRIPTION = "${var.keyprotect["description"]}"
      KEY_PAYLOAD = "${var.keyprotect["payload"]}"
      CLUSTER = "${ibm_container_cluster.cluster.name}"
      REGION = "${var.region}"
    }
  }
  provisioner "local-exec" {
    command = "ibmcloud ks logging-config-create ${ibm_container_cluster.cluster.id} --logsource worker --type ibm"
  }

  provisioner "local-exec" {
    command = "ibmcloud ks logging-config-create ${ibm_container_cluster.cluster.id} --logsource kubernetes --type ibm"
  }

  provisioner "local-exec" {
    command = "ibmcloud ks logging-config-create ${ibm_container_cluster.cluster.id} --logsource ingress --type ibm"
  }
}

data "ibm_container_cluster_config" "ibmcluster_config" {
  account_guid      = "${data.ibm_account.account.id}"
  cluster_name_id   = "${ibm_container_cluster.cluster.name}" # Use cluster name. Using "id" may give errors while initializing the kube provider, because "id" is a computed value
  config_dir        = "./"
  download          = true
  resource_group_id = "${data.ibm_resource_group.rg.id}"
}

locals {
  cluster_config_path = "${data.ibm_container_cluster_config.ibmcluster_config.config_dir}${sha1("${data.ibm_container_cluster_config.ibmcluster_config.cluster_name_id}")}_${data.ibm_container_cluster_config.ibmcluster_config.cluster_name_id}_k8sconfig/config.yml"
}

output "cluster-config-path" {
  value = "${data.ibm_container_cluster_config.ibmcluster_config.config_file_path}"
  description = "Path of cluster config file"
}

output "cluster-name" {
  value = "${data.ibm_container_cluster_config.ibmcluster_config.cluster_name_id}"
   description = "Name of IKS cluster created"
}

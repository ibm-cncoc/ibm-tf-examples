resource "ibm_resource_instance" "sysdig" {
  name              = "${var.pfx}-${var.sysdig["name"]}"
  service           = "sysdig-monitor"
  plan              = "${var.sysdig["plan"]}"
  location          = "${var.region}"
  resource_group_id = "${data.ibm_resource_group.rg.id}"
  tags              = ["${var.tags}"]
}

resource "ibm_resource_key" "sysdig_resourceKey" {
  name                 = "${ibm_resource_instance.sysdig.name}-key"
  role                 = "Administrator"
  resource_instance_id = "${ibm_resource_instance.sysdig.id}"

  //User can increase timeouts 
  timeouts {
    create = "15m"
    delete = "15m"
  }
}

locals {
  sysdig_access_key = "${replace(lookup(ibm_resource_key.sysdig_resourceKey.credentials, "Sysdig Access Key"), "/((.|\n)*)Sysdig Access Key = (.*)((.|\n)*)/", "$3")}"
  sysdig_ingestion_endpoint = "${replace(lookup(ibm_resource_key.sysdig_resourceKey.credentials, "Sysdig Endpoint"), "/((.|\n)*)Sysdig Endpoint = (.*)((.|\n)*)/", "$3")}"
}

resource "null_resource" "sysdig_agent_install" {
  provisioner "local-exec" {
    command = "chmod +x ./scripts/sysdig.sh && ./scripts/sysdig.sh"

    environment {
      CONFIG    = "${local.cluster_config_path}"
      ACCESS_KEY    = "${local.sysdig_access_key}"
      INGESTION_ENDPOINT    = "${local.sysdig_ingestion_endpoint}"
      NAMESPACE = "${var.sysdig["namespace"]}"
    }
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "chmod +x ./scripts/sysdig-destroy.sh && ./scripts/sysdig-destroy.sh"

    environment {
      CONFIG    = "${local.cluster_config_path}"
      NAMESPACE = "${var.sysdig["namespace"]}"
    }
  }

  depends_on        =
  [
    "ibm_resource_key.sysdig_resourceKey"
  ]
}

output "sysdig_instance_name" {
  value = "${ibm_resource_instance.sysdig.name}"
  description = "Created Sysdig instance"
}
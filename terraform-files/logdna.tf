
resource "ibm_resource_instance" "logdna" {
  name              = "${var.pfx}-${var.logdna["name"]}"
  service           = "logdna"
  plan              = "${var.logdna["plan"]}"
  location          = "${var.region}"
  resource_group_id = "${data.ibm_resource_group.rg.id}"
  tags              = ["${var.tags}"]
}

resource "ibm_resource_key" "logdna_resourceKey" {
  name                 = "${ibm_resource_instance.logdna.name}-key"
  role                 = "Administrator"
  resource_instance_id = "${ibm_resource_instance.logdna.id}"

  //User can increase timeouts 
  timeouts {
    create = "15m"
    delete = "15m"
  }
}

locals {
    logdna_service_key = "${replace(lookup(ibm_resource_key.logdna_resourceKey.credentials, "ingestion_key"), "/((.|\n)*)ingestion_key = (.*)((.|\n)*)/", "$3")}"
}

resource "null_resource" "logdna_agent_install" {
  provisioner "local-exec" {
    command = "bash ./scripts/logdna.sh"

    environment {
      CONFIG    = "${local.cluster_config_path}"
      SERVICE_KEY    = "${local.logdna_service_key}"
    }
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "bash ./scripts/logdna-destroy.sh"

    environment {
      CONFIG    = "${local.cluster_config_path}"
    }
  }

  depends_on        =
  [
    "ibm_resource_key.logdna_resourceKey"
  ]
}

output "logDNA-instance" {
  value = "${ibm_resource_instance.logdna.name}"
  description = "Created logDNA instance"
}
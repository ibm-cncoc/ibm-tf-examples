
resource "null_resource" "insights_agent" {
  provisioner "local-exec" {
    command = "sh ./scripts/sa-agents.sh"

    environment {
      CONFIG            =   "${local.cluster_config_path}"
      AT_REGION         =   "${var.region}"
      ACCOUNT_API_KEY   =   "${var.ibm_bx_api_key}"
      SPACE_GUID        =   "${data.ibm_space.space.id}"
      COS_REGION        =   "${var.region}"
      COS_API_KEY       =   "${local.apikey}"
    }
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "sh ./scripts/sa-destroy.sh"

    environment {
      CONFIG = "${local.cluster_config_path}"
    }
  }
depends_on = [
    "null_resource.helm_setup"
  ]

}
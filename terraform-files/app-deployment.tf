resource "helm_release" "application_chart" {
  name       = "${var.app_deployment_chart["name"]}"
  repository = "${var.app_deployment_chart["repository"]}"
  chart      = "${var.app_deployment_chart["chart"]}"
  namespace  = "${local.active-namespace}"
  timeout    = 600

  # Values to pass in: label, appid.bindSecret, ingress.host, postgres, namespace
  set {
    name = "label"
    value = "${lower(var.app_label)}"
  }
  set {
    name = "appid.bindSecret"
    value = "binding-${lower(ibm_resource_instance.appid.name)}"
  }
  set {
    name = "ingress.host"
    value = "${ibm_container_cluster.cluster.ingress_hostname}"
  }
  set {
    name = "namespace"
    value = "${local.active-namespace}"
  }

  set {
    name = "postgres.host"
    value = "${ibm_database.postgresql.connectionstrings.0.hosts.0.hostname}"
  }

  set {
    name = "postgres.db"
    value = "${var.postgres_db}"
  }

  set {
    name = "postgres.port"
    value = "${ibm_database.postgresql.connectionstrings.0.hosts.0.port}"
  }
  set {
    name = "postgres.user"
    value = "${var.postgres_user}"
  }
  set {
    name = "postgres.password"
    value = "${var.postgres_user_pwd}"
  }
  depends_on = [
    "null_resource.certmanger_ready_delay"
  ]
}

output "application_helm_chart" {
  value = "${helm_release.application_chart.name}"
  description = "Deployed Helm chart name for application"
}
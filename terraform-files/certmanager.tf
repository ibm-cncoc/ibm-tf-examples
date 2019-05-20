resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "${helm_repository.jetstack.metadata.0.name}"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  timeout  = 600
  depends_on = [
    "null_resource.helm_setup",
    "null_resource.create_certmanager-crds"
  ]

 # Remove certmanager CRDs on destroy
  provisioner "local-exec" {
    when    = "destroy"
    command = "sh ./scripts/certmanager-destroy.sh"

    environment {
      CONFIG = "${local.cluster_config_path}"
    }
  }

}

resource "null_resource" "certmanger_ready_delay" {
  provisioner "local-exec" {
    command = "sleep 30"
  }

  depends_on = [
    "helm_release.cert-manager",
  ]
}

resource "null_resource" "create_certmanager-crds" {
  provisioner "local-exec" {
    command = "sleep 30"
  }
   # Execute the certmanager crds script before certmanager chart is installed
  provisioner "local-exec" {
    command = "sh ./scripts/certmanager.sh"

    environment {
      CONFIG = "${local.cluster_config_path}"
    }
  }

 

}
output "certmanager_helm_chart" {
  value = "${helm_release.cert-manager.name}"
  description = "Deployed Helm chart name for cert manager"
}
provider "kubernetes" {
  config_path = "${local.cluster_config_path}"
}

resource "kubernetes_namespace" "iks-namespace" {
  metadata {
    name = "${var.iks_namespace}"
  }

  provisioner "local-exec" {
    command = "sh ./scripts/namespace.sh"

    environment {
      CONFIG    = "${local.cluster_config_path}"
      NAMESPACE = "${kubernetes_namespace.iks-namespace.metadata.0.name}"
    }
  }
}

output "created-iks-namespace" {
  value = "${kubernetes_namespace.iks-namespace.metadata.0.name}"
}

locals {
  active-namespace = "${kubernetes_namespace.iks-namespace.metadata.0.name}"
}

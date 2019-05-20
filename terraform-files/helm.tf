resource "null_resource" "helm_setup" {
  provisioner "local-exec" {
    command = "sh ./scripts/helm.sh" # Creates Service account and Cluster Role binding

    environment {
      CONFIG = "${local.cluster_config_path}"
    }
  }
  provisioner "local-exec" {
    when    = "destroy"
    command = "sh ./scripts/helm-destroy.sh"

    environment {
      CONFIG = "${local.cluster_config_path}"
    }
  }
}

# Service account and Cluster Role binding are created through `helm.sh` file

provider "helm" {
  namespace       = "kube-system"
  install_tiller  = true
  service_account = "tiller"
  #enable_tls = true
  tiller_image = "gcr.io/kubernetes-helm/tiller:v2.11.0" # Make sure your helm client and server versions match
  kubernetes {
    config_path = "${local.cluster_config_path}"
  }
}

resource "helm_repository" "ibm" {
  name = "ibm"
  url  = "https://registry.bluemix.net/helm/ibm"
}

resource "helm_repository" "ibm-charts" {
  name = "ibm-charts"
  url  = "https://registry.bluemix.net/helm/ibm-charts"
}

resource "helm_repository" "jetstack" {
  name = "jetstack"
  url  = "https://charts.jetstack.io"
}

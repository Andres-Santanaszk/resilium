data "aws_eks_cluster_auth" "eks_auth" {
  name = data.aws_eks_cluster.eks.name
}

resource "kubernetes_namespace_v1" "wazuh_ns" {
  metadata {
    name = "wazuh-daemonset"
  }
}

# Terraform crea el Secret dentro de ese Namespace
resource "kubernetes_secret_v1" "wazuh_authd_pass" {
  metadata {
    name      = "wazuh-authd-pass"
    namespace = kubernetes_namespace_v1.wazuh_ns.metadata[0].name
  }

  data = {
    # La llave exacta que busca el YAML oficial
    "authd.pass" = var.wazuh_password
  }

  type = "Opaque"
}
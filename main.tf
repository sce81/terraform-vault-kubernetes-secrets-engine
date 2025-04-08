resource "vault_kubernetes_secret_backend" "config" {
  namespace                 = var.namespace
  path                      = var.path
  description               = var.description
  default_lease_ttl_seconds = var.default_lease_ttl_seconds
  max_lease_ttl_seconds     = var.max_lease_ttl_seconds
  kubernetes_host           = var.kubernetes_host
  kubernetes_ca_cert        = base64decode(var.kubernetes_ca_cert)
  service_account_jwt       = var.token
  disable_local_ca_jwt      = var.disable_local_ca_jwt
}

resource "vault_kubernetes_secret_backend_role" "role" {
  namespace                 = var.namespace
  backend                       = vault_kubernetes_secret_backend.config.path
  name                          = "service-account-${var.namespace}-role"
  allowed_kubernetes_namespaces = [var.namespace]
  token_max_ttl                 = 43200
  token_default_ttl             = 21600
  service_account_name          = "${var.namespace}-service-account-with-generated-token"

  extra_labels = {
    id   = "abc123"
    name = "some_name"
  }

  extra_annotations = {
    env      = "development"
    location = "earth"
  }
}
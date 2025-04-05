data "aws_ecr_authorization_token" "ecr_token" {}

resource "kubernetes_secret" "ecr_secret" {
  metadata {
    name      = "regcred"
    namespace = "default"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = base64encode(jsonencode({
      auths = {
        "${data.aws_ecr_authorization_token.ecr_token.proxy_endpoint}" = {
          username = data.aws_ecr_authorization_token.ecr_token.user_name
          password = data.aws_ecr_authorization_token.ecr_token.password
          email    = "none"
        }
      }
    }))
  }
}

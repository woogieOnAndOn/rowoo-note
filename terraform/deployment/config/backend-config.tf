bucket                      = "terraform-states-woogie"
key                         = "deployment.tfstate"
region                      = "ap-northeast-2"
encrypt                     = true
dynamodb_table              = "terraform-deploy"
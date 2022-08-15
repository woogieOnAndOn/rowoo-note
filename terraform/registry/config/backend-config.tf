bucket                      = "terraform-states-woogie"
key                         = "ci-cd-example.tfstate"
region                      = "ap-northeast-2"
encrypt                     = true
dynamodb_table              = "terraform-locks"
terraform {
  required_providers {
    split = {
      source = "davidji99/split"
      version = "0.10.1"
    }
  }
}
provider "split" {
  api_key = "API_KEY"
}


data "split_workspace" "default" {
  name = "Default"
}


data "split_traffic_type" "account" {
  workspace_id = data.split_workspace.default.id
  name = "account"
}

resource "split_segment" "strategic_accounts" {
  workspace_id = data.split_workspace.default.id
  traffic_type_id = data.split_traffic_type.account.id
  name = "strategic_accounts"
  description = "created by terraform"
}

resource "split_segment_environment_association" "strategic_accounts_prod" {
    workspace_id = data.split_workspace.default.id
    environment_id = data.split_environment.prod_default.id
    segment_name = split_segment.strategic_accounts.name
}

data "split_environment" "prod_default" {
  workspace_id = data.split_workspace.default.id
  name = "Prod-Default"
}

# resource "split_environment" "demo_env" {
#   workspace_id = data.split_workspace.default.id
#   name = "new_test_env"
#   production = false
# }

# resource "split_traffic_type" "foobar" {
#   workspace_id = data.split_workspace.default.id
#   name = "my_traffic_type"
# }

resource "split_split" "new_tf_split" {
  workspace_id = data.split_workspace.default.id
  traffic_type_id = data.split_traffic_type.account.id
  name = "my_tf_split"
  description = "my tf split description"
}

resource "split_split_definition" "tf_split_definition" {
  depends_on = [
    split_segment_environment_association.strategic_accounts_prod
  ]
  workspace_id = data.split_workspace.default.id
  split_name = split_split.new_tf_split.name
  environment_id = data.split_environment.prod_default.id
  default_treatment = "treatment_123"
  treatment {
    name = "treatment_123"
    configurations = "{\"key\":\"value\"}"
    description = "my treatment 123"
    keys = ["key1", "key2"]

  }
  treatment {
    name = "treatment_456"
    configurations = "{\"key2\":\"value2\"}"
    description = "my treatment 456"
    segments = ["strategic_accounts"]
  }

  default_rule {
    treatment = "treatment_123"
    size = 100
  }
  rule {
    bucket {
      treatment = "treatment_123"
      size = 100
    }
    condition {
      combiner = "AND"
      matcher {
        type = "EQUAL_SET"
        attribute = "test_string"
        strings = ["test_string_val1", "test_string_val_2"]
      }
    }
  }
}

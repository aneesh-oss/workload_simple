provider "newrelic" {
  account_id = var.new_relic_account_id
  api_key = var.new_relic_api_key
  region = var.new_relic_region
}

data "newrelic_entity" "APM_name" {
  name   = var.entity_name
  type   = "APPLICATION"
  domain = "APM"
}

resource "newrelic_entity_tags" "APM_tags" {
  count = length(var.entity_tags)
  guid  = data.newrelic_entity.APM_name.guid

  tag {
    key    = var.entity_tags[count.index].key
    values = [var.entity_tags[count.index].value]
  }
}

resource "newrelic_workload" "APM_workload" {
  name       = var.workload_name
  account_id = var.new_relic_account_id

  entity_guids = [data.newrelic_entity.APM_name.guid]

  entity_search_query {
    query = "tags.environment = 'testing' AND tags.owner='user'"
  }

  scope_account_ids = [var.new_relic_account_id]
}

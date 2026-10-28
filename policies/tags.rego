package main

import rego.v1

taggable := {
	"azurerm_resource_group",
	"azurerm_key_vault",
	"azurerm_mssql_server",
	"azurerm_mssql_database",
}

required_tags := {"project", "owner", "cost_center"}

tags_of(after) := after.tags if {
	is_object(after.tags)
} else := {}

deny contains msg if {
	some rc in input.resource_changes
	rc.type in taggable
	some action in rc.change.actions
	action in {"create", "update"}
	tags := tags_of(rc.change.after)
	some t in required_tags
	object.get(tags, t, "") == ""
	msg := sprintf("[TAGS] %s: falta el tag '%s' o esta vacio", [rc.address, t])
}

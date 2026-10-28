package main

import rego.v1

deny contains msg if {
	some rc in input.resource_changes
	rc.type == "azurerm_mssql_firewall_rule"
	"create" in rc.change.actions
	rc.change.after.start_ip_address == "0.0.0.0"
	rc.change.after.end_ip_address == "255.255.255.255"
	msg := sprintf("[RED] %s abre el servidor SQL a todo Internet", [rc.address])
}

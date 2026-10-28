variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "admin_login" { type = string }

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "databases" {
  type = map(object({ sku_name = string }))
}

variable "tags" {
  type = map(string)
  validation {
    condition = alltrue([
      for k in ["project", "owner", "cost_center"] : lookup(var.tags, k, "") != ""
    ])
    error_message = "tags debe incluir project, owner y cost_center no vacios."
  }
}

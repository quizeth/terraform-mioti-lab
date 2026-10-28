variable "subscription_id" { type = string }
variable "environment" { type = string }
variable "location" { type = string }
variable "owner" { type = string }
variable "cost_center" { type = string }

variable "project" {
  type    = string
  default = "mioti"
}

variable "sql_location" {
  type    = string
  default = null
}

variable "unique_suffix" {
  type = string
  validation {
    condition     = can(regex("^[a-z0-9]{4,8}$", var.unique_suffix))
    error_message = "unique_suffix: 4-8 caracteres, minusculas y digitos."
  }
}

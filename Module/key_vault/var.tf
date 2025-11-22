variable "kv_name" {
  description = "The name of the Key Vault."
  type = string
  default = "dudhwkdnk"
}
variable "kv_location" {
  description = "The location where the Key Vault will be created."
  type        = string
}
variable "rg_name" {
    description = "The name of the resource group where the Key Vault will be created."
    type        = string
}
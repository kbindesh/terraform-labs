variable "azure-subscription-id" {
  type = string
  description = "Azure SubscriptionId"
}

variable "azure-client-secret" {
  type = string
  description = "Azure Client Secret"
}

variable "azure-tenant-id" {
  type = string
  description = "Azure AD Tenant ID"
}

variable "azure-client-id" {
  type = string
  description = "Client ID"
}

variable "vm_admin_password" {
  type = string
  description = "VM Password"
}

variable "rg_name" {
  type = string
  description = "Rresource Group"
}

variable "vm_hostname_computername" {
  type = string
  description = "Minikube-hostname"
}
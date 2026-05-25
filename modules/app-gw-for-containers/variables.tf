variable "name" {
  description = "Name of the Application Gateway for Containers resource."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where Application Gateway for Containers will be created."
  type        = string
}

variable "frontend_name" {
  description = "Name of the Application Gateway for Containers frontend."
  type        = string
}

variable "association_name" {
  description = "Name of the Application Gateway for Containers subnet association."
  type        = string
}

variable "association_subnet_id" {
  description = "ID of the delegated subnet used by Application Gateway for Containers."
  type        = string
}

variable "tags" {
  description = "Tags to apply."
  type        = map(string)
  default     = {}
}

variable "alb_identity_name" {
  description = "Name of the user-assigned managed identity for ALB Controller."
  type        = string
}

variable "aks_oidc_issuer_url" {
  description = "AKS OIDC issuer URL for Workload Identity federation."
  type        = string
}

variable "aks_node_resource_group_name" {
  description = "AKS managed node resource group name."
  type        = string
}

variable "alb_controller_namespace" {
  description = "Kubernetes namespace where ALB Controller will run."
  type        = string
  default     = "azure-alb-system"
}

variable "alb_controller_service_account_name" {
  description = "Kubernetes service account used by ALB Controller."
  type        = string
  default     = "alb-controller-sa"
}

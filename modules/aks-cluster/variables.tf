variable "name" {
  description = "Name of the AKS cluster."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where AKS will be created."
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "AKS Kubernetes version. Null lets Azure choose the default."
  type        = string
  default     = null
}

variable "default_node_pool_name" {
  description = "Name of the default node pool."
  type        = string
  default     = "agentpool"
}

variable "subnet_id" {
  description = "Subnet ID for the AKS default node pool."
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the default node pool."
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "VM size for AKS nodes."
  type        = string
  default     = "Standard_D2s_v3"
}

variable "tags" {
  description = "Tags to apply."
  type        = map(string)
  default     = {}
}

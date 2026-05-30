output "name" {
  description = "AKS cluster name."
  value       = azurerm_kubernetes_cluster.this.name
}

output "id" {
  description = "AKS cluster ID."
  value       = azurerm_kubernetes_cluster.this.id
}

output "kubelet_identity_object_id" {
  description = "Object ID of the AKS kubelet identity."
  value       = one(azurerm_kubernetes_cluster.this.kubelet_identity).object_id
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL for AKS Workload Identity."
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
}

output "node_resource_group" {
  description = "AKS managed node resource group."
  value       = azurerm_kubernetes_cluster.this.node_resource_group
}

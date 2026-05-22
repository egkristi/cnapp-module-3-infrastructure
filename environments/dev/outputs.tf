output "resource_group_name" {
  description = "Created resource group name."
  value       = module.resource_group.name
}

output "key_vault_name" {
  description = "Key Vault name."
  value       = module.key_vault.name
}

output "key_vault_uri" {
  description = "Key Vault URI."
  value       = module.key_vault.vault_uri
}

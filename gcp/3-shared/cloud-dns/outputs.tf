output "hub_name_servers" {
  description = "Hub Zone name servers."
  value       = module.dns-forwarding-zone-hub.name_servers
}

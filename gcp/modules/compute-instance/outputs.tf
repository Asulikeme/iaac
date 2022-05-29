output "compute_instances" {
  description = "The created compute instance(s)"
  value       = google_compute_instance.compute
}

output "compute_instance_disks" {
  description = "The created compute instance disk(s)"
  value       = google_compute_disk.attached_disks
}

output "compute_instance_group" {
  description = "The created compute instance group"
  value       = google_compute_instance_group.instance_group
}
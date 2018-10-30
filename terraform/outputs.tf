output "app_external_ip: app" {
  value = "${google_compute_instance.app.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "app_external_ip: app-2" {
  value = "${google_compute_instance.app-2.network_interface.0.access_config.0.assigned_nat_ip}"
}


output "app_balancer_ip" {
  value = "${google_compute_global_forwarding_rule.app_url_rule.ip_address}"
}
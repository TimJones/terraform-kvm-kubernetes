module "configuration" {
  source = "git::https://github.com/autonomy/terraform-talos-configuration"

  talos_ca_crt = "${module.security.talos_ca_crt}"
  talos_ca_key = "${module.security.talos_ca_key}"

  trustd_username  = "${module.security.trustd_username}"
  trustd_password  = "${module.security.trustd_password}"
  trustd_endpoints = "${data.template_file.master_name.*.rendered}"

  kubernetes_token  = "${module.security.kubeadm_token}"
  kubernetes_ca_crt = "${module.security.kubernetes_ca_crt}"
  kubernetes_ca_key = "${module.security.kubernetes_ca_key}"

  master_hostnames                   = "${data.template_file.master_name.*.rendered}"
  container_network_interface_plugin = "${var.kubernetes_cni_plugin}"
  cluster_name                       = "${var.cluster_name}"
  dns_domain                         = "${var.cluster_domain}"
  pod_subnet                         = "${var.pod_subnet}"
  service_subnet                     = "${var.service_subnet}"
}

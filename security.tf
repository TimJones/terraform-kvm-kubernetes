module "security" {
  source = "git::https://github.com/autonomy/terraform-talos-security"

  talos_target  = "${libvirt_domain.master.0.name}"
  talos_context = "${var.cluster_name}"
}

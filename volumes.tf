resource "null_resource" "rootfs" {
  provisioner "local-exec" {
    command = "${var.override_root_image_file != "" ? "echo 'Skipping download'" : "curl -L https://github.com/autonomy/talos/releases/download/${var.talos_release}/image.raw.xz | xz --decompress > ${path.module}/image.raw"}"
  }
}

resource "libvirt_volume" "kernel" {
  source = "${var.override_vmlinuz_file != "" ? var.override_vmlinuz_file : "https://github.com/autonomy/talos/releases/download/${var.talos_release}/vmlinuz"}"
  name   = "kernel"
  format = "raw"
}

resource "libvirt_volume" "initramfs" {
  source = "${var.override_initramfs_file != "" ? var.override_initramfs_file : format("https://github.com/autonomy/talos/releases/download/%s/initramfs.xz", var.talos_release)}"
  name   = "initramfs"
  format = "raw"
}

resource "libvirt_volume" "base" {
  source = "${var.override_root_image_file != "" ? var.override_root_image_file : "${path.module}/image.raw"}"
  name   = "base"
  format = "raw"

  depends_on = ["null_resource.rootfs"]
}

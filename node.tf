resource "libvirt_cloudinit_disk" "node" {
  name      = "node.iso"
  user_data = "${module.configuration.worker}"
}

resource "libvirt_volume" "node" {
  count = "${var.node_count}"
  name  = "${var.cluster_name}-node-${count.index+1}"

  base_volume_id = "${libvirt_volume.base.id}"
  format         = "qcow2"
  size           = "${var.node_disk_size}"
}

resource "libvirt_domain" "node" {
  count = "${var.node_count}"
  name  = "${var.cluster_name}-node-${count.index+1}"

  cloudinit = "${libvirt_cloudinit_disk.node.id}"

  vcpu   = "${var.node_cpus}"
  memory = "${var.node_memory}"
  kernel = "${libvirt_volume.kernel.id}"
  initrd = "${libvirt_volume.initramfs.id}"

  boot_device {
    dev = ["hd", "network"]
  }

  disk {
    volume_id = "${element(libvirt_volume.node.*.id, count.index)}"
  }

  cpu {
    mode = "host-passthrough"
  }

  network_interface {
    network_name = "${var.libvirt_network}"
  }

  cmdline {
    "console"                    = "tty0"
    "console"                    = "ttyS0,9600"
    "ip"                         = "dhcp"
    "consoleblank"               = "0"
    "nvme_core.io_timeout"       = "4294967295 "
    "talos.autonomy.io/userdata" = "cidata"
    "talos.autonomy.io/platform" = "bare-metal"
    "page_poison"                = "1"
    "pti"                        = "on"
    "printk.devkmsg"             = "on"
    "_"                          = "slab_nomerge"
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_port = "1"
    target_type = "virtio"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

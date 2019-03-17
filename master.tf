data "template_file" "master_name" {
  count    = "${var.master_count}"
  template = "${var.cluster_name}-master-${count.index+1}"
}

resource "libvirt_cloudinit_disk" "master" {
  count     = "${var.master_count}"
  name      = "master-${count.index}.iso"
  user_data = "${module.configuration.masters[count.index]}"
}

resource "libvirt_volume" "master" {
  count = "${var.master_count}"
  name  = "${var.cluster_name}-master-${count.index+1}"

  base_volume_id = "${libvirt_volume.base.id}"
  format         = "qcow2"
  size           = "${var.master_disk_size}"
}

resource "libvirt_domain" "master" {
  count = "${var.master_count}"
  name  = "${element(data.template_file.master_name.*.rendered, count.index)}"

  cloudinit = "${element(libvirt_cloudinit_disk.master.*.id, count.index)}"

  vcpu   = "${var.master_cpus}"
  memory = "${var.master_memory}"
  kernel = "${libvirt_volume.kernel.id}"
  initrd = "${libvirt_volume.initramfs.id}"

  boot_device {
    dev = ["hd", "network"]
  }

  disk {
    volume_id = "${element(libvirt_volume.master.*.id, count.index)}"
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

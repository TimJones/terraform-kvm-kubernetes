# terraform-kvm-kubernetes

Talos is a modern Linux distribution build for Kubernetes. https://talos.autonomy.io

This is a Terraform module to install a Talos Kubernetes cluster on a KVM hostwith libvirt.

## Variables

### Required

| Name | Description | Example |
| --- | --- | --- |
| cluster_name | Unique cluster name | "bronze" |
| kubernetes_cni_plugin | Kubernetes Container Network Interface plugin | "flannel" or "calico" |

### Optional

| Name | Description | Default | Example |
| --- | --- | --- | --- |
| cluster_domain | The cluster's DNS domain | "cluster.local" | "k8s.example.com" |
| pod_subnet | The CIDR block used for pods | "10.2.0.0/16" | "172.16.1.0/24" |
| service_subnet | The CIDR block used for Kubernetes services | "10.3.0.0/16" | "172.16.2.0/24" |
| talos_release | Release of Talos to use | "v0.1.0-alpha.18" | "v0.1.0-alpha.15" |
| libvirt_network | Name of the libvirt netowkr interface to use | "default" | "virbr0" |
| master_count | Number of masters | 1 | 3 |
| master_cpus | Number of CPUs to assign to the masters | 2 | 4 |
| master_memory | Amount of memory in MiB to assign to the masters | 2048 | 8192 |
| master_disk_size | Size of the master disk in bytes | 10000000000 (10GB) | 30000000000 |
| node_count | Number of nodes | 1 | 5 |
| node_cpus | Number of CPUs to assign to the nodes | 2 | 8 |
| node_memory | Amount of memory in MiB to assign to the nodes | 2048 | 16384 |
| node_disk_size | Size of the node disk in bytes | 50000000000 (50GB) | 100000000000 |
| override_vmlinuz_file |Use the provided file instead of downloading the vmlinuz file. Overrides 'talos_release' | "" | "./build/custom-vmlinuz" |
| override_initramfs_file | Use the provided file instead of downloading the initramfs file. Overrides 'talos_release' | "" |  "./build/custom-initramfs.xz" |
| override_root_image_file | "Use the provided file instead of downloading the root image file. Overrides 'talos_release' | "" | "./build/custom-image.raw" |

## Example

```
provider "libvirt" {
  version = "~> 0.5.1"
  alias = "default"
  uri = "qemu:///system"
}

provider "random" {
  version = "~> 2.0"
  alias = "default"
}

provider "template" {
  version = "~> 2.0"
  alias = "default"
}

provider "tls" {
  version = "~> 1.2"
  alias = "default"
}

module "talos_libvirt_bronze" {
  source = "../terraform-kvm-kubernetes"

  providers = {
    libvirt = "libvirt.default"
    random = "random.default"
    template = "template.default"
    tls = "tls.default"
  }

  cluster_name = "bronze"
  kubernetes_cni_plugin = "flannel"
  libvirt_network = "virbr0"
  master_count = 1
  node_count = 2
}

output "talos_admin_config" {
  value = "${module.talos_libvirt_bronze.talos_admin_config}"
}
```

variable "cluster_name" {
  description = "Unique cluster name"
  type        = "string"
}

variable "kubernetes_cni_plugin" {
  description = "Kubernetes Container Network Interface plugin"
  type        = "string"
}

variable "cluster_domain" {
  description = "The cluster's DNS domain (e.g. cluster.local)"
  type        = "string"
  default     = "cluster.local"
}

variable "pod_subnet" {
  description = "The CIDR block used for pods"
  type        = "string"
  default     = "10.2.0.0/16"
}

variable "service_subnet" {
  description = "The CIDR block used for Kubernetes services"
  type        = "string"
  default     = "10.3.0.0/16"
}

variable "talos_release" {
  description = "Release of Talos to use"
  type        = "string"
  default     = "v0.1.0-alpha.18"
}

variable "libvirt_network" {
  description = "Name of the libvirt netowkr interface to use"
  type        = "string"
  default     = "default"
}

variable "master_count" {
  description = "Number of masters"
  type        = "string"
  default     = "1"
}

variable "master_cpus" {
  description = "Number of CPUs to assign to the masters"
  type        = "string"
  default     = "2"
}

variable "master_memory" {
  description = "Amount of memory in MiB to assign to the masters"
  type        = "string"
  default     = "2048"
}

variable "master_disk_size" {
  description = "Size of the master disk in bytes"
  type        = "string"
  default     = "10000000000"
}

variable "node_count" {
  description = "Number of nodes"
  type        = "string"
  default     = "1"
}

variable "node_cpus" {
  description = "Number of CPUs to assign to the nodes"
  type        = "string"
  default     = "2"
}

variable "node_memory" {
  description = "Amount of memory in MiB to assign to the nodes"
  type        = "string"
  default     = "2048"
}

variable "node_disk_size" {
  description = "Size of the node disk in bytes"
  type        = "string"
  default     = "50000000000"
}

variable "override_vmlinuz_file" {
  description = "Use the provided file instead of downloading the vmlinuz file. Overrides 'talos_release'."
  type        = "string"
  default     = ""
}

variable "override_initramfs_file" {
  description = "Use the provided file instead of downloading the initramfs file. Overrides 'talos_release'."
  type        = "string"
  default     = ""
}

variable "override_root_image_file" {
  description = "Use the provided file instead of downloading the root image file. Overrides 'talos_release'."
  type        = "string"
  default     = ""
}

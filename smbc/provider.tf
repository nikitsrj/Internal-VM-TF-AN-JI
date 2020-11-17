provider "vsphere" {
    vsphere_server = "10.68.32.2"
    user = "administrator@vsphere.local"
    password = var.vsphere_passwd
    allow_unverified_ssl = "true"
}

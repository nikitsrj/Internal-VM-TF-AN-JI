data "vsphere_datacenter" "dc" {
  name = "KBT-DC"
}
module "SNGP1VLDSBOC01" {
  source                 = "../terraform-vsphere-vm"
  dc                     = "KBT-DC"
  network_cards          = ["KBT-DPG-VL32"]
  ipv4 = {
    "KBT-DPG-VL32" = ["10.68.32.123"]
  }
  ipv4submask            = ["24"]
  vmdns                  = ["8.8.8.8"]
  vmgateway              = "10.68.32.1"
  vmrp                   = "nikit-smbc-poc"
  vmfolder               = "nicksrj"
  disk_datastore         = "VNX-LUN8"
  cpu_number             = 4
  ram_size               = 4096
  # cpu_hot_add_enabled    = "true"
  # cpu_hot_remove_enabled = "true"
  # memory_hot_add_enabled = "true"
  vmdomain               = "somedomain.com"
  vmnameliteral          = "SNGP1VLDSBOC01"
  # data_disk_scsi_controller  = [0, 3]
  # data_disk_datastore        = ["vsanDatastore", "nfsDatastore"]
  data_disk_size_gb = [
  10, 
  5, 
  ]

  thin_provisioned  = [
  "true",
  "true"
  ]
  tags = {
    "VM_Type"    = "DB"
    }
  vmtemp            = "${var.linux_temp}"
 }
resource "null_resource" "SNGP1VLDSBOC01" {
  depends_on = [module.SNGP1VLDSBOC01]
  provisioner "local-exec" {
    command = "sleep 20 && ansible-playbook postprovisioning.yaml -i 10.68.32.123, -e  'ansible_user=root ansible_password=${var.linux_temp_passwd} ansible_ssh_common_args=\"'\"-o StrictHostKeyChecking=no\"'\"' -vvv"
    interpreter = ["/bin/bash", "-c"]
  }
 }
module "SNGP2VWWSWOC02" {
  source                 = "../terraform-vsphere-vm"
  dc                     = "KBT-DC"
  network_cards          = ["KBT-DPG-VL32"]
  ipv4 = {
    "KBT-DPG-VL32" = ["10.68.32.125"]
  }
  ipv4submask            = ["24"]
  vmdns                  = ["8.8.8.8"]
  vmgateway              = "10.68.32.1"
  vmrp                   = "nikit-smbc-poc"
  vmfolder               = "nicksrj"
  disk_datastore         = "VNX-LUN9"
  cpu_number             = 4
  ram_size               = 6144
  # cpu_hot_add_enabled    = "true"
  # cpu_hot_remove_enabled = "true"
  # memory_hot_add_enabled = "true"
  vmdomain               = "somedomain.com"
  vmnameliteral          = "SNGP2VWWSWOC02"
  # data_disk_scsi_controller  = [0, 3]
  # data_disk_datastore        = ["vsanDatastore", "nfsDatastore"]
  data_disk_size_gb = [
  10, 
  5, 
  ]

  thin_provisioned  = [
  "true",
  "true"
  ]
  tags = {
    "VM_Type"    = "WebServer"
    }
  scsi_type = "lsilogic-sas"
  scsi_controller = 0
  vmtemp            = "${var.windows_temp}"
  enable_disk_uuid = "true"
  auto_logon       = "true"
  run_once         = ["powershell -Command echo 'Get-Disk | Where-Object PartitionStyle -eq RAW | Initialize-Disk -PartitionStyle GPT -PassThru | New-Partition -AssignDriveLetter -UseMaximumSize | Format-Volume -FileSystem NTFS -Confirm:$false' > C:\\format-mount.ps1",  "powershell -ExecutionPolicy Unrestricted -File C:\\format-mount.ps1 -Schedule"] 
  # orgname          = "Terraform-Module"
  # workgroup        = "terraform-Test"
  is_windows_image = "true"
  # windomain             = "Development.com"
  # domain_admin_user     = "Domain admin user"
  # domain_admin_password = "SomePassword"
  firmware         = "efi"
  local_adminpass  = "${var.windows_temp_passwd}"
}


variable "compartment_id" {
  description = "The OCID of the root compartment where resources will be created."
  type        = string
}

variable "vcn_id" {
  description = "The OCID of the existing VCN to use."
  type        = string
  default     = "ocid1.vcn.oc1.iad.amaaaaaattqdboqaihrijho75k376cmitl4ss5quf5xbp4mlgdizndm7shfa"
}

############################################
# Public Subnet, Route Table, and Internet Gateway
############################################

variable "subnetA_pub" {
  description = "The details of the subnet"
  default = {
    cidr_block : "10.0.11.0/24"
    display_name : "IC_pub_snet-A"
    is_public : true
    route_table : {
      display_name = "routeTable-Apub"
      description  = "routeTable-Apub"
    }
  }
}

variable "internet_gateway_A" {
  description = "The details of the internet gateway"
  default = {
    display_name : "Internet Gateway vcn-20250929-1433"
    ig_destination = "0.0.0.0/0"
  }
}

############################################
# Compute Instance
############################################

data "oci_identity_availability_domain" "ad_3" {
  compartment_id = var.compartment_id
  ad_number      = 3
}

data "oci_core_images" "arm_oracle_linux" {
  compartment_id   = var.compartment_id
  operating_system = "Oracle Linux"
  shape            = "VM.Standard.E2.1.Micro"
  sort_by          = "TIMECREATED"
  sort_order       = "DESC"
}

variable "ic_pub_vm_A" {
  description = "The details of the compute instance"
  default = {
    display_name : "IC_pub_vm-A"
    assign_public_ip : true
    shape : {
      name          = "VM.Standard.E2.1.Micro"
      ocpus         = 1
      memory_in_gbs = 1
    }
    ssh_authorized_keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDWwzz6lWBXdGxbrmxlmxaqjAWD32eM26a5vc3/7dwoPFzeZzB9zDq1ywZI/QVqxLuLcqXB4VhM3Fr8+mK1dUEsioZ/JpBLiJeUh58Q6cIOTQ5srJyn4rw9vWrcHR9xm53E2poXX9UtDje6a5LaDrFBv63CS9POB8PQgIJaG39K2UMZwh+x2OMn8mXGCMKdUythKLapnvNCNtFQC2clU7SRY2ArIvr1j/09raVvKdvjoY5Aw3Rc+V1EFlkO/XooSZt9vnoZ9xtI8OkDFFmtZAhwCEVO8vV4V+uZVU9Wi+O37NZmvNe+SYiEeLwTB0n4BRmsfv5QRHIjbW2f2t07n0Ta4P/7ywYApvlUVUGe/9oqXZXxkiumq/va/0IAoGv95eq8ouBy81PHM3dtCWuNR4mYUT3JKdLNFcWbCDaSx1iW+UCgH57wSwDszfPvxUGodUNQpJSsNw+1MTSBgyxXIR3r3ex+q3F9N5a5AEsgZeFAk71V8QTn5VK8SNk3n/Smgbs= oracle-vm"]
  }
}
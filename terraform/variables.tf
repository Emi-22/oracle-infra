variable "compartment_id" {
  description = "The OCID of the compartment where resources will be created."
  type        = string
}

variable "compartment_name" {
  description = "The name of the compartment where resources will be created."
  type        = string
}

variable "compartment_description" {
  description = "Compartment Description"
  type        = string
  default     = "test-compartment description"
}

############################################
# VCN
############################################

variable "vcn1" {
  description = "The details of VCN1."
  default = {
    cidr_blocks : ["10.23.0.0/20"]
    display_name : "vcn01"
  }
}

############################################
# Public Subnet, Route Table, and Internet Gateway
############################################

variable "subnetA_pub" {
  description = "The details of the subnet"
  default = {
    cidr_block : "10.23.11.0/24"
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
    display_name : "IC_IG-A"
    ig_destination = "0.0.0.0/0"
  }
}

############################################
# Compute Instance
############################################

data "oci_identity_availability_domain" "ad_1" {
  compartment_id = var.compartment_id
  ad_number      = 1
}

data "oci_core_images" "arm_oracle_linux" {
  compartment_id   = var.compartment_id
  operating_system = "Oracle Linux"
  shape            = "VM.Standard.A1.Flex"
  sort_by          = "TIMECREATED"
  sort_order       = "DESC"
}

variable "ic_pub_vm_A" {
  description = "The details of the compute instance"
  default = {
    display_name : "IC_pub_vm-A"
    assign_public_ip : true
    shape : {
      name          = "VM.Standard.A1.Flex"
      ocpus         = 1
      memory_in_gbs = 8
    }
    ssh_authorized_keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCuzY9AR7LiJN8EhHeG3qP9gWuf7IxUl+xDaf1gD/zvZjid4Uxa8fRjWkAkeRQGa1ZNBLjw7EH+zWpjqOlCg14eZqTUnNtmOzIfK/LmcSFNKmD2rGNryY8DQBH5cY94bZVasOA+lhxnaNOzJ0sDGrqeCrpqTWqGWZ2NZ/nxXSXTdescHYcz/lmEijRLGnxtI/ByWKufowPUQm9gA0x+DRqJk9mvT7i1ZHi9djbeVPJPZthn14Ppi5cjLIXtCrxTQUcALaCPkzcgAKen9KHlmNRfoW+hx8fRxC0RPZgYCAigqz3hktsnjr+n4pxkF+5e55ZJJYdAKQnaYbS5SVzegC9jNzyzxef8JmZqtrgTBo4dsvNdbw7iIn0/KGgK3xZNTR55L60kS4y4NPbVNhRey8ESjIRc2zoBycssLmVd8cp0a0iLdjXDH3PGLgfC0Ly3Tv7lmGLd27c3U7ndN6ldXxFJ9k7B9k6EibyoaQJM0fLX4eug1tGa6BaB3dwEyZgSUuM= fdurrani@AJTV3VGQF2.local"]
  }
}
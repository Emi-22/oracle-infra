removed {
  from = oci_identity_compartment.example_compartment

  lifecycle {
    destroy = false
  }
}

removed {
  from = oci_core_vcn.example_vcn

  lifecycle {
    destroy = false
  }
}

removed {
  from = oci_core_internet_gateway.the_internet_gateway

  lifecycle {
    destroy = false
  }
}

data "oci_core_vcn" "existing" {
  vcn_id = var.vcn_id
}

data "oci_core_internet_gateways" "existing" {
  compartment_id = var.compartment_id
  display_name   = var.internet_gateway_A.display_name
  vcn_id         = data.oci_core_vcn.existing.id
  state          = "AVAILABLE"
}

############################################
# Public Subnet
############################################

resource "oci_core_subnet" "subnetA_pub" {
  compartment_id             = var.compartment_id
  vcn_id                     = data.oci_core_vcn.existing.id
  cidr_block                 = var.subnetA_pub.cidr_block
  display_name               = var.subnetA_pub.display_name
  prohibit_public_ip_on_vnic = !var.subnetA_pub.is_public
  security_list_ids          = [data.oci_core_vcn.existing.default_security_list_id]
}

############################################
# Internet Gateways and NAT Gateways
############################################

############################################
# Route Tables
############################################

resource "oci_core_default_route_table" "the_route_table" {
  #Required
  compartment_id             = var.compartment_id
  manage_default_resource_id = data.oci_core_vcn.existing.default_route_table_id
  # Optional
  display_name = var.subnetA_pub.route_table.display_name
  dynamic "route_rules" {
    for_each = [true]
    content {
      destination       = var.internet_gateway_A.ig_destination
      description       = var.subnetA_pub.route_table.description
      network_entity_id = data.oci_core_internet_gateways.existing.gateways[0].id
    }
  }
}

# ############################################
# # Compute Instance
# ############################################

resource "oci_core_instance" "ic_pub_vm-A" {
  compartment_id      = var.compartment_id
  shape               = var.ic_pub_vm_A.shape.name
  availability_domain = data.oci_identity_availability_domain.ad_1.name
  display_name        = var.ic_pub_vm_A.display_name

  source_details {
    source_id   = data.oci_core_images.arm_oracle_linux.images[0].id
    source_type = "image"
  }

  shape_config {
    #Optional
    memory_in_gbs = var.ic_pub_vm_A.shape.memory_in_gbs
    ocpus         = var.ic_pub_vm_A.shape.ocpus
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.subnetA_pub.id
    assign_public_ip = var.ic_pub_vm_A.assign_public_ip
  }

  metadata = {
    ssh_authorized_keys = join("\n", [for k in var.ic_pub_vm_A.ssh_authorized_keys : chomp(k)])
  }
}
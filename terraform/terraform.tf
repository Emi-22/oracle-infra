terraform {
    required_providers {
        oci = {
            source  = "hashicorp/oci"
            version = "~> 5.0.0"
        }
    }
}

terraform {
    backend "http" {
        address = "https://objectstorage.us-ashburn-1.oraclecloud.com/p/KYH8dTmqo6bxF2BYYE0jZlbNE5bOua7x4o5Qv9Wi_q4gZjzLeNwx5dHl2SVPOQ1A/n/idtbr6xqalxc/b/terraform_bucket/o/terraform.tfstate"
        update_method = "PUT"
    }
}


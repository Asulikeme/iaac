variable project_id {
    type = string
    default = "helpful-beach-350222"
}

variable location {
    type = string
    default = "US"
}

variable storage_class {
    type = string
    default = "MULTI_REGIONAL"
}


# Network
variable region {
    type = string
    default = "us-east4"
}

variable "network_name" {
    type = string
    default = "custom-vpc"
}
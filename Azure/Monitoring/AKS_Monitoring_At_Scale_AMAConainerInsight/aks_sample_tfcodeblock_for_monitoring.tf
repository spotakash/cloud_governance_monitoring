resource "azurerm_resource_group" "name" {
    name     = "${var.resource_group_name}"
    location = "${var.location}" 
}

resource "azurerm_kubernetes_cluster" "name" {
    name                = "${var.cluster_name}"
    location            = "${azurerm_resource_group.name.location}"
    resource_group_name = "${azurerm_resource_group.name.name}"
    dns_prefix          = "${var.dns_prefix}"
    linux_profile {
        admin_username = "${var.admin_username}"
        ssh_key {
            key_data = "${file("${var.ssh_public_key_path}")}"
        }
    }
    ### Block to be enabled for Container Insight Monitoring
    oms_agent {
        enabled                    = "${var.oms_agent_enabled}"
        log_analytics_workspace_id = "${var.log_analytics_workspace_id}"
    }
    ###
    agent_pool_profile {
        name            = "${var.agent_pool_name}"
        count           = "${var.agent_pool_count}"
        vm_size         = "${var.agent_pool_vm_size}"
        os_type         = "${var.agent_pool_os_type}"
        os_disk_size_gb = "${var.agent_pool_os_disk_size_gb}"
    }
    service_principal {
        client_id     = "${var.client_id}"
        client_secret = "${var.client_secret}"
    }
    tags {
        Environment = "Production"
    } 
}
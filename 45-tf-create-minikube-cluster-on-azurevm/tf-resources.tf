resource "azurerm_resource_group" "minikube_rg" {
  name     = var.rg_name
  location = "East US"
}

resource "azurerm_virtual_network" "minikube_vnet" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.minikube_rg.location
  resource_group_name = azurerm_resource_group.minikube_rg.name
}

resource "azurerm_subnet" "minikube_subnet_1" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.minikube_rg.name
  virtual_network_name = azurerm_virtual_network.minikube_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "minikube_ip" {
  depends_on=[azurerm_resource_group.minikube_rg]

  name                = "${var.rg_name}-IP"
  location            = azurerm_resource_group.minikube_rg.location
  resource_group_name = azurerm_resource_group.minikube_rg.name
  allocation_method   = "Static"
  
}

resource "azurerm_network_interface" "minikube_vm_interface" {
  depends_on=[azurerm_public_ip.minikube_ip]
  name                = "example-nic"
  location            = azurerm_resource_group.minikube_rg.location
  resource_group_name = azurerm_resource_group.minikube_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.minikube_subnet_1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.minikube_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "Minikube_Cluster"
  resource_group_name = azurerm_resource_group.minikube_rg.name
  location            = azurerm_resource_group.minikube_rg.location
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  admin_password      = var.vm_admin_password
  computer_name       = var.vm_hostname_computername
  custom_data         = base64encode(data.template_file.linux-vm-cloud-init.rendered)

  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.minikube_vm_interface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7_9-gen2"
    version   = "latest"
  }
}
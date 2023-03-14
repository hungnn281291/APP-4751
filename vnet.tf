# Create a resource group
resource "azurerm_resource_group" "tcg-npae-a4751-rg001" {
  name     = "nerdio-prod-rg"
  location = "australiaeast"
}

resource "azurerm_resource_group" "tcg-npae-shared-private_dns-rg001" {
  name     = "nerdio-prod-privatedns-rg"
  location = "australiaeast"
}

# Create a virtual network
resource "azurerm_virtual_network" "tcg-npae-a4751-vnet001" {
  name                = "tcg-npae-a4751-vnet001"
  address_space       = ["10.219.0.0/16"]
  location            = azurerm_resource_group.tcg-npae-a4751-rg001.location
  resource_group_name = azurerm_resource_group.tcg-npae-a4751-rg001.name
}

# Create a route table
resource "azurerm_route_table" "tcg-npae-a4751-rt001" {
  name                = "tcg-npae-a4751-rt001"
  location            = azurerm_resource_group.tcg-npae-a4751-rg001.location
  resource_group_name = azurerm_resource_group.tcg-npae-a4751-rg001.name
}

# Add a default route to route all traffic to the internet
resource "azurerm_route" "All-Traffic" {
  name                   = "All-Traffic"
  resource_group_name    = azurerm_resource_group.tcg-npae-a4751-rg001.name
  route_table_name       = azurerm_route_table.tcg-npae-a4751-rt001.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "Internet"
}

# Define subnets
resource "azurerm_subnet" "AzurePrivateEndpoint" {
  name                 = "AzurePrivateEndpoint"
  resource_group_name  = azurerm_resource_group.tcg-npae-a4751-rg001.name
  virtual_network_name = azurerm_virtual_network.tcg-npae-a4751-vnet001.name
  address_prefix       = "10.219.192.32/27"
  route_table_id       = azurerm_route_table.tcg-npae-a4751-rt001.id
}

resource "azurerm_subnet" "tcg-npae-a4751-snet001" {
  name                 = "tcg-npae-a4751-snet001"
  resource_group_name  = azurerm_resource_group.tcg-npae-a4751-rg001.name
  virtual_network_name = azurerm_virtual_network.tcg-npae-a4751-vnet001.name
  address_prefix       = "10.219.192.0/27"
  route_table_id       = azurerm_route_table.tcg-npae-a4751-rt001.id
}

# Create a network security group
resource "azurerm_network_security_group" "tcg-npae-a4751-nsg001" {
  name                = "tcg-npae-a4751-nsg001"
  location            = azurerm_resource_group.tcg-npae-a4751-rg001.location
  resource_group_name = azurerm_resource_group.tcg-npae-a4751-rg001.name

  # Define inbound security rules
  security_rule {
    name                       = "allow-all-inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Define outbound security rules
  security_rule {
    name                       = "allow-all-outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate the NSG with a subnet
resource "azurerm_subnet_network_security_group_association" "tcg-npae-a4751-nsgassociation-001" {
  subnet_id                 = azurerm_subnet.tcg-npae-a4751-snet001.id
  network_security_group_id = azurerm_network_security_group.tcg-npae-a4751-nsg001.id
}


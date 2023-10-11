module "rg" {
  source = "../../modules/rg"
  rg_name   = "${var.enviroment}-${var.project}-rg"
  az_region = var.location
  tags      = var.tags
}

module "virtual-network" {
  source = "../../modules/virtual-network"

  vnet_name      = "${var.enviroment}-${var.project}-vnet"
  resource_group = module.rg
  address_space  = var.address_space
  subnets        = var.subnets
  subnet_prefix  = "${var.enviroment}-${var.project}-subnet-"
  tags = var.tags

  depends_on = [module.rg]
}

module "nsg" {
  source         = "../../modules/nsg"
  name           = "${var.enviroment}-${var.project}-nsg"
  resource_group = module.rg
  subnets     = module.virtual-network.vnet_subnets
  tags           = var.tags
  depends_on = [module.rg, module.virtual-network]
}

module "nat_gw" {
  source = "../../modules/nat-gw"

  env             = var.enviroment
  service         = "nat-gw"
  resource_suffix = var.project
  subnets     = module.virtual-network.vnet_subnets
  resourcegroup = module.rg

  tags = var.tags
}


module "nsg_extra_rules" {
  source         = "../../modules/nsg/az-security-rule"
  resource_group = module.rg
  nsg_name       = module.nsg.nsg_name
  custom_rules = [
    {
      name                         = "HTTP"
      priority                     = 320
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      destination_port_range       = "80"
      source_address_prefix        = "*"
      destination_address_prefix   = "*"
    },
    {
      name                         = "HTTPS"
      priority                     = 340
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      destination_port_range       = "443"
      source_address_prefix        = "*"
      destination_address_prefix   = "*"
    },
    {
      name                       = "AllowAnyMySQLInbound"
      description                = "MySQL Inbound"
      access                     = "Allow"
      direction                  = "Inbound"
      priority                   = 350
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      destination_port_range     = "3306"
      destination_address_prefix = "*"
    }
  ]
}

module "route-table" {
  source         = "../../modules/route-table"
  name           = "${var.enviroment}-${var.project}-rt"
  resource_group = module.rg
  subnets        = module.virtual-network.vnet_subnets
  tags           = var.tags
  depends_on = [module.rg, module.virtual-network]
}


module "key-vault" {
  source              = "../../modules/keyvault"
  name                = "${var.enviroment}-${var.project}-kv"
  resource_group      = module.rg
  purge_protection    = false
  tags                = var.tags  
}

module "app-service" {
  count               = length(local.app_services)
  source              = "../../modules/appservice"
  domain_name         = module.mssqlserver.domain_name
  resourcegroup       = module.rg
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  appservicename      = "${lower(local.app_services[count.index].kind)}-appservice"
  appserviceplanname  = "${lower(local.app_services[count.index].kind)}-appservice-plan"
  sql_db_name         = var.sql_db_name
  tier                = local.app_services[count.index].sku.tier
  size                = local.app_services[count.index].sku.size
  kind                = local.app_services[count.index].kind
  depends_on          = [module.rg, module.mssqlserver]
}

module "mssqlserver" {
  source              = "../../modules/mssql"
  resourcegroup       = module.rg
  sql_server_name     = "${var.enviroment}-${var.project}-msssql"
  sql_db_name         = var.sql_db_name
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  depends_on = [module.rg, module.virtual-network]
}
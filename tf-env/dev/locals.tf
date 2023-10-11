locals {
  app_services = [
    {
      kind = "Linux"
      sku = {
        tier = "Standard"
        size = "S1"
      }
    },
    {
      kind = "Windows"
      sku = {
        tier = "Basic"
        size = "B1"
      }
    }
  ]
}
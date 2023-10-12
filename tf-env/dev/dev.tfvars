#Common Information
enviroment   = "dev"
project		   = "miz"
location     = "West US"

#Subscription
subscriptions = {
  "main"          = "9"   #Use sunscription id
}

#virtual network
address_space = ["10.11.0.0/16"]
subnets = {
"01" = "10.11.16.0/20",
"02" = "10.11.32.0/20",
"03" = "10.11.48.0/20"
}

#Tags
tags = {
 environment = "dev" 
}

#MSSQL
admin_username = "mizadmin"
admin_password = "MYVunXNw5cJuc8AH" #need to fetch from azure KV
sql_db_name    = "testdb"
#Appservice
appservice_count=1



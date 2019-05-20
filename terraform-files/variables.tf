variable ibm_bx_api_key {
  description = "IBM Cloud user API key"
}
variable ibm_sl_username {
  description = "Provide Softlayer user name if you are provisioning any infrastructure "
}
variable ibm_sl_api_key {
  description = "Provide Softlayer API key if you are provisioning any infrastructure "
}

variable "region" {
  type        = "string"
  description = "ibm cloud region (Eg: us-south,us-east etc..)"
}

variable "resource_group" {
  type        = "string"
  description = "ibm cloud resoure group"
  default     = "default"
}

variable "cf_org" {
  type        = "string"
  description = "ibm cloud cf org name"
}

variable "cf_space" {
  type        = "string"
  description = "ibm cloud cf space"
}

variable "billing" {
  type        = "string"
  description = "billing type"
  default     = "hourly"
}

variable "pfx" {
  type        = "string"
  description = "name prefix for resources created by this plan (This helps you identify the resources created using this plan)"
}

variable "tags" {
  type        = "list"
  description = "Tags for service"
  default     = ["terraform", "test"]
}

############ IKS Cluster #########
variable "zones" {
  type        = "list"
  description = "provide a list of zones in provided region (Workers on your IKS cluster will be distributed accross the zones you provide here)"
  
}

variable "cluster_name" {
  type        = "string"
  description = "iks cluster name"
}

variable "kube_version" {
  type        = "string"
  description = "kube version"
  default     = "1.13.6"
}

############# VLANs ###############
variable "create_private_vlan" {
  description = "Do want to create new VLANs. If yes, enter 'true'; otherwise, enter 'false'"
}

variable "create_public_vlan" {
  description = "Do want to create new VLANs. If yes, enter 'true'; otherwise, enter 'false'"
}

variable "public_vlan" {
  type = "map"
  description = "If you chose not to create VLANs, provide a list of public vlans on the zones your workers are distributed on (the list of vlans you provide here should have a one to one mapping with the zones list). Eg: If you provide the vlan map to be {ids = [\"1111\",\"2222\"] router_hostnames = [\"fcr01a\"]} and your zones are [dal12,dal10] vlan 1111 should belong to dal12 and 2222 should belong to dal10"

  default {
    ids              = ["-1"]
    router_hostnames = ["xyz"]
  }
}

variable "private_vlan" {
  type = "map"
 description = "If you chose not to create VLANs, provide a list of private vlans on the zones your workers are distributed on (the list of vlans you provide here should have a one to one mapping with the zones list). Eg: If you provide the vlan map to be {ids = [\"1111\",\"2222\"] router_hostnames = [\"fcr01a\"]} and your zones are [dal12,dal10] vlan 1111 should belong to dal12 and 2222 should belong to dal10"
  default {
    ids              = ["-1"]
    router_hostnames = ["xyz"]
  }
}

############## Worker Pools ############
variable "worker_pools_num" {
  type    = "string"
  description = "Enter the number of additional worker pools you want to create. (Enter 0 if you only need the default pool created)"
  default = "0"
}

variable "worker_pool_params" {
  type = "map"
  description = "This is a map for the worker specs. Each key in the map has list of values. The list of length should typically be the number of additional worker pools created. Element 'i' in each list corresponds to worker pool 'i'. Eg: if the provided 'worker_pools_num' is 2, and the key 'workers' has value as a list of [\"2\",\"1\"], that would indicate that number of workers in worker pool1 = 2, and number of workers in worker pool2 = 1 "
  default = {
    tag             = ["small"]   // Name of worker pool will be {pfx}-{tag}-{index}
    machine_flavor  = ["u2c.2x4"] //List of flavors for worker pool you want to create
    hardware        = ["shared"]
    workers         = ["1"]       //List of Num of Workers per zone for each pool. 
    disk_encryption = ["false"]   // Indicate 'True' or 'False' for each zone - "False" is disk enryption is not required. "True" if required
  }
}

######### Key Protect ############
variable "keyprotect" {
  type        = "map"
  description = "key protect instance info"

  default = {
    "name"        = "kps"
    "description" = "root key"

    # Leave payload blank to generate root key. 
    # set payload to BYO-key file with AES 128/192/256 bits
    "payload" = ""
  }
}

########### AppID ##################
variable "appid_name" {
  type        = "string"
  description = "appid instance"
  default     = "appid"
}

variable "appid_user" {
  type = "map"

  default = {
    "first"    = "John"
    "last"     = "Doe"
    "email"    = "jdoe@noemail.com"
    "password" = "passw0rd"
  }
}

########### Application ##########
variable "app_label" {
  type    = "string"
  default = "flask-app-books"
}

variable "app_deployment_chart" {
  type        = "map"
  description = "Helm chart details for application deployment"

  default = {
    repository = "./"                           //path of repository where the charts are stored
    chart      = "flask-books-deployment-chart" //name of the directory in the above path that contains helm chart files
    name       = "flask-books-hdngo-tf"         //name of chart for deployment
  }
}

########### LogDNA ###########
variable "logdna" {
  type = "map"
  description = "LogDNA instance details"

  default = {
    name = "logdna"
    plan = "lite"   //This can also be "lite", "14-day" or "30-day"
  }
}

########### LogDNA AT #########
variable "logdnaat" {
  type = "map"
  description = "LogDNA with ACtivity Tracker instance details"

  default = {
    name = "at-logdna"
    plan = "7-day"     //This can also be "lite", "14-day" or "30-day"
  }
}

########### SysDig #############
variable "sysdig" {
  type = "map"
  description = "Sysdig instance details"

  default = {
    name      = "sysdig"
    plan      = "graduated-tier"
    namespace = "ibm-observe-sysdig"
  }
}

############ IKS Cluster resources ##########
variable "iks_namespace" {
  type = "string"

  #default = "default"
  description = "Provide namespace for app deployment and other service bindings"
}

############## COS ######################
variable "cos_name" {
  type        = "string"
  description = "cloud object storage instance"
  default     = "cos"
}

variable "cos_plan" {
  type        = "string"
  description = "Plan for COS"
  default     = "standard"
}

variable "cos_location" {
  type        = "string"
  description = "Location for COS"
  default     = "global"
}

############# ICD DB ###############
variable "postgres_name" {
  type        = "string"
  description = "ICD postgres instance"
  default     = "postgres"
}

variable "postgres_plan" {
  type        = "string"
  description = "ICD postgres plan"
  default     = "standard"
}

variable "postgres_location" {
  type        = "string"
  description = "ICD postgres location"
  default     = "us-south"
}

variable "postgres_user" {
  type        = "string"
  description = "Enter the user you want to create for your postgres instance"
}

variable "postgres_user_pwd" {
  type        = "string"
  description = "Enter the password for the user you created above (Expected length of password is in range (10 - 32))"
}

variable "postgres_db" {
  type        = "string"
  description = "Enter the name of the database to be created (This is created with a bash script after the postgres instance is provisioned)"
}

############## Message Hub #############
variable "messagehub_name" {
  type        = "string"
  description = "Name of the Message Hub service instance"
  default     = "messagehub"
}

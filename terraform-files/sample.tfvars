ibm_bx_api_key = ""
ibm_sl_username = ""
ibm_sl_api_key  = ""
cf_org = "WDP Customer Success"
region = "us-south"
cf_space = "phoenix"
resource_group = "phoenix"


private_vlan{
        ids = ["1949","2219"]
        router_hostnames = ["bcr01a"]
    }

public_vlan{
        ids = ["1607","1902"]
        router_hostnames = ["fcr01a"]
    }
zones = ["dal12","dal10"]

create_private_vlan = false
create_public_vlan = false


worker_pools_num = 0
worker_pool_params = {
        tag = ["small","medium"] // Name of worker pool will be {pfx}-{tag}-{index}
        machine_flavor = ["u2c.2x4","b2c.4x16"] //List of flavors for worker pool you want to create
        hardware = ["shared","shared"]
        workers  = ["1","1"] //List of Num of Workers per zone for each pool. 
        disk_encryption = ["false","false"]
    }




cluster_name = "tf-test"
iks_namespace = "poojitha"



appid_user = {
    "first"     = "firstname"
    "last"      = "lastname"
    "email"     = "a.b@ibm.com"
    "password"  = "passw0rd"
}

tags = ["TF-test"]
app_label = "application-test-chart"
pfx = "tf-test"


postgres_user   =   "user1"
postgres_user_pwd   =   "password12"
postgres_db =   "test"
postgres_plan   =   "standard"


app_deployment_chart =  {
    repository     = "../flask-app-books/helm" //path of repository relative to this file
    chart      = "flask-books-deployment-chart" //name of the directory in the above path that contains helm chart files
    name        = "flask-books-tf" //name of chart for deployment
  
}

install_cos_storage_plugin = false
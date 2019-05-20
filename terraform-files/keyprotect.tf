resource "ibm_resource_instance" "key_protect" {
  name = "${var.pfx}-${var.keyprotect["name"]}"
  service = "kms"
  plan = "tiered-pricing"
  location = "${var.region}"
  resource_group_id = "${data.ibm_resource_group.rg.id}"
  tags              = ["${var.tags}"]
  

  provisioner "local-exec" {
    when  = "destroy"
    command = "bash scripts/keyprotect-destroy.sh"
    environment {
      APIKEY = "${var.ibm_bx_api_key}"
      KEYPROTECT = "${ibm_resource_instance.key_protect.id}"
      KEY_NAME = "${ibm_resource_instance.key_protect.name}-key"
      KEY_DESCRIPTION = "${var.keyprotect["description"]}"
      KEY_PAYLOAD = "${var.keyprotect["payload"]}"
      REGION = "${var.region}"
    }
  }
  
}

 output "KeyProtect instance" {
 value         =  "${ibm_resource_instance.key_protect.name}"
 description   =  "KeyProtect instance created" 
 }
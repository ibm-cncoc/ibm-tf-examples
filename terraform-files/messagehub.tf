
# Create a Message Hub service
resource "ibm_service_instance" "messagehub" {
  name       = "${var.pfx}-${var.messagehub_name}"
  service    = "messagehub"
  plan       = "standard"
  tags       = ["${var.tags}"]
  space_guid = "${data.ibm_space.space.id}"
}


# Create a service key to allow access to the service.
resource "ibm_service_key" "messagehub-service-key" {
  name = "${ibm_service_instance.messagehub.name}"
  service_instance_guid = "${ibm_service_instance.messagehub.id}"
}

output "Messagehub-instance" {
  value = "${ibm_service_instance.messagehub.name}"
  description = "Created logDNA instance"
}
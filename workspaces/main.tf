module "model" {
   source = "github.com/netascode/terraform-meraki-nac-meraki/modules/model"
   yaml_directories = ["../data"]
   write_model_file = "merged_configuration.nac.yaml"
 }
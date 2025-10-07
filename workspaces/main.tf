module "model" {
   source = "github.com/netascode/terraform-meraki-nac-meraki/modules/model?ref=0.3.4"
   yaml_directories = ["../data"]
   write_model_file = "merged_configuration.nac.yaml"
 }

 
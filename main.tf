module "meraki" {
  source = "github.com/netascode/terraform-meraki-nac-meraki"
  yaml_directories = ["data/"]
}


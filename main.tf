

module "meraki" {
  source           = "github.com/netascode/terraform-meraki-nac-meraki?ref=v0.5.0"
  yaml_directories = ["data"]
}

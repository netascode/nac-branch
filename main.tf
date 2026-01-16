

module "meraki" {
  source           = "github.com/netascode/terraform-meraki-nac-meraki?ref=v0.6.0"
  yaml_directories = ["data"]
}

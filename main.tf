terraform {
  required_providers {
    meraki = {
      source  = "ciscodevnet/meraki"
      version = "= 1.5.0" # Fixed to 1.5.0 untill Port IDs moved to range, PR #1677
     }
  }
}

module "meraki" {
  source = "github.com/netascode/terraform-meraki-nac-meraki"
  yaml_directories = ["data/"]
}
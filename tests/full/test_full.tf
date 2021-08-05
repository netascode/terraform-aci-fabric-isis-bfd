terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "netascode/aci"
      version = ">=0.2.0"
    }
  }
}

module "main" {
  source = "../.."

  admin_state = true
}

data "aci_rest" "l3IfPol" {
  dn = "uni/fabric/l3IfP-default"

  depends_on = [module.main]
}

resource "test_assertions" "l3IfPol" {
  component = "l3IfPol"

  equal "bfdIsis" {
    description = "bfdIsis"
    got         = data.aci_rest.l3IfPol.content.bfdIsis
    want        = "enabled"
  }
}

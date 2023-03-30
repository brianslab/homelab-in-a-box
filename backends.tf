terraform {
  cloud {
    organization = "brianslab"

    workspaces {
      name = "HIAB-dev"
    }
  }
}

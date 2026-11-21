variable "ExemptPrincipalObjectID" {
  description = "Entra object ID allowed to deploy to non-matching location to its resource group's location."
  type        = string
}

variable "ExemptedLocation" {
  description = "Exempted location"
  type        = string
}

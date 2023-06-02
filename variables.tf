variable "force_destroy" {
  type    = bool
  default = true
}

variable "acl" {
  type    = string
  default = "private"
}

variable "tags" {
  type    = map(string)
  default = {}
}
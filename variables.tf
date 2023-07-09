variable "access_key" {
  default = "AKIAS66XK635HUMPHY6D"
}
variable "secret_key" {
  default = "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"

}
variable "region" {
  default = "ap-south-1"

}

variable "vpc_subnet" {
  default = "172.32.0.0/16"

}
variable "projectname" {
  default = "personal"

}

variable "publicsubnet1" {
  default = "172.32.0.0/19"
}

variable "publicsubnet2" {
  default = "172.32.32.0/19"
}
variable "privatesubnet1" {
  default = "172.32.64.0/19"
}

variable "privatesubnet2" {
  default = "172.32.96.0/19"
}
variable "amiid" {
  default = "ami-0f5ee92e2d63afc18"

}

variable "instance_type" {
  default = "t2.micro"
}
variable "keyname" {
  default = "Mumbai-New"

}
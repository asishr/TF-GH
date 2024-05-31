variable "enable_special_characters" {
    type        = bool
    description = "Enables special characters in your password."
    default     = true
}

variable "length" {
    type        = number
    description = "Specifies the length of your password."
    default     = 16
}

resource "random_password" "password" {
    count   = 1
    length  = var.length
    special = var.enable_special_characters
}

output "password" {
    description = "The password is:"
    value       = random_password.password[0].result
    sensitive   = true
}
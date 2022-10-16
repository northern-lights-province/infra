terraform {
  required_providers {
    discord = {
      source  = "Lucky3028/discord"
      version = ">=1.1.0"
    }
  }
}

# ==== inputs ====
variable "channel_id" {
  type = string
}

variable "server_id" {
  type = string
}

variable "permissions" {
  type = number
}

variable "allow_roles" {
  type = list(string)
}

variable "additional_allow" {
  type        = number
  description = "Additional permissions to allow to everyone."
  default     = null
}

# ==== deny everyone ====
data discord_role everyone {
  server_id = var.server_id
  role_id   = var.server_id
}

resource discord_channel_permission deny_everyone {
  channel_id   = var.channel_id
  type         = "role"
  overwrite_id = data.discord_role.everyone.id
  deny         = var.permissions
  allow        = var.additional_allow
}

# ==== allow specified roles ====
resource discord_channel_permission allow_roles {
  for_each     = toset(var.allow_roles)
  channel_id   = var.channel_id
  type         = "role"
  overwrite_id = each.key
  allow        = var.permissions
}
variable "discord_token" {
  type        = string
  description = "Discord Bot token for the server infra bot."
  sensitive   = true
}

variable "owner_id" {
  type        = string
  description = "Discord user ID of the server owner."
  default     = "187421759484592128"
}
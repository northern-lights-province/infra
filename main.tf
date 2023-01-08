terraform {
  required_providers {
    discord = {
      source  = "Lucky3028/discord"
      version = ">=1.1.2"
    }
  }
}

provider discord {
  token = var.discord_token
}

# ===== SERVER =====
resource discord_server nlp {
  name     = "The Northern Lights Province"
  owner_id = var.owner_id
  region   = "us-east"

  verification_level            = 2  # must be registered for 5 minutes or longer
  explicit_content_filter       = 2  # scan all messages
  default_message_notifications = 1  # ping on @ only
}

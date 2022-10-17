terraform {
  required_providers {
    discord = {
      source  = "Lucky3028/discord"
      version = ">=1.1.0"
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

# ===== CHANNELS =====
# ---- RESOURCES ----
resource discord_category_channel resources {
  name      = "Resources"
  server_id = discord_server.nlp.id
}

# only Staff+ are allowed to write in resources
module "resources_permissions" {
  source      = "./limited_channel_permissions"
  server_id   = discord_server.nlp.id
  channel_id  = discord_category_channel.resources.id
  permissions = local.permissions.resource_channel
  allow_roles = [
    discord_role.staff.id,
    discord_role.admin.id
  ]
  additional_allow = local.permissions.view_channel # but everyone is allowed to see resources
}

resource discord_text_channel welcome {
  name                     = "welcome"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.resources.id
  sync_perms_with_category = true
}

# ---- CHAR CREATION ----
resource discord_category_channel character_creation {
  name      = "Character Creation"
  server_id = discord_server.nlp.id
  position  = discord_category_channel.resources.position + 1
}

module "char_creation_permissions" {
  # only Staff+ are allowed to write in char creations
  source      = "./limited_channel_permissions"
  server_id   = discord_server.nlp.id
  channel_id  = discord_category_channel.character_creation.id
  permissions = local.permissions.resource_channel
  allow_roles = [
    discord_role.staff.id,
    discord_role.admin.id
  ]
}

resource discord_text_channel character_creation {
  name                     = "character-creation"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.character_creation.id
  sync_perms_with_category = true
}

# ---- STAFF ----
resource discord_category_channel staff {
  name      = "Staff"
  server_id = discord_server.nlp.id
  position  = discord_category_channel.character_creation.position + 1
}

module "staff_permissions" {
  # only Staff+ are allowed to see staff channels
  source      = "./limited_channel_permissions"
  server_id   = discord_server.nlp.id
  channel_id  = discord_category_channel.staff.id
  permissions = local.permissions.view_channel
  allow_roles = [
    discord_role.staff.id,
    discord_role.admin.id
  ]
}

resource discord_text_channel staff_general {
  name                     = "staff-general"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.staff.id
  sync_perms_with_category = true
}

resource discord_text_channel staff_bot {
  name                     = "staff-bot"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.staff.id
  position                 = discord_text_channel.staff_general.position + 1
  sync_perms_with_category = true
}


# ---- OOC ----
resource discord_category_channel ooc {
  name      = "Out of Character"
  server_id = discord_server.nlp.id
  position  = discord_category_channel.staff.position + 1
}

resource discord_text_channel general {
  name                     = "general"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.ooc.id
  sync_perms_with_category = true
}

resource discord_text_channel bot_test {
  name                     = "bot-test"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.ooc.id
  position                 = discord_text_channel.general.position + 1
  sync_perms_with_category = true
}

# ---- IC ----
# ### CITY OF LIGHTS ###
resource discord_category_channel city {
  name      = "City of Lights"
  server_id = discord_server.nlp.id
  position  = discord_category_channel.ooc.position + 1
}

module "city_of_lights_permissions" {
  # only Players are allowed to write in IC chats
  source      = "./limited_channel_permissions"
  server_id   = discord_server.nlp.id
  channel_id  = discord_category_channel.city.id
  permissions = local.permissions.send_messages
  allow_roles = [discord_role.player.id]
}

resource discord_text_channel gates {
  name                     = "city-gates"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.city.id
  sync_perms_with_category = true
}

resource discord_text_channel tavern {
  name                     = "the-borealis"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.city.id
  position                 = discord_text_channel.gates.position + 1
  sync_perms_with_category = true
}

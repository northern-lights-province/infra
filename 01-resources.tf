# ---- WELCOME ----
resource discord_text_channel welcome {
  name                     = "welcome"
  server_id                = discord_server.nlp.id
  sync_perms_with_category = false
  lifecycle { ignore_changes = [position] }
}

resource discord_news_channel announcements {
  name                     = "announcements"
  server_id                = discord_server.nlp.id
  sync_perms_with_category = false
  position                 = discord_text_channel.welcome.position + 1
}


# ---- RESOURCES ----
resource discord_category_channel resources {
  name      = "Resources"
  server_id = discord_server.nlp.id
  lifecycle { ignore_changes = [position] }
}

resource discord_text_channel character_creation {
  name                     = "character-creation"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.resources.id
  sync_perms_with_category = true
  lifecycle { ignore_changes = [position] }
}

resource discord_text_channel getting_started {
  name                     = "getting-started"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.resources.id
  sync_perms_with_category = true
  position                 = discord_text_channel.character_creation.position + 1
}

resource discord_text_channel rules_in_wild {
  name                     = "wilderness-rules"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.resources.id
  sync_perms_with_category = true
  position                 = discord_text_channel.getting_started.position + 1
}

resource discord_text_channel rules_in_town {
  name                     = "city-and-downtime-rules"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.resources.id
  sync_perms_with_category = true
  position                 = discord_text_channel.rules_in_wild.position + 1
}

resource discord_text_channel house_rules {
  name                     = "house-rules"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.resources.id
  sync_perms_with_category = true
  position                 = discord_text_channel.rules_in_town.position + 1
}

# ---- PERMISSIONS ----
# only Staff+ are allowed to write in welcome
module "welcome_permissions" {
  source      = "./limited_channel_permissions"
  server_id   = discord_server.nlp.id
  channel_id  = discord_text_channel.welcome.id
  permissions = local.permissions.resource_channel
  allow_roles = [
    discord_role.staff.id,
    discord_role.founder.id,
    discord_role.admin.id
  ]
  additional_allow = local.permissions.view_channel # but everyone is allowed to see resources
}

module "announcements_permissions" {
  source      = "./limited_channel_permissions"
  server_id   = discord_server.nlp.id
  channel_id  = discord_news_channel.announcements.id
  permissions = local.permissions.resource_channel
  allow_roles = [
    discord_role.staff.id,
    discord_role.founder.id,
    discord_role.admin.id
  ]
  additional_allow = local.permissions.view_channel # but everyone is allowed to see resources
}

module "resources_permissions" {
  # only Staff+ are allowed to write in resources
  source      = "./limited_channel_permissions"
  server_id   = discord_server.nlp.id
  channel_id  = discord_category_channel.resources.id
  permissions = local.permissions.resource_channel
  allow_roles = [
    discord_role.staff.id,
    discord_role.founder.id,
    discord_role.admin.id
  ]
}

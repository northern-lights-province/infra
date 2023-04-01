# ---- STAFF ----
resource discord_category_channel staff {
  name      = "Staff"
  server_id = discord_server.nlp.id
  position  = discord_category_channel.resources.position + 1
}

module "staff_permissions" {
  # only Staff+ and bots are allowed to see staff channels
  source      = "./limited_channel_permissions"
  server_id   = discord_server.nlp.id
  channel_id  = discord_category_channel.staff.id
  permissions = local.permissions.view_channel
  allow_roles = [
    discord_role.staff.id,
    discord_role.admin.id,
    discord_role.bots.id
  ]
}

# ==== channels ====
resource discord_text_channel staff_resources {
  name                     = "staff-resources"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.staff.id
  sync_perms_with_category = true
  lifecycle { ignore_changes = [position] }
}

resource discord_text_channel staff_general {
  name                     = "staff-general"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.staff.id
  position                 = discord_text_channel.staff_resources.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel staff_bot {
  name                     = "staff-bot"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.staff.id
  position                 = discord_text_channel.staff_general.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel staff_logs {
  name                     = "staff-logs"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.staff.id
  position                 = discord_text_channel.staff_bot.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel staff_logs_verbose {
  name                     = "staff-logs-verbose"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.staff.id
  position                 = discord_text_channel.staff_logs.position + 1
  sync_perms_with_category = true
}

# staff-forum lives here but can't be modeled in terraform

resource discord_text_channel staff_voice_text {
  name                     = "staff-voice-text"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.staff.id
  lifecycle { ignore_changes = [position] }
  sync_perms_with_category = true
}

resource discord_voice_channel staff_voice {
  name      = "staff-nyah-chat"
  server_id = discord_server.nlp.id
  category  = discord_category_channel.staff.id
}

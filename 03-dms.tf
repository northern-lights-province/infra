# ---- DMs ----
resource discord_category_channel dms {
  name      = "Dungeon Masters"
  server_id = discord_server.nlp.id
  position  = discord_category_channel.staff.position + 1
}

module "dm_permissions" {
  # only DM+ and bots are allowed to see DM channels
  source      = "./limited_channel_permissions"
  server_id   = discord_server.nlp.id
  channel_id  = discord_category_channel.dms.id
  permissions = local.permissions.view_channel
  allow_roles = [
    discord_role.dm.id,
    discord_role.staff.id,
    discord_role.bots.id
  ]
}

resource discord_text_channel dm_resources {
  name                     = "dm-resources"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.dms.id
  sync_perms_with_category = true
  lifecycle { ignore_changes = [position] }
}

resource discord_text_channel dm_general {
  name                     = "dm-general"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.dms.id
  position                 = discord_text_channel.dm_resources.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel dm_bot {
  name                     = "dm-bot"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.dms.id
  position                 = discord_text_channel.dm_general.position + 1
  sync_perms_with_category = true
}

# dm-forum lives here but can't be modeled in terraform

resource discord_text_channel dm_voice_text {
  name                     = "dm-voice-text"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.dms.id
  position                 = discord_text_channel.dm_bot.position + 2
  sync_perms_with_category = true
}

resource discord_voice_channel dm_voice {
  name      = "dm-voice"
  server_id = discord_server.nlp.id
  category  = discord_category_channel.dms.id
}
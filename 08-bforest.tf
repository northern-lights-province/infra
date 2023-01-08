# ### BOREAL FOREST ###
resource discord_category_channel bforest {
  name      = "Boreal Forest"
  server_id = discord_server.nlp.id
  position  = discord_category_channel.coast.position + 1
}

module "bforest_permissions" {
  # only Players are allowed to write in IC chats
  source      = "./limited_channel_permissions"
  server_id   = discord_server.nlp.id
  channel_id  = discord_category_channel.bforest.id
  permissions = local.permissions.send_messages
  allow_roles = [discord_role.player.id]
}

resource discord_text_channel bforest_ooc {
  name                     = "boreal-forest-ooc"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.bforest.id
  sync_perms_with_category = true
  lifecycle { ignore_changes = [position] }
}

resource discord_text_channel autumnal_forest {
  name                     = "autumnal-forest"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.bforest.id
  position                 = discord_text_channel.bforest_ooc.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel frozen_river {
  name                     = "frozen-river"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.bforest.id
  position                 = discord_text_channel.autumnal_forest.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel snowy_hill {
  name                     = "snowy-hill"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.bforest.id
  position                 = discord_text_channel.frozen_river.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel cold_jungle_top {
  name                     = "cold-jungle-canopy"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.bforest.id
  position                 = discord_text_channel.snowy_hill.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel cold_jungle_bottom {
  name                     = "cold-jungle-floor"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.bforest.id
  position                 = discord_text_channel.cold_jungle_top.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel mountain_pass {
  name                     = "mountain-pass"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.bforest.id
  position                 = discord_text_channel.cold_jungle_bottom.position + 1
  sync_perms_with_category = true
}

resource discord_category_channel hubeast {
  name      = "East Island"
  server_id = discord_server.nlp.id
  position  = discord_category_channel.mountains.position + 1
}

module "hubeast_permissions" {
  # only Players are allowed to write in IC chats
  source      = "./limited_channel_permissions"
  server_id   = discord_server.nlp.id
  channel_id  = discord_category_channel.hubeast.id
  permissions = local.permissions.send_messages
  allow_roles = [discord_role.player.id]
}

resource discord_text_channel east_ooc {
  name                     = "east-island-ooc"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.hubeast.id
  sync_perms_with_category = true
  lifecycle { ignore_changes = [position] }
}

resource discord_text_channel verdant_outpost {
  name                     = "verdant-outpost"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.hubeast.id
  position                 = discord_text_channel.east_ooc.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel verdant_hills {
  name                     = "verdant-hills"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.hubeast.id
  position                 = discord_text_channel.verdant_outpost.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel woodlands {
  name                     = "woodlands"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.hubeast.id
  position                 = discord_text_channel.verdant_hills.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel mushroom_forest {
  name                     = "mushroom-forest"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.hubeast.id
  position                 = discord_text_channel.woodlands.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel permafrost {
  name                     = "permafrost"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.hubeast.id
  position                 = discord_text_channel.mushroom_forest.position + 1
  sync_perms_with_category = true
}

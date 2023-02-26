resource discord_category_channel mountains {
  name      = "Mountains"
  server_id = discord_server.nlp.id
  position  = discord_category_channel.bforest.position + 1
}

module "mountain_permissions" {
  # only Players are allowed to write in IC chats
  source      = "./limited_channel_permissions"
  server_id   = discord_server.nlp.id
  channel_id  = discord_category_channel.mountains.id
  permissions = local.permissions.send_messages
  allow_roles = [discord_role.player.id]
}

resource discord_text_channel mountains_ooc {
  name                     = "mountains-ooc"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.mountains.id
  sync_perms_with_category = true
  lifecycle { ignore_changes = [position] }
}

resource discord_text_channel mountain_pass {
  name                     = "mountain-pass"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.mountains.id
  position                 = discord_text_channel.mountains_ooc.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel more_mountain {
  name                     = "isanyas-spine"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.mountains.id
  position                 = discord_text_channel.mountain_pass.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel mountain_peaks {
  name                     = "mountain-peaks"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.mountains.id
  position                 = discord_text_channel.more_mountain.position + 1
  sync_perms_with_category = true
}

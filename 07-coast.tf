# ### COAST ###
resource discord_category_channel coast {
  name      = "Coast"
  server_id = discord_server.nlp.id
  position  = discord_category_channel.city.position + 1
}

module "coast_permissions" {
  # only Players are allowed to write in IC chats
  source      = "./limited_channel_permissions"
  server_id   = discord_server.nlp.id
  channel_id  = discord_category_channel.coast.id
  permissions = local.permissions.send_messages
  allow_roles = [discord_role.player.id]
}

resource discord_text_channel coast_ooc {
  name                     = "coast-ooc"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.coast.id
  sync_perms_with_category = true
  lifecycle { ignore_changes = [position] }
}

resource discord_text_channel tide_pools {
  name                     = "tide-pools"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.coast.id
  position                 = discord_text_channel.coast_ooc.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel colorful_beach {
  name                     = "heartbreak-beach"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.coast.id
  position                 = discord_text_channel.tide_pools.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel cliffs {
  name                     = "basalt-cliffs"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.coast.id
  position                 = discord_text_channel.colorful_beach.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel coast_volcano_base {
  name                     = "volcano-base"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.coast.id
  position                 = discord_text_channel.cliffs.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel coast_volcano_peak {
  name                     = "volcano-peak"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.coast.id
  position                 = discord_text_channel.coast_volcano_base.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel coast_volcano_caldera {
  name                     = "steamy-caldera"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.coast.id
  position                 = discord_text_channel.coast_volcano_peak.position + 1
  sync_perms_with_category = true
}

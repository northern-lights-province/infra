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

resource discord_text_channel city_ooc {
  name                     = "city-ooc"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.city.id
  sync_perms_with_category = true
  lifecycle { ignore_changes = [position] }
}

resource discord_text_channel tavern {
  name                     = "the-borealis"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.city.id
  position                 = discord_text_channel.city_ooc.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel docks {
  name                     = "the-moorings"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.city.id
  position                 = discord_text_channel.tavern.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel market {
  name                     = "market-plaza"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.city.id
  position                 = discord_text_channel.docks.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel shrine {
  name                     = "shrine"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.city.id
  position                 = discord_text_channel.market.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel park {
  name                     = "park"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.city.id
  position                 = discord_text_channel.shrine.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel beach {
  name                     = "beach"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.city.id
  position                 = discord_text_channel.park.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel gates {
  name                     = "the-caravansary"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.city.id
  position                 = discord_text_channel.beach.position + 1
  sync_perms_with_category = true
}

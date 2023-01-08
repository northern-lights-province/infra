# ---- BOT STUFF ----
resource discord_category_channel bot_stuff {
  name      = "Meta"
  server_id = discord_server.nlp.id
  position  = discord_category_channel.dms.position + 1
}

module "bot_stuff_permissions" {
  # only Players are allowed to write in bot channels
  # also gaius isn't allowed in here (SET MANUALLY)
  source      = "./limited_channel_permissions"
  server_id   = discord_server.nlp.id
  channel_id  = discord_category_channel.bot_stuff.id
  permissions = local.permissions.send_messages
  allow_roles = [discord_role.player.id]
}

resource discord_text_channel submit_characters {
  name                     = "submit-characters"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.bot_stuff.id
  sync_perms_with_category = false  # Gaius is allowed in here
  lifecycle { ignore_changes = [position] }
}

resource discord_text_channel bot_test {
  name                     = "bot-test"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.bot_stuff.id
  position                 = discord_text_channel.submit_characters.position + 1
  sync_perms_with_category = false
}

resource discord_channel_permission bot_test_allow_everyone_send {
  # but everyone is allowed to write in bot-test
  channel_id   = discord_text_channel.bot_test.id
  type         = "role"
  overwrite_id = discord_role_everyone.everyone.id
  allow        = local.permissions.send_messages
}

resource discord_text_channel level_ups {
  name                     = "level-ups"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.bot_stuff.id
  position                 = discord_text_channel.bot_test.position + 1
  sync_perms_with_category = false  # Gaius is allowed in here
}

module "levelups_permissions" {
  # only Staff+ and bots are allowed to post in level-ups
  source      = "./limited_channel_permissions"
  server_id   = discord_server.nlp.id
  channel_id  = discord_text_channel.level_ups.id
  permissions = local.permissions.send_messages
  allow_roles = [
    discord_role.staff.id,
    discord_role.bots.id
  ]
}

resource discord_text_channel community_goals {
  name      = "community-goals"
  topic     = "Contribute to community goals here with !cg <id> <amount>! Messages will automatically be deleted after 1 minute."
  server_id = discord_server.nlp.id
  category  = discord_category_channel.bot_stuff.id
  position  = discord_text_channel.level_ups.position + 1
}

resource discord_text_channel downtime_rolls {
  name      = "downtime-rolls"
  server_id = discord_server.nlp.id
  category  = discord_category_channel.bot_stuff.id
  position  = discord_text_channel.community_goals.position + 1
}

# market-bazaar lives here but can't be modeled in terraform

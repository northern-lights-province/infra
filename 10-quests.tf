# ---- QUESTS ----
resource discord_category_channel quests {
  name      = "Quest Rooms"
  server_id = discord_server.nlp.id
  position  = discord_category_channel.bforest.position + 1
}

module "quest_permissions" {
  # only Players are allowed to write in IC chats
  source      = "./limited_channel_permissions"
  server_id   = discord_server.nlp.id
  channel_id  = discord_category_channel.quests.id
  permissions = local.permissions.send_messages
  allow_roles = [discord_role.player.id]
}

resource discord_text_channel quest_board {
  name                     = "quest-board"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.quests.id
  sync_perms_with_category = true
  lifecycle { ignore_changes = [position] }
}

resource discord_text_channel quest_planning {
  name                     = "quest-planning"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.quests.id
  position                 = discord_text_channel.quest_board.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel quest_ooc {
  count                    = 3  # change this to control number of quest rooms
  name                     = "quest-${count.index + 1}-ooc"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.quests.id
  position                 = discord_text_channel.quest_planning.position + (count.index * 2) + 1
  sync_perms_with_category = true
}

resource discord_text_channel quest_ic {
  count                    = length(discord_text_channel.quest_ooc)
  name                     = "quest-${count.index + 1}"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.quests.id
  position                 = discord_text_channel.quest_ooc[count.index].position + 1
  sync_perms_with_category = true
}

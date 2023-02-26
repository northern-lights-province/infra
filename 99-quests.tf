# ---- QUESTS ----
resource discord_category_channel quests {
  name      = "Quest Rooms"
  server_id = discord_server.nlp.id
  position  = discord_category_channel.hubeast.position + 1
}

# ==== PERMISSIONS ====
resource discord_channel_permission quests_deny_everyone {
  channel_id   = discord_category_channel.quests.id
  type         = "role"
  overwrite_id = discord_role_everyone.everyone.id
  deny         = local.permissions.send_messages
}

resource discord_channel_permission quests_allow_players_send {
  channel_id   = discord_category_channel.quests.id
  type         = "role"
  overwrite_id = discord_role.player.id
  allow        = local.permissions.send_messages
}

resource discord_channel_permission quests_allow_dms_manage {
  channel_id   = discord_category_channel.quests.id
  type         = "role"
  overwrite_id = discord_role.dm.id
  allow        = local.permissions.send_and_manage_messages
}

# ==== CHANNELS ====
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

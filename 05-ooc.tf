# ---- OOC ----
resource discord_category_channel ooc {
  name      = "Out of Character"
  server_id = discord_server.nlp.id
  position  = discord_category_channel.bot_stuff.position + 1
}

resource discord_text_channel general {
  name                     = "general"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.ooc.id
  sync_perms_with_category = true
  lifecycle { ignore_changes = [position] }
}

resource discord_text_channel questions {
  name                     = "help-and-questions"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.ooc.id
  position                 = discord_text_channel.general.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel memes {
  name                     = "memes"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.ooc.id
  position                 = discord_text_channel.questions.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel lfg {
  name                     = "looking-for-group"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.ooc.id
  position                 = discord_text_channel.memes.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel quotes {
  name                     = "quotes"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.ooc.id
  position                 = discord_text_channel.lfg.position + 1
  sync_perms_with_category = true
}

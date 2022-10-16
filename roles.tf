resource discord_role_everyone everyone {
  server_id   = discord_server.nlp.id
  permissions = data.discord_permission.new_member.allow_bits
}

resource discord_role member {
  server_id   = discord_server.nlp.id
  name        = "Member"
  permissions = data.discord_permission.member.allow_bits
  position    = 1
}

resource discord_role player {
  server_id   = discord_server.nlp.id
  name        = "Player"
  permissions = data.discord_permission.player.allow_bits
  position    = 2
}

resource discord_role dm {
  server_id   = discord_server.nlp.id
  name        = "Dungeon Master"
  permissions = data.discord_permission.dm.allow_bits
  position    = 3
}

resource discord_role staff {
  server_id   = discord_server.nlp.id
  name        = "Staff"
  permissions = data.discord_permission.staff.allow_bits
  position    = 4
}

resource discord_role admin {
  server_id   = discord_server.nlp.id
  name        = "Administrator"
  permissions = data.discord_permission.admin.allow_bits
  position    = 5
}

# ==== bot roles ====
resource discord_role avrae {
  server_id   = discord_server.nlp.id
  name        = "Avrae"
  permissions = data.discord_permission.avrae.allow_bits
  position    = 6
}

resource discord_role infra_bot {
  server_id   = discord_server.nlp.id
  name        = "Northern Lights Infra"
  permissions = data.discord_permission.admin.allow_bits
  position    = 7
}
resource discord_role_everyone everyone {
  server_id   = discord_server.nlp.id
  permissions = data.discord_permission.new_member.allow_bits
}

# unmanaged roles should be below the === unmanaged roles below === role
# and are not defined in TF

resource discord_role unmanaged_roles {
  server_id = discord_server.nlp.id
  name      = "=== unmanaged roles below ==="

  lifecycle {
    ignore_changes = [position]
  }
}

resource discord_role booster {
  server_id = discord_server.nlp.id
  name      = "Server Booster"
  color     = 16023551
  position  = discord_role.unmanaged_roles.position + 1
}

resource discord_role dragonspeaker {
  server_id = discord_server.nlp.id
  name      = "Dragonspeaker"
  position  = discord_role.booster.position + 1
}

resource discord_role member {
  server_id   = discord_server.nlp.id
  name        = "Member"
  hoist       = true
  permissions = data.discord_permission.member.allow_bits
  position    = discord_role.dragonspeaker.position + 1
}

resource discord_role player {
  server_id   = discord_server.nlp.id
  name        = "Player"
  hoist       = true
  permissions = data.discord_permission.player.allow_bits
  position    = discord_role.member.position + 1
}

resource discord_role bots {
  server_id   = discord_server.nlp.id
  name        = "Bots"
  hoist       = true
  permissions = data.discord_permission.member.allow_bits
  position    = discord_role.player.position + 1
}

resource discord_role dm {
  server_id   = discord_server.nlp.id
  name        = "Dungeon Master"
  hoist       = true
  permissions = data.discord_permission.dm.allow_bits
  position    = discord_role.bots.position + 1
}

resource discord_role staff {
  server_id   = discord_server.nlp.id
  name        = "Staff"
  hoist       = true
  permissions = data.discord_permission.staff.allow_bits
  position    = discord_role.dm.position + 1
}

resource discord_role founder {
  server_id   = discord_server.nlp.id
  name        = "Founder"
  permissions = data.discord_permission.founder.allow_bits
  position    = discord_role.staff.position + 1
}

resource discord_role admin {
  server_id   = discord_server.nlp.id
  name        = "Benevolent Dictator For Life"
  permissions = data.discord_permission.admin.allow_bits
  position    = discord_role.founder.position + 1
}

resource discord_role infra_bot {
  server_id   = discord_server.nlp.id
  name        = "Northern Lights Bot"
  permissions = data.discord_permission.admin.allow_bits
  position    = discord_role.admin.position + 1
}
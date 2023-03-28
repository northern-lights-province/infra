resource discord_role_everyone everyone {
  server_id   = discord_server.nlp.id
  permissions = data.discord_permission.new_member.allow_bits
}

# unmanaged roles should be below the === unmanaged roles below === role
# and are not defined in TF
# e.g. bot roles, cosmetic roles; anything without a permission set

resource discord_role unmanaged_roles {
  server_id = discord_server.nlp.id
  name      = "=== unmanaged roles below ==="
  lifecycle { ignore_changes = [position] }
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
  color       = 13694174  # 0xd0f4de  # pastel green
  permissions = data.discord_permission.member.allow_bits
  position    = discord_role.dragonspeaker.position + 1
}

resource discord_role player {
  server_id   = discord_server.nlp.id
  name        = "Player"
  hoist       = true
  color       = 11132665  # 0xa9def9  # pastel blue
  permissions = data.discord_permission.player.allow_bits
  position    = discord_role.member.position + 1
}

resource discord_role t1 {
  server_id   = discord_server.nlp.id
  name        = "Tier 1"
  hoist       = true
  color       = 13166591  # 0xc8e7ff  # tiers: blue -> purple gradient
  position    = discord_role.player.position + 1
}

resource discord_role t2 {
  server_id   = discord_server.nlp.id
  name        = "Tier 2"
  hoist       = true
  color       = 13685247  # 0xd0d1ff
  position    = discord_role.t1.position + 1
}


resource discord_role t3 {
  server_id   = discord_server.nlp.id
  name        = "Tier 3"
  hoist       = true
  color       = 14203903  # 0xd8bbff
  position    = discord_role.t2.position + 1
}


resource discord_role t4 {
  server_id   = discord_server.nlp.id
  name        = "Tier 4"
  hoist       = true
  color       = 14592767  # 0xdeaaff
  position    = discord_role.t3.position + 1
}

resource discord_role bots {
  server_id   = discord_server.nlp.id
  name        = "Bots"
  color       = 16766576 # 0xffd670  # pumpkin
  permissions = data.discord_permission.bots.allow_bits
  position    = discord_role.t4.position + 1
}

resource discord_role dm {
  server_id   = discord_server.nlp.id
  name        = "Dungeon Master"
  hoist       = true
  mentionable = true
  color       = 6345620  # 0x60d394  # mint
  permissions = data.discord_permission.dm.allow_bits
  position    = discord_role.bots.position + 1
}

resource discord_role staff {
  server_id   = discord_server.nlp.id
  name        = "Staff"
  hoist       = true
  mentionable = true
  color       = 16740518  # 0xff70a6  # pink
  permissions = data.discord_permission.staff.allow_bits
  position    = discord_role.dm.position + 1
}

resource discord_role founder {
  server_id   = discord_server.nlp.id
  name        = "Admin"
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
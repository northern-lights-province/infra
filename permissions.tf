data discord_permission new_member {
  create_instant_invite = "allow"
  change_nickname       = "allow"

  use_external_emojis      = "allow"
  use_external_stickers    = "allow"
  read_message_history     = "allow"
  use_application_commands = "allow"
}

data discord_permission member {
  allow_extends = data.discord_permission.new_member.allow_bits

  view_channel = "allow"

  send_messages          = "allow"
  send_thread_messages   = "allow"
  create_public_threads  = "allow"
  create_private_threads = "allow"
  embed_links            = "allow"
  attach_files           = "allow"
  add_reactions          = "allow"

  connect                   = "allow"
  speak                     = "allow"
  stream                    = "allow"
  use_vad                   = "allow"
  start_embedded_activities = "allow"
}

data discord_permission player {
  allow_extends = data.discord_permission.member.allow_bits
}

data discord_permission dm {
  allow_extends = data.discord_permission.member.allow_bits
}

data discord_permission staff {
  allow_extends = data.discord_permission.member.allow_bits
}

data discord_permission admin {
  administrator = "allow"
}

# ==== imported/managed permissions ====
data discord_permission avrae {
  allow_extends = 388160
}

# ==== granular permissions ====
data discord_permission send_messages {
  send_messages = "allow"
}

data discord_permission view_channel {
  view_channel = "allow"
}

# permissions to deny to everyone for resource channels
data discord_permission resource_channel {
  send_messages          = "allow"
  add_reactions          = "allow"
  send_thread_messages   = "allow"
  create_public_threads  = "allow"
  create_private_threads = "allow"
}

locals {
  permissions = {
    send_messages    = data.discord_permission.send_messages.allow_bits
    view_channel     = data.discord_permission.view_channel.allow_bits
    resource_channel = data.discord_permission.resource_channel.allow_bits
  }
}

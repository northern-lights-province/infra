terraform {
  required_providers {
    discord = {
      source  = "Lucky3028/discord"
      version = ">=1.1.2"
    }
  }
}

provider discord {
  token = var.discord_token
}

# ===== SERVER =====
resource discord_server nlp {
  name     = "The Northern Lights Province"
  owner_id = var.owner_id
  region   = "us-east"

  verification_level            = 2  # must be registered for 5 minutes or longer
  explicit_content_filter       = 2  # scan all messages
  default_message_notifications = 1  # ping on @ only
}

# ===== CHANNELS =====
# ---- WELCOME ----
resource discord_text_channel welcome {
  name                     = "welcome"
  server_id                = discord_server.nlp.id
  sync_perms_with_category = false
  lifecycle { ignore_changes = [position] }
}

# only Staff+ are allowed to write in welcome
module "welcome_permissions" {
  source      = "./limited_channel_permissions"
  server_id   = discord_server.nlp.id
  channel_id  = discord_text_channel.welcome.id
  permissions = local.permissions.resource_channel
  allow_roles = [
    discord_role.staff.id,
    discord_role.founder.id,
    discord_role.admin.id
  ]
  additional_allow = local.permissions.view_channel # but everyone is allowed to see resources
}

# ---- RESOURCES ----
resource discord_category_channel resources {
  name      = "Resources"
  server_id = discord_server.nlp.id
  lifecycle { ignore_changes = [position] }
}

module "resources_permissions" {
  # only Staff+ are allowed to write in resources
  source      = "./limited_channel_permissions"
  server_id   = discord_server.nlp.id
  channel_id  = discord_category_channel.resources.id
  permissions = local.permissions.resource_channel
  allow_roles = [
    discord_role.staff.id,
    discord_role.founder.id,
    discord_role.admin.id
  ]
}

resource discord_text_channel character_creation {
  name                     = "character-creation"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.resources.id
  sync_perms_with_category = true
  lifecycle { ignore_changes = [position] }
}

resource discord_text_channel getting_started {
  name                     = "getting-started"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.resources.id
  sync_perms_with_category = true
  position                 = discord_text_channel.character_creation.position + 1
}

resource discord_text_channel rules_in_wild {
  name                     = "wilderness-rules"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.resources.id
  sync_perms_with_category = true
  position                 = discord_text_channel.getting_started.position + 1
}

resource discord_text_channel rules_in_town {
  name                     = "city-and-downtime-rules"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.resources.id
  sync_perms_with_category = true
  position                 = discord_text_channel.rules_in_wild.position + 1
}

# ---- STAFF ----
resource discord_category_channel staff {
  name      = "Staff"
  server_id = discord_server.nlp.id
  position  = discord_category_channel.resources.position + 1
}

module "staff_permissions" {
  # only Staff+ and bots are allowed to see staff channels
  source      = "./limited_channel_permissions"
  server_id   = discord_server.nlp.id
  channel_id  = discord_category_channel.staff.id
  permissions = local.permissions.view_channel
  allow_roles = [
    discord_role.staff.id,
    discord_role.founder.id,
    discord_role.admin.id,
    discord_role.bots.id
  ]
}

resource discord_text_channel staff_general {
  name                     = "staff-general"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.staff.id
  sync_perms_with_category = true
  lifecycle { ignore_changes = [position] }
}

resource discord_text_channel staff_bot {
  name                     = "staff-bot"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.staff.id
  position                 = discord_text_channel.staff_general.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel staff_logs {
  name                     = "staff-logs"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.staff.id
  position                 = discord_text_channel.staff_bot.position + 1
  sync_perms_with_category = true
}

# staff-forum lives here but can't be modeled in terraform

resource discord_text_channel staff_voice_text {
  name                     = "staff-voice-text"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.staff.id
  lifecycle { ignore_changes = [position] }
  sync_perms_with_category = true
}

resource discord_voice_channel staff_voice {
  name      = "staff-nyah-chat"
  server_id = discord_server.nlp.id
  category  = discord_category_channel.staff.id
}

# ---- DMs ----
resource discord_category_channel dms {
  name      = "Dungeon Masters"
  server_id = discord_server.nlp.id
  position  = discord_category_channel.staff.position + 1
}

module "dm_permissions" {
  # only DM+ and bots are allowed to see DM channels
  source      = "./limited_channel_permissions"
  server_id   = discord_server.nlp.id
  channel_id  = discord_category_channel.dms.id
  permissions = local.permissions.view_channel
  allow_roles = [
    discord_role.dm.id,
    discord_role.staff.id,
    discord_role.bots.id
  ]
}

resource discord_text_channel dm_general {
  name                     = "dm-general"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.dms.id
  sync_perms_with_category = true
  lifecycle { ignore_changes = [position] }
}

resource discord_text_channel dm_bot {
  name                     = "dm-bot"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.dms.id
  position                 = discord_text_channel.dm_general.position + 1
  sync_perms_with_category = true
}

# dm-forum lives here but can't be modeled in terraform

# ---- BOT STUFF ----
resource discord_category_channel bot_stuff {
  name      = "Bot Stuff"
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

resource discord_text_channel bot_test {
  name                     = "bot-test"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.bot_stuff.id
  sync_perms_with_category = false
  lifecycle { ignore_changes = [position] }
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
  sync_perms_with_category = false
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

# market-bazaar lives here but can't be modeled in terraform

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

resource discord_text_channel park {
  name                     = "park"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.city.id
  position                 = discord_text_channel.market.position + 1
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

# ### BOREAL FOREST ###
resource discord_category_channel bforest {
  name      = "Boreal Forest"
  server_id = discord_server.nlp.id
  position  = discord_category_channel.coast.position + 1
}

module "bforest_permissions" {
  # only Players are allowed to write in IC chats
  source      = "./limited_channel_permissions"
  server_id   = discord_server.nlp.id
  channel_id  = discord_category_channel.bforest.id
  permissions = local.permissions.send_messages
  allow_roles = [discord_role.player.id]
}

resource discord_text_channel bforest_ooc {
  name                     = "boreal-forest-ooc"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.bforest.id
  sync_perms_with_category = true
  lifecycle { ignore_changes = [position] }
}

resource discord_text_channel autumnal_forest {
  name                     = "autumnal-forest"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.bforest.id
  position                 = discord_text_channel.bforest_ooc.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel frozen_river {
  name                     = "frozen-river"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.bforest.id
  position                 = discord_text_channel.autumnal_forest.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel snowy_hill {
  name                     = "snowy-hill"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.bforest.id
  position                 = discord_text_channel.frozen_river.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel cold_jungle_top {
  name                     = "cold-jungle-canopy"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.bforest.id
  position                 = discord_text_channel.snowy_hill.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel cold_jungle_bottom {
  name                     = "cold-jungle-floor"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.bforest.id
  position                 = discord_text_channel.cold_jungle_top.position + 1
  sync_perms_with_category = true
}

resource discord_text_channel mountain_pass {
  name                     = "mountain-pass"
  server_id                = discord_server.nlp.id
  category                 = discord_category_channel.bforest.id
  position                 = discord_text_channel.cold_jungle_bottom.position + 1
  sync_perms_with_category = true
}

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
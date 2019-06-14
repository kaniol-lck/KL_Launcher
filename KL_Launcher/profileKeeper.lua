local profileKeeper = {}

require "json"
config = require "config"

local f = assert(io.open(config.game_directory.."/launcher_profiles.json","r"))
local data = json.decode(f:read("*a"))
f:close()

profileKeeper.profiles = data.profiles

profileKeeper.selectedProfile = data.profiles[data.selectedProfileName]

-- code below is used for account management

profileKeeper.selectedUser = data.selectedUser

profileKeeper.authenticationDatabase = data.authenticationDatabase

return profileKeeper
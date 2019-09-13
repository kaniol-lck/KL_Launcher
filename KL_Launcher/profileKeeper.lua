local profileKeeper = {}

require "json"
config = require "config"

local f = assert(io.open(config.gamepath.."/launcher_profiles.json","r"))
local data = json.decode(f:read("*a"))
f:close()

profileKeeper.profiles = data.profiles
for _, profile in pairs(data.profiles) do 
    if profile.name == data.selectedProfileName then
        profileKeeper.selectedProfile = profile
        break
    end
end    

--print(profileKeeper.selectedProfile.lastVersionId)
-- code below is used for account management

profileKeeper.selectedUser = data.selectedUser

profileKeeper.authenticationDatabase = data.authenticationDatabase

return profileKeeper
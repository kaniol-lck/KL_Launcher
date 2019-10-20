local profileKeeper = {}

local json = require "json"
local config = require "config"

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

function profileKeeper.printList()
    for _, profile in pairs(data.profiles) do
        print(profile.name)
    end
end

function profileKeeper.addProfile(profileName, dir, versionId)
    profileName = profileName or versionId
    for _, profile in pairs(data.profiles) do
        if profile.name == profileName then
            print("Already exsits: "..profileName)
            return
        end
    end
    local profile = {
        name = profileName,
        gameDir = dir,
        lastVersionId = versionId
    }
    data.profiles[profileName] = profile
    profileKeeper.writeToFile()
end

function profileKeeper.removeProfile(profileName)
    if data.profiles[profileName] == nil then
        print("no such profile: "..profileName)
    else
        data.profiles[profileName] = nil
        profileKeeper.writeToFile()
    end
end

function profileKeeper.writeToFile()
    local f = assert(io.open(config.gamepath.."/launcher_profiles.json","w"))
    f:write(json.encode(data))
    f:close()
end

-- code below is used for account management

profileKeeper.selectedUser = data.selectedUser

profileKeeper.authenticationDatabase = data.authenticationDatabase

return profileKeeper
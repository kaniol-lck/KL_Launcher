json = require "json"
config = require "config"

local versionTool = {}

versionTool.__index = versionTool

setmetatable(versionTool, {
    __call = function(cls, ...)
      return cls.new(...)
    end,
  })

function versionTool:new(version)
    local self = setmetatable({}, versionTool)  
    local f = assert(io.open(string.format("%s/versions/%s/%s.json", config.gamepath, version, version), "r"))
    self.data = json.decode(f:read("*a"))
    self.version = version
    return self
end

function versionTool:classify_libraries()
    local dependeny_libraries = {}
    local natives_libraries = {}
    library = require "launch/jsonTools/library"
    for _, data in pairs(self.data.libraries) do
        local l = library:new(data)
        if l:isNatives() then
            natives_libraries[#natives_libraries+1] = l
        else
            dependeny_libraries[#dependeny_libraries+1] = l
        end
    end
    return dependeny_libraries, natives_libraries
end

function versionTool:mainClass()
    return self.data.mainClass
end

function versionTool:gameArgs()
    local gameArg_t = {}
    for _, arg in pairs(self.data.arguments.game) do
        if type(arg == "string") then gameArg_t[#gameArg_t+1] = arg end
    end
    return gameArg_t
end

function versionTool:jarpath()
    return self.version.."/"..self.version..".jar"
end

function versionTool:assetIndexId()
    return self.data.assetIndex.id
end

return versionTool
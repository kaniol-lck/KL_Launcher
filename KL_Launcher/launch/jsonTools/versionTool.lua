json = require "json"
config = require "json"

function versionTool:new(version)
    local o = {}
    setmetatable(o,self)
    __index = self
    local f = assert(io.open(string.format("%s/versions/%s/%s.json", config.game_directory, version, version), "r"))
    o.data = json.decode(f:read("*a"))
    return o
end

function versionTool:classify_libraries()
    local dependeny_libraries = {}
    local natives_libraries = {}
    require "library"
    for _, data in pairs(self.data.libraries) do
        local l = library:new(data)
        if l:isNatives() then
            dependeny_libraries.[#dependeny_libraries+1] = l
        else
            natives_libraries.[#natives_libraries+1] = l
        end
    end
    return dependeny_libraries, natives_libraries
end

function versionTool:mainClass()
    return self.data.mainClass
end

function versionTool:gameArgs()
    local gameArg_t = {}
    for _, arg = pairs(self.data.argument.game) do
        if type(arg == "string") then gameArg_t[#gameArg_t+1] = arg end
    end
    return gameArg_t
end
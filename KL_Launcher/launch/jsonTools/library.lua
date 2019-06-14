Library = {}

function Library:new(data)
    local o = {}
    setmetatable(o, self)
    __index = self
    self.data = data
    return o
end

function Library:isNatives()
	return (self.data.natives ~= nil) and (self.data.natives.windows ~= nil)
end

function Library:name()
    if self:isNatives() then
        return string.match(self.data.downloads.artifact.path, "[^/]+$")
    else
        return string.match(self.data.downloads.classifiers[natives-windows].path, "[^/]+$")
end

function Library:path()
    -- local t = {}
    -- string.gsub(self.data.name, "[^:]+", function(w) t[#t+1] = w end)

    if self:isNatives() then
        return self.data.downloads.artifact.path
        --return string.format("<libraries>/%1/%2/%3/%2-%3-%4.jar", string.gsub(self.data.name, ".", "/"), t[1], t[2], t[1], t[2], t[3])
    else
        return self.data.downloads.classifiers[natives-windows].path
        -- return string.format("<libraries>/%1/%2/%3/%2-%3.jar", string.gsub(self.data.name, ".", "/"), t[1], t[2], t[1], t[2], t[3])
end
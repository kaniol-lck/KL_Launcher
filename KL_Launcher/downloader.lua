local downloader = {}

local manifest_url = [[https://launchermeta.mojang.com/mc/game/version_manifest.json]]

function downloader.download(url, path)
    require "luacurl"
    c = curl.new()

    c:setopt( curl.OPT_WRITEFUNCTION, function ( stream, buffer )
        if stream:write( buffer ) then
            return string.len( buffer )
        end
    end)
    
    c:setopt(curl.OPT_WRITEDATA, io.open(path, "wb")) 
    c:setopt(curl.OPT_SSL_VERIFYPEER, false)
    c:setopt(curl.OPT_URL, url)
    c:setopt(curl.OPT_CONNECTTIMEOUT, 15)
    assert(c:perform())
    c:close()
end

function downloader.downloadManifest()
    downloader.download(manifest_url, "verison_manifest.json")
end

function downloader.downloadJson(verisonId)
    
end

return downloader
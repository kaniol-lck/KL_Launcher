local launcher = {}

local json = require "json"
require "customizer"
local lfs = require "lfs"

function launcher.extract(zipfile, path)
    print("Extracting:"..zipfile)
    require "zip"
    lfs.mkdir(path)
    local zfile = assert(zip.open(zipfile))
    for f in zfile:files() do
        if not string.match(f.filename, "^META%-INF/") then
            local inf = assert(zfile:open(f.filename))
            local outf = assert(io.open(path.."/"..f.filename, "wb"))
            outf:write(inf:read("*a"))
            outf:close()
        end
    end
end

function launcher.generateCode(profile, account, customizer)
    local arg_t = {}

    arg_t[#arg_t+1] = customizer.javapath()

    -- JVM args:
    arg_t[#arg_t+1] = "-Xmx1024m"
    arg_t[#arg_t+1] = "-Xmn128m"
    arg_t[#arg_t+1] = "-Djava.library.path="..customizer.natpath()

    arg_t[#arg_t+1] = "-cp"
    local versionTool = require "jsonTools.versionTool"
    local version = profile.lastVersionId
    local vt = versionTool:new(version)
    local dependeny_libraries, natives_libraries = vt:classify_libraries()

    local classpath_t = {}
    for _, l in pairs(dependeny_libraries) do
        classpath_t[#classpath_t+1] = customizer.libpath().."/"..l:path()
    end

    for _, l in pairs(natives_libraries) do
        launcher.extract(customizer.libpath().."/"..l:path(), customizer.natpath())
    end

    classpath_t[#classpath_t+1] = customizer.verpath().."/"..vt:jarpath()
    arg_t[#arg_t+1] = table.concat(classpath_t, ";")
    
    -- Game args:

    customizer.replace_map["${version_name}"] =  version
    customizer.replace_map["${game_directory}"] = customizer.gamepath()
    customizer.replace_map["${assets_root}"] = customizer.asspath()
    customizer.replace_map["${assets_index_name}"] = vt:assetIndexId()
    customizer.replace_map["${version_type}"] = "KL Launcher"

    arg_t[#arg_t+1] = vt:mainClass()
    for _, gameArg in pairs(vt:gameArgs()) do
        if type(gameArg) == "string" then
            arg_t[#arg_t+1] = customizer.replace(gameArg)
        end
    end

    if customizer.fullscreen then
        if customizer.size then print "Full screen or custom window size? Select one." return end
        arg_t[#arg_t+1] = "--fullscreen"
    end

    if customizer.size then
        arg_t[#arg_t+1] = "--width"
        arg_t[#arg_t+1] = customizer.size[1]
        arg_t[#arg_t+1] = "--height"
        arg_t[#arg_t+1] = customizer.size[2]
    end

    if customizer.server then
        arg_t[#arg_t+1] = "--serverip"
        arg_t[#arg_t+1] = customizer.server[1]
        arg_t[#arg_t+1] = "--serverport"
        arg_t[#arg_t+1] = customizer.server[2]
    end

    return arg_t
end

function launcher.launch(profile, account, customizer)
    local startcode = [[""]]..table.concat(launcher.generateCode(profile, account, customizer), [[" "]])..[[""]]

    local mcp = assert(io.popen(startcode, "r"))

    -- print(mcp:read("*a"))
    mcp:close()
    os.execute([[rm -rf ]]..customizer.natpath())
end

return launcher
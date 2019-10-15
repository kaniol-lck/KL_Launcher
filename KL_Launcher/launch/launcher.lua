launcher = {}

require "json"
require "customizer"

function launcher.extract(zipfile, path)
    print("Extracting:"..zipfile)
    require "zip"
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
    versionTool = require "launch/jsonTools/versionTool"
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
    customizer.replace_map["${user_type}"] = "Legacy"
    customizer.replace_map["${version_type}"] = "KL Launcher"

    arg_t[#arg_t+1] = vt:mainClass()
    for _, gameArg in pairs(vt:gameArgs()) do
        if type(gameArg) == "string" then
            arg_t[#arg_t+1] = customizer.replace(gameArg)
        end
    end

    return arg_t
end

function launcher.launch(profile, account, customizer)
    local startcode = [[start "" "]]..table.concat(launcher.generateCode(profile, account, customizer), [[" "]])..[["]]

    os.execute(startcode)
end

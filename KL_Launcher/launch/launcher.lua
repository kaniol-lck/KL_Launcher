local launcher = {}

require "json"

function launcher.generateCode()
    local arg_t = {}

    arg_t[#arg_t+1] = customizer.javapath

    -- JVM args:
    arg_t[#arg_t+1] = "-Xmx2048m"
    arg_t[#arg_t+1] = "-Xmn128m"
    arg_t[#arg_t+1] = "-Djava.library.path="..customizer.natpath

    arg_t[#arg_t+1] = "-cp"
    require "jsonTool/versionTool"
    local vt = versionTool:new(profile.lastVerisonId)
    local dependeny_libraries, natives_libraries = versionTool:classify_libraries()

    local classpath_t = {}
    for _, l in pairs(dependeny_libraries) do
        classpath_t[#classpath_t+1] = customizer.libpath.."/"..l.path()
    end
    classpath_t[#classpath_t+1] = customizer.verpath.."/"..vt.jarpath()
    arg_t[#arg_t+1] = table.concat(classpath_t, ";")
    
    -- Game args:
    arg_t[#arg_t+1] = vt:mainClass()
    for _, gameArg in pairs(vt:gameArgs()) do
        arg_t[arg_t+1] = customizer.replacer(gameArg)
    end

    return arg_t
end

function launcher.launch(profile, account, customizer)
    local startcode = [[start "]]..table.concat(launcher.generateCode(), [[" "]])..[["]]

    os.execute(startcode)
end

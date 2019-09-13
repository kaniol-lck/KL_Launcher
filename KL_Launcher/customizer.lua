require "config"

function createCustomizer()
    local customizer = {}

    --javaw as default
    customizer.javapath = function()
        return config.javapath and config.javapath or "javaw"
    end

    --core directory as default
    customizer.corepath = function()
        return config.corepath
    end

    --default game directory is core directory as default
    customizer.defgamepath = function()
        return config.defgamepath and config.defgamepath or customizer.corepath()
    end

    --game directory is core directory as default
    customizer.gamepath = function()
        return config.gamepath and config.gamepath or customizer.defgamepath()
    end

    --version path is the "versions" folder under the core directory as default
    customizer.verpath = function()
        return config.verpath and config.verpath or customizer.corepath().."/versions"
    end

    --libraries path is the "libraries" folder under the core directory as default
    customizer.libpath = function()
        return config.libpath and config.libpath or customizer.corepath().."/libraries"
    end

    --natives path is the "natives" folder under the game directory as default
    customizer.natpath = function()
        return config.natpath and config.natpath or customizer.gamepath().."/natives"
    end

    --assets path is the "assets" folder under the core directory as default
    customizer.asspath = function()
        return config.asspath and config.asspath or customizer.corepath().."/assets"
    end

    --asset indexes path is the "indexes" folder under the assets directory as default
    customizer.indpath = function()
        return config.indpath and config.indpath or customizer.asspath().."/indexes"
    end

    --asset objects path is the "objects" folder under the assets directory as default
    customizer.objpath = function()
        return config.objpath and config.objpath or customizer.asspath().."/objects"
    end

    ----------沿---------虚---------线---------裁---------开-----------

    customizer.replace_map = {}

    customizer.replace = function(arg)
        for s1, s2 in pairs(customizer.replace_map) do
            arg = string.gsub(arg, s1, s2)
        end
        return arg
    end

    return customizer
end
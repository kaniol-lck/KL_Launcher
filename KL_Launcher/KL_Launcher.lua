local profileKeeper = require "profileKeeper"
local accountPool = require "accountPool"

require "customizer"
local customizer = createCustomizer()

function launch()
	local profile = profileKeeper.selectedProfile
	if customizer.profileName then
		if profileKeeper.profiles[customizer.profileName] then
			profile = profileKeeper.profiles[customizer.profileName]
		end
	end

	customizer.replace_map["${auth_player_name}"] = "kaniol"

	local launcher = require "launcher"
	launcher.launch(profile, account, customizer)
end

function download()
	-- body
end

local cli = require "cliargs"

cli:set_name("KL_Launcher")
cli:set_description("a Minecraft Launcher written in Lua")
cli:flag("-v, --version", "version info of KL Launcher", false, function()
	print[[
KL Launcher v1.0
Copyright by kaniol-lck
Licensed Under BSD 2-Clause "Simplified" License]]
end)

cli
	:command("launch", "launch Minecraft")
	:option("-p, --profile profileName", "specify a profile to launch", nil, function(_, profileName) print(profileName) customizer.profileName = profileName end)
	:option("-v, --version versionId", "specify a version id to launch", nil, function(_, verisnId) customizer.versionId = verisnId end)
	:option("-s, --size <width>x<height>", "set window size", nil, function(_, size) customizer.size = { string.match(size, "^(%d+)x(%d+)$") } end)
	:option("--server <hostname>:<port>", "enter a server when game launched", nil, function(_, server) customizer.server = { string.match(server, "^([%a.]):(%d+)$") } end)
	:flag("-f, --fullscreen", "use full screen to play Minecraft", false, function(_, fullscreen) customizer.fullscreen = fullscreen end)
	:action(launch)

cli
	:command("download", "download Minecraft")
	:option("-v, --version versionId", "specify a version id to download", nil, function(_, verisnId) customizer.versionId = verisnId end)
	:action(download)

local profile_cli = cli:command("profile", "manage profiles"):action(function() end)

profile_cli
	:command("list", "show all profiles in a list")
	:action(profileKeeper.printList)

profile_cli
	:command("remove", "remove a profile")
	:argument("NAME", "name of the profile to remove")
	:action(function(args) profileKeeper.removeProfile(args.NAME) end)

profile_cli
	:command("add", "add a profile")
	:argument("NAME", "name of the profile to add")
	:option("-d, --dir gameDir", "specify game directory of profile")
	:option("-v, --version versionId", "specify version id of profile")
	:action(function(args) profileKeeper.addProfile(args.NAME, args.dir, args.version) end)

local account_cli = cli:command("account", "manage accounts"):action(function() end)

account_cli
	:command("list", "show all profiles in a list")
	:action(accountPool.printList)

account_cli
	:command("remove", "remove a profile")
	:argument("NAME", "name of the profile to remove")
	:action(function(options) accountPool.removeAccount(options.NAME) end)

local add_account_cli = account_cli:command("add", "add a profile"):action(function() end)

add_account_cli
	:command("mojang", "certified Minecraft account")
	:argument("USERNAME", "your username")
	:argument("PASSWORD", "your password")
	:option("-n, --name custumName", "name of the account to add")
	:action(function(options) accountPool.addMojangAccount(options.name, options.USERNAME, options.PASSWORD) end)

add_account_cli
	:command("offline", "uncertified offline account")
	:argument("PLAYERNAME", "playername used in game")
	:option("-n, --name custumName", "name of the account to add")
	:action(function(options) accountPool.addOfflineAccount(options.name, options.PLAYERNAME) end)

local args, err = cli:parse()

if not args and err then
	return print(err)
elseif args then

end
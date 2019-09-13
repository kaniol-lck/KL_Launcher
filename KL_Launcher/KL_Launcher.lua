profileKeeper = require "profileKeeper"
accountPool = require "accountPool"

function launch(...)
	--playerName, gamemode, customizrer
	local profile = profileKeeper.selectedProfile
	--local account = accountPool.selectedAccount

	--profileKeeper.check(profile)
	--accountPool.refresh(account)
	require "customizer"
	local customizer = createCustomizer()

	customizer.replace_map["${auth_player_name}"] = "kaniol"

	require "launch/launcher"
	launcher.launch(profile, account, customizer)
end

launch()
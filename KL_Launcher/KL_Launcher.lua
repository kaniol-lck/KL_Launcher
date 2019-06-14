require "ProfileKeeper"
require "accountPool"

function launch(...)
	--playerName, gamemode, customizrer
	local profile = ProfileKeeper.selectedProfile()
	local account = AccountPool.selectedAccount()

	local ProfileKeeper.check(profile)
	local AccountPool.refresh(account)
	local customizrer = createCustomizer()
	
	launcher.launch(profile, account, customizrer)
end
local accountPool = {}

local profileKeeper = require "profileKeeper"

function accountPool.selectedAccessToken()
    return profileKeeper.authenticationDatabase()[profileKeeper.selectedUser.account]
end

return accountPool
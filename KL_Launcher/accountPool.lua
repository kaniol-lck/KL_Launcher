local accountPool = {}

require "profileKeeper"

function accountPool.selectedAccessToken()
    return profileKeeper.authenticationDatabase()[profileKeeper.selectedUser.account]
end
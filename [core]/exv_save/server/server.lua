local START_MONEY = 2000 -- стартовый капитал
local START_EXV = 0 
local START_LEVEL = 1

local function getRealDate()
	local TIME = getRealTime()
	local DATE_MONTHDAY, DATE_MONTH, DATE_YEAR = string.format("%02d", TIME.monthday), string.format("%02d", TIME.month + 1), TIME.year + 1900
	return DATE_MONTHDAY.."/"..DATE_MONTH.."/"..DATE_YEAR
end

local function createNewAccount(currentAccount, id) -- создание аккаунта
	setAccountData(currentAccount, "exv_account.ID", "id_"..tonumber(id))
	setAccountData(currentAccount, "exv_account.DATE_REG", getRealDate())
	setAccountData(currentAccount, "exv_account.LEVEL", START_LEVEL)
	setAccountData(currentAccount, "exv_account.EXP", START_EXV)
	setAccountData(currentAccount, "exv_account.JOB", '-')
end
addEvent("exv_save.createNewAccount", true)
addEventHandler("exv_save.createNewAccount", root, createNewAccount)

addEvent('exv_save.playerLogin', true)
addEventHandler('exv_save.playerLogin', root, function()
	local acc = getPlayerAccount(source)
	if isGuestAccount(acc) then return end

	local accountMoney = getAccountData(acc, "exv_account.MONEY")

	if not accountMoney then -- информации об игроке нет в БД
		local acc_id = "id_"..tostring(#getAccounts() + 1)
		local acc_date = tostring(getRealDate())
		
		setElementData(source, "player.ID", acc_id)
		setElementData(source, "player.DATE_REG", acc_date)
		setElementData(source, "player.LEVEL", START_LEVEL)
		setElementData(source, "player.EXP", START_EXV)
		setElementData(source, "player.JOB", '-')

		setPlayerMoney(source, START_MONEY)
	else
		local PLAYER_MONEY = accountMoney
		local PLAYER_LEVEL = getAccountData(acc, "exv_account.LEVEL") or START_LEVEL
		local PLAYER_EXP = getAccountData(acc, "exv_account.EXP") or START_EXV
		local PLAYER_JOB = getAccountData(acc, "exv_account.JOB") or '-'
		local PLAYER_SKIN = getAccountData(acc, "exv_account.SKIN") or 0
		local PLAYER_HP = getAccountData(acc, "exv_account.HP") or 100

		setElementData(source, "player.ID", getAccountData(acc, 'exv_account.ID'))
		setElementData(source, "player.DATE_REG", getAccountData(acc, 'exv_account.DATE_REG'))
		setElementData(source, "player.LEVEL", tonumber(PLAYER_LEVEL))
		setElementData(source, "player.EXP", tonumber(PLAYER_EXP))
		setElementData(source, "player.JOB",  PLAYER_JOB)

		setPlayerMoney(source, PLAYER_MONEY)
		setElementModel(source, PLAYER_SKIN)
		setElementHealth(source, PLAYER_HP)
	end

end)

addEventHandler("onPlayerQuit", root, function()
	local account = getPlayerAccount(source)
	if (account) then
		setAccountData(account, "exv_account.ID", tostring(getElementData(source, "player.ID")))
		setAccountData(account, "exv_account.DATE_REG", tostring(getElementData(source, "player.DATE_REG")))

		setAccountData(account, "exv_account.MONEY", tostring(getPlayerMoney(source)))
		setAccountData(account, "exv_account.LEVEL", tostring(getElementData(source, "player.LEVEL")) or START_LEVEL)
		setAccountData(account, "exv_account.EXP", tostring(getElementData(source, "player.EXP")) or START_EXV)
		setAccountData(account, "exv_account.JOB", tostring(getElementData(source, "player.JOB")) or '-')
		setAccountData(account, "exv_account.SKIN", tostring(getElementModel(source)))
		setAccountData(account, "exv_account.HP", tostring(getElementHealth(source)))
	end
end)

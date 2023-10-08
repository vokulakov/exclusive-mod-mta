local minMoneyLimit = 3000000 -- от
local maxMoneyLimit = 90000000 -- до

local playerMoney = getPlayerMoney(localPlayer)

local function getPlayerCaseOfMoney()
	local money = getPlayerMoney(localPlayer)
 	if (money >= tonumber(minMoneyLimit) and money <= tonumber(maxMoneyLimit)) then
 		if getPedOccupiedVehicle(localPlayer) then 
 			setElementData(localPlayer, 'exv_caseMoney.isVehicle', true)
 		end

 		local weaponSlot = getPedWeaponSlot(localPlayer)
 		if weaponSlot ~= 0 and weaponSlot ~= 2 then 
 			setElementData(localPlayer, 'exv_caseMoney.isWeapon', true)
 		end

 		return true
 	else
 		return false
 	end
end

addEventHandler('onClientRender', getRootElement(), function()
	local money = getPlayerMoney(localPlayer)
	if (playerMoney ~= money) then
		setElementData(localPlayer, 'exv_caseMoney.playerAttachedCase', getPlayerCaseOfMoney())
		playerMoney = money
	end
end)

addEventHandler('onClientPlayerWeaponSwitch', getRootElement(), function(prevSlot, newSlot)
	if not getElementData(localPlayer, 'exv_caseMoney.playerAttachedCase') then return end
	if newSlot == 0 or newSlot == 2 then
		setElementData(localPlayer, 'exv_caseMoney.isWeapon', false)
	else
		setElementData(localPlayer, 'exv_caseMoney.isWeapon', true)
	end
end)

addEventHandler('onClientVehicleEnter', getRootElement(), function(player)
    if player ~= getLocalPlayer() then return end
    if not getElementData(localPlayer, 'exv_caseMoney.playerAttachedCase') then return end
    setElementData(localPlayer, 'exv_caseMoney.isVehicle', true)
end)

addEventHandler('onClientVehicleStartExit', getRootElement(), function(player)
	if player ~= getLocalPlayer() then return end
    if not getElementData(localPlayer, 'exv_caseMoney.playerAttachedCase') then return end
    setElementData(localPlayer, 'exv_caseMoney.isVehicle', false)
end)

addEventHandler('onClientElementDestroy', getRootElement(), function()
	if getElementType(source) ~= 'vehicle' and getPedOccupiedVehicle(getLocalPlayer()) ~= source then return end
	if not getElementData(localPlayer, 'exv_caseMoney.playerAttachedCase') then return end
    setElementData(localPlayer, 'exv_caseMoney.isVehicle', false)
end)

addEventHandler('onClientResourceStart', getRootElement(), function()
 	setElementData(localPlayer, 'exv_caseMoney.playerAttachedCase', getPlayerCaseOfMoney())
end)

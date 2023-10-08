local function addPlayerCaseOfMoney(player)
	if isElement(getElementData(player, 'exv_caseMoney.playerCase')) then return end

	local x, y, z = getElementPosition (player)
	local case = createObject(1210, x, y, z)
	local i = getElementInterior(player)
	local d = getElementDimension(player)
	setElementDimension(case, d)
	setElementInterior(case, i)
	exports.exv_boneAttach:attachElementToBone(case, player, 11, 0, -0.02, 0.3, 180, 0, 0)
	setElementData(player, 'exv_caseMoney.playerCase', case)
end

local function destroyPlayerCaseOfMoney(player)
	local case = getElementData(player, 'exv_caseMoney.playerCase')
	if not isElement(case) then return end
	destroyElement(case)
	removeElementData(player, 'exv_caseMoney.playerCase')
end

addEventHandler('onPlayerSpawn', getRootElement(), function()
	if not getElementData(source, 'exv_caseMoney.playerAttachedCase') then return end
	addPlayerCaseOfMoney(source)
end)

addEventHandler('onPlayerQuit', getRootElement(), function() destroyPlayerCaseOfMoney(source) end)


local dataTable = {
	['exv_caseMoney.playerAttachedCase'] = true, 
	['exv_caseMoney.isWeapon'] = true,
	['exv_caseMoney.isVehicle'] = true,
}

addEventHandler('onElementDataChange', getRootElement(), function(dataName)
	if getElementType(source) ~= 'player' or not dataTable[dataName] then return end
	
	if getElementData(source, 'exv_caseMoney.playerAttachedCase') then
		if getElementData(source, 'exv_caseMoney.isWeapon') then
			return destroyPlayerCaseOfMoney(source)
		else
			addPlayerCaseOfMoney(source)
		end

		if getElementData(source, 'exv_caseMoney.isVehicle') then
			return destroyPlayerCaseOfMoney(source)
		else
			addPlayerCaseOfMoney(source)
		end
	else
		destroyPlayerCaseOfMoney(source)
	end

end)

addEventHandler('onResourceStop', resourceRoot, function()
    for _, player in ipairs (getElementsByType('player')) do
		destroyPlayerCaseOfMoney(player)
		removeElementData(player, 'exv_caseMoney.playerAttachedCase')
		removeElementData(player, 'exv_caseMoney.isWeapon')
		removeElementData(player, 'exv_caseMoney.isVehicle')
	end
end)

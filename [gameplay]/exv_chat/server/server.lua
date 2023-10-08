local TIMER = { }

addCommandHandler("Сказать", function(thePlayer, cmd, ...)
	local message = table.concat ( { ... }, " " )

	if message:find("^/%a") ~= nil then
		return startCommandServer(string.gsub(message, "(/)", ""), thePlayer)
	end

	--[[
	local x, y, z = getElementPosition(thePlayer)
	
	for _, gracze in ipairs(getElementsByType("player")) do
		local x2, y2, z2 = getElementPosition(gracze)
		if (getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) < 25) then
			local int = getElementInterior(thePlayer)
			local dim = getElementDimension(thePlayer)
			local int2 = getElementInterior(gracze)
			local dim2 = getElementDimension(gracze)
			if (int == int2 and dim == dim2) then
				outputChatBox("".. getPlayerName(thePlayer) .." говорит: ".. message, gracze, 255, 255, 255, true)
			end
		end
	end
	]]


	outputChatBox("".. getPlayerName(thePlayer) ..": ".. message, root, 255, 255, 255, true)

	if isTimer(TIMER[thePlayer]) then
		killTimer(TIMER[thePlayer])
	end

	if getPedOccupiedVehicle(thePlayer) or isPedDucked(thePlayer) then
		return
	end
	setPedAnimation(thePlayer, "ped", "IDLE_chat", -1)
	TIMER[thePlayer] = setTimer(setPedAnimation, 3000, 1, thePlayer, false)

end)

-- серверные команды
local params = {}
function startCommandServer(message, player)
	local commands = split(message, " ")
	for k, v in ipairs(commands) do
		params[k] = v
	end
	local state = executeCommandHandler(params[1], player, params[2], params[3], params[4], params[5], params[6], params[7])
	
	if not state then
		triggerClientEvent("startCommandClient", player, params[1], params[2], params[3], params[4], params[5], params[6], params[7])
	end
	
	for i = 1, 9 do
		params[i] = nil
	end
end


-- БЛОК КОМАНД --
local commands = { 
	['say'] = true,
	['me'] = true,
	--['debugscript'] = true
}

addEventHandler('onPlayerCommand', root, function(command)
	if commands[command] then
		triggerClientEvent(source, 'exv_notify.addNotification', source, 'Неизвестная команда', 2)
		cancelEvent()
	end
end)

addEventHandler("onPlayerLogout", root, function() 
	triggerClientEvent(source, 'exv_notify.addNotification', source, "Неизвестная команда", 2)
	cancelEvent() 
end)

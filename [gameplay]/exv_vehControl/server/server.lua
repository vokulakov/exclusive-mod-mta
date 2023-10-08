local function playerBindKey(plr)
	bindKey(plr, "k", "down", doToggleLocked) -- закрытие дверей
	bindKey(plr, "l", "down", doToggleLights) -- фары
	bindKey(plr, "2", "down", doToggleEngine) -- двигатель
end

addEventHandler("onResourceStart", resourceRoot, function()
	for _, p in ipairs(getElementsByType("player")) do
		playerBindKey(p)
	end
end)

addEventHandler("onPlayerJoin", root, function()
	playerBindKey(source)
end)

local lights = { }

local function setVehicleLightOn(veh, rl, gl, bl)

	if rl <= lights[veh].color.r and rl <= 245 then rl = rl + 10
	else rl = lights[veh].color.r
	end

	if gl <= lights[veh].color.g and gl <= 245 then gl = gl + 10 
	else gl = lights[veh].color.g
	end

	if bl <= lights[veh].color.b and bl <= 245 then bl = bl + 10
	else bl = lights[veh].color.b  
	end

	setVehicleHeadLightColor(veh, rl, gl, bl)

	if rl == lights[veh].color.r and gl == lights[veh].color.g and bl == lights[veh].color.b then
		if isTimer(lights[veh].timer) then
			killTimer(lights[veh].timer)
			lights[veh].timer = nil
		end
		return
	end

	lights[veh].timer = setTimer(setVehicleLightOn, 50, 1, veh, rl, gl, bl)
end

local function setVehicleLightOff(veh, rl, gl, bl)

	if rl >= 15 then rl = rl - 15
	else rl = 0
	end

	if gl >= 15 then gl = gl - 15 
	else gl = 0
	end

	if bl >= 15 then bl = bl - 15
	else bl = 0
	end

	setVehicleHeadLightColor(veh, rl, gl, bl)

	if rl == 0 and gl == 0 and bl == 0 then
		if isTimer(lights[veh].timer) then
			killTimer(lights[veh].timer)
			lights[veh].timer = nil
		end
		setVehicleOverrideLights(veh, 1)
		return
	end

	lights[veh].timer = setTimer(setVehicleLightOff, 50, 1, veh, rl, gl, bl)
end

function doToggleLights(player)
	local veh = getPedOccupiedVehicle(player)
	if not veh or getPedOccupiedVehicleSeat(player) ~= 0 then return end

	if not lights[veh] then
		lights[veh] = { }
		lights[veh].state = 0
	end

	if lights[veh].state == 0 then

		local rl, gl, bl = getVehicleHeadLightColor(veh)

		if lights[veh].color then
			rl, gl, bl = lights[veh].color.r, lights[veh].color.g, lights[veh].color.b
		end
		
		if rl == 0 and gl == 0 and bl == 0 then
			rl = 255 gl = 255 bl = 255
		end

		lights[veh].color = {r = rl, g = gl, b = bl}

		setVehicleHeadLightColor(veh, 0, 0, 0)
		setVehicleOverrideLights(veh, 2)

		if isTimer(lights[veh].timer) then
			killTimer(lights[veh].timer)
			lights[veh].timer = nil
		end

		lights[veh].state = 1
	elseif lights[veh].state == 1 then
		setVehicleOverrideLights(veh, 2)
		setVehicleHeadLightColor(veh, 0, 0, 0)

		-- ИМИТАЦИЯ РАЗЖИГАНИЯ КСЕНОНА --
		lights[veh].timer = setTimer(setVehicleLightOn, 50, 1, veh, 0, 0, 0)
		---------------------------------

		lights[veh].state = 2
	elseif lights[veh].state == 2 then
		if isTimer(lights[veh].timer) then
			killTimer(lights[veh].timer)
			lights[veh].timer = nil
		end

		lights[veh].timer = setTimer(setVehicleLightOff, 50, 1, veh, lights[veh].color.r, lights[veh].color.g, lights[veh].color.b)
		
		lights[veh].state = 0
	end
	
	triggerClientEvent(player, 'exv_vehcontrol.doToggleLights', player)
end

function doToggleLocked(player)
	local veh = getPedOccupiedVehicle(player)
	if not veh or getPedOccupiedVehicleSeat(player) ~= 0 then return end

	if isVehicleLocked(veh) then
        setVehicleLocked(veh, false) 
    else                           
        setVehicleLocked(veh, true)
    end

    triggerClientEvent(player, 'exv_vehcontrol.doToggleLocked', player)
end

function doToggleEngine(player)
	local veh = getPedOccupiedVehicle(player)
	if not veh or getPedOccupiedVehicleSeat(player) ~= 0 then return end

	if getVehicleEngineState(veh) then
		setVehicleEngineState(veh, false)
		triggerEvent('exv_fueling.onPlayerEngineSwitch', player, veh) -- EXPORT К СИСТЕМЕ ЗАПРАВКИ
	else
		triggerClientEvent(player, 'exv_vehcontrol.doToggleEngine', player)
		setTimer(setVehicleEngineState, 1200, 1, veh, true)
	end

end

----------------------------------
-- РЕМЕНЬ БЕЗОПАСНОСТИ [НАЧАЛО] --
----------------------------------
local function attachBelt(player)
	local vehicle = getPedOccupiedVehicle(player)
    if not vehicle then return end
    local seat = getPedOccupiedVehicleSeat(player) + 1
	local data = getElementData(vehicle, "seat:"..seat)
	
	if data == true then
		--outputChatBox("Вы отстегнули ремень!", player, 0, 255, 0)
		--triggerClientEvent(player, 'exv_notify.addNotification', player, 'Вы отстегнули ремень безопасности', 1)
		triggerClientEvent(player, 'belt_system.doToggleBelt', player, 'veh_belt_out')
		setElementData(player, "belt_system:isPlayerOnBelt", false)
		setElementData(player, "belt_system:isPlayerSeat", nil)
	elseif data == false then
		--outputChatBox("Вы пристегнули ремень!", player, 0, 255, 0)
		--triggerClientEvent(player, 'exv_notify.addNotification', player, 'Вы пристегнули ремень безопасно\nсти', 1)
		triggerClientEvent(player, 'belt_system.doToggleBelt', player, 'veh_belt_in')
		setElementData(player, "belt_system:isPlayerOnBelt", true)
		setElementData(player, "belt_system:isPlayerSeat", seat)
	end

	setElementData(vehicle, "seat:"..seat, not data)
end

addEventHandler("onPlayerVehicleEnter", root, function(veh, seat)
	if not isVehicleHaveBelt(getElementModel(veh)) then
		
		if getElementType(source) == 'ped' then
			return 
		end
		
		if getElementData(source, 'belt_system:isPlayerOnBelt') then
			local seat = getElementData(source, 'belt_system:isPlayerSeat')
			setElementData(veh, "seat:"..seat, false)
			
			setElementData(source, "belt_system:isPlayerOnBelt", false)

			setElementData(source, "belt_system:isPlayerSeat", nil)
			unbindKey(source, "b", "down", attachBelt)
		else
			unbindKey(source, "b", "down", attachBelt)
		end
		
		bindKey(source, "b", "down", attachBelt)

		--triggerClientEvent(source, 'exv_notify.addNotification', source, "Что бы пристегнуться, нажмите 'B'", 1)
	end
end)

addEventHandler("onPlayerVehicleExit", root, function(veh, seat)
	if not isVehicleHaveBelt(getElementModel(veh)) then
		local seat = seat + 1
        setElementData(veh, "seat:"..seat, false)
		setElementData(source, "belt_system:isPlayerOnBelt", false)
		setElementData(source, "belt_system:isPlayerSeat", nil)
        unbindKey(source, "b", "down", attachBelt)
	end
end)

addEventHandler("onPlayerWasted", root, function()
	setElementData(source, "belt_system:isPlayerOnBelt", false)
	setElementData(source, "belt_system:isPlayerSeat", nil)
	unbindKey(source, "b", "down", attachBelt)
	triggerClientEvent(source, 'belt_system:stopSound', source, false)
end)

addEventHandler("onVehicleStartExit", root, function(player, seat)
	if getElementData(source, "seat:"..seat + 1) then
		--triggerClientEvent(player, 'exv_notify.addNotification', player, "Отстегните ремень безопасности!\n(нажмите 'B')", 2)
		cancelEvent()
		return
	else
		triggerClientEvent(player, 'belt_system:stopSound', player, false)
	end

	if isVehicleLocked(source) then 
		--triggerClientEvent(player, 'exv_notify.addNotification', player, "Откройте двери! (нажмите 'K')", 2)
		cancelEvent() 
		return
	end -- если двери заблокированы, то игрок не сможет выйти!
end)

addEventHandler("onVehicleStartEnter", root, function(player, seat, jacked)
	if getElementData(source, "seat:"..seat + 1) then
		if isElement(jacked) and getPedOccupiedVehicleSeat(jacked) == seat then 
			cancelEvent() 
			return
		end
		setElementData(source, "seat:"..seat + 1,  false)
	end
end)

addEventHandler("onElementDestroy", root, function()
 	if getElementType(source) == "vehicle" then
 		local vehicleOccupants = getVehicleOccupants(source)
 		if not vehicleOccupants then return end
		for seat, player in pairs (vehicleOccupants) do
			if player and getElementType(player) == 'player' then
		   	 	local seat = seat + 1
				if getElementData(source, "seat:"..seat) then
			    	setElementData(source, "seat:"..seat, false)
					setElementData(source, "belt_system:isPlayerOnBelt", false)
					setElementData(source, "belt_system:isPlayerSeat", nil)
			    	unbindKey(player, "b", "down", attachBelt)
			    else
					setElementData(player, "belt_system:isPlayerOnBelt", false)
					setElementData(player, "belt_system:isPlayerSeat", nil)
			    	triggerClientEvent(player, 'belt_system:stopSound', player, false)
			    	unbindKey(player, "b", "down", attachBelt)
				end
			end
		end
  	end
end)

addEvent('belt_system.onVehicleDamage', true)
addEventHandler('belt_system.onVehicleDamage', root, function(player, loss)
	if not player then return end
	setElementHealth(player, getElementHealth(player) - loss)
end)
----------------------------------
-- РЕМЕНЬ БЕЗОПАСНОСТИ [КОНЕЦ] ---
----------------------------------
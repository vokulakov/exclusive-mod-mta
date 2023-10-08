local SOUNDS = { }

addEvent('exv_vehcontrol.doToggleLights', true)
addEventHandler('exv_vehcontrol.doToggleLights', root, function()
	if isElement(SOUNDS.light) then
		destroyElement(SOUNDS.light)
	end

	SOUNDS.light = exports["exv_sounds"]:playSound('veh_lightswitch')
end)

addEvent('exv_vehcontrol.doToggleLocked', true)
addEventHandler('exv_vehcontrol.doToggleLocked', root, function()
	if isElement(SOUNDS.lock) then
		destroyElement(SOUNDS.lock)
	end

	SOUNDS.lock = exports["exv_sounds"]:playSound('veh_doorlock')
end)

addEvent('exv_vehcontrol.doToggleEngine', true)
addEventHandler('exv_vehcontrol.doToggleEngine', root, function()
	if isElement(SOUNDS.engine) then
		destroyElement(SOUNDS.engine)
	end

	SOUNDS.engine = exports["exv_sounds"]:playSound('veh_starter_car')
end)


----------------------------------
-- РЕМЕНЬ БЕЗОПАСНОСТИ [НАЧАЛО] --
----------------------------------
local THE_TIMER 

local function onBeltChange(data)
	if data == true then
	    if not isElement(SOUNDS.belt_alarm) then

	   		SOUNDS.belt_alarm = exports["exv_sounds"]:playSound('veh_belt_alarm', true)
	    	setSoundVolume(SOUNDS.belt_alarm, 0.7)
	    end
	 else
	 	if isTimer(THE_TIMER) then
			killTimer(THE_TIMER)
		end
	   	if isElement(SOUNDS.belt_alarm) then
			destroyElement(SOUNDS.belt_alarm)
		end
	end
end
addEvent('belt_system:stopSound', true)
addEventHandler('belt_system:stopSound', root, onBeltChange)

addEvent('belt_system.doToggleBelt', true)
addEventHandler('belt_system.doToggleBelt', root, function(sound_name)
	if isElement(SOUNDS.belt) then
		destroyElement(SOUNDS.belt)
	end

	SOUNDS.belt = exports["exv_sounds"]:playSound(sound_name)
end)

addEventHandler("onClientPlayerVehicleEnter", root, function(veh)
	if source == localPlayer then
		if not isVehicleHaveBelt(getElementModel(veh)) then
			THE_TIMER = setTimer(onBeltChange, 2000, 1, true)
		end
	end
end)

addEventHandler("onClientPlayerVehicleExit", getRootElement(), function(veh)
	if source == localPlayer then
		if isTimer(THE_TIMER) then
			killTimer(THE_TIMER)
		end
		onBeltChange(false)
	end
end)

addEventHandler("onClientElementDataChange", root, function(dataName, _, value)
	if (getElementType(source) == "player") and (source == localPlayer) then
		local veh = getPedOccupiedVehicle(localPlayer)
		if not veh then return end
		if (dataName == "belt_system:isPlayerOnBelt") then
			onBeltChange(not value)
		end
	end
end)

local impactTimer

addEventHandler("onClientVehicleCollision", root, function(_, force)
	if (force > 300) then
		local damage = force / 45
		if not isVehicleHaveBelt(getElementModel(source)) then
			local vehicleOccupants = getVehicleOccupants(source)
			for seat, player in pairs(vehicleOccupants) do

				if not player.inVehicle then
					return
				end

				local seat = seat + 1
				local isBeltAttached = getElementData(source, "seat:"..seat)
				if not isBeltAttached then
					if player ~= localPlayer then return end
					
					triggerServerEvent('belt_system.onVehicleDamage', root, player, damage)

					toggleAllControls(false)

					if (not impactTimer) then
						impactTimer = setTimer(function()
							toggleAllControls(true)
							toggleControl("radar", false) -- отключение стандартной карты
						end, 2500, 1)
					else
						if (impactTimer) and (impactTimer:isValid()) then
							impactTimer:destroy()
						end
				
						impactTimer = setTimer(function()
							toggleAllControls(true)
							toggleControl("radar", false) -- отключение стандартной карты
						end, 2500, 1)
					end
					
					triggerEvent('exv.showDeadScreen', player, true, damage)
					setTimer(triggerEvent, 2500, 1, 'exv.showDeadScreen', player, false)

				end
			end
		end
	end
end)
----------------------------------
-- РЕМЕНЬ БЕЗОПАСНОСТИ [КОНЕЦ] ---
----------------------------------








-----------------------------
-- КРУИЗ КОНТРОЛЬ [НАЧАЛО] --
-----------------------------

-----------------------------
-- КРУИЗ КОНТРОЛЬ [КОНЕЦ] --
-----------------------------
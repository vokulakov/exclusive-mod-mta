local storage = { }
local unloadMarker = { }

local employed_count = 0 -- количество текущих работников

local vehicles = { } -- храним информацию по машине

-- МАРКЕР ПОГРУЗКИ --
storage.marker = createMarker(setups.loadPosition - Vector3(0, 0, 2), "cylinder", 2.5, 170, 0, 0, 150)
setElementVisibleTo(storage.marker, root, false)

for _, data in ipairs(setups.unloadPosition) do
	local markerCar = createMarker(data.car_pos[1], data.car_pos[2], data.car_pos[3] - 2, "cylinder", 2.5, 170, 0, 0, 150)
	local markerPlayer = createMarker(data.pl_pos[1], data.pl_pos[2], data.pl_pos[3] - 1, "cylinder", 1, 170, 0, 0, 150)

	setElementVisibleTo(markerCar, root, false)
	setElementVisibleTo(markerPlayer, root, false)

	table.insert(unloadMarker, {markerCar, markerPlayer})
end

addEventHandler("onResourceStart", resourceRoot, function()
	local EMPLOYED = createPickup(setups.employed.x, setups.employed.y, setups.employed.z, 3, 1275, 1000)

	setElementData(EMPLOYED, "exv_jobDelivery:isDeliveryJobMarker", true)

	addEventHandler("onPickupHit", EMPLOYED, function(player)
		if getElementType(player) ~= 'player' then return end

		triggerClientEvent(player, 'exv_jobDelivery.showDeliveryJobWindow', player)
	end)
end)

function getVehicleOnLoad(marker) -- ЕСТЬ ЛИ МАШИНА НА ЗАГРУЗКЕ?

	for _, veh in ipairs(getElementsByType("vehicle")) do
		if veh:getData('exv_jobDelivery.isVehicle') and isElementWithinMarker(veh, marker or storage.marker) then
			return veh
		end
	end

	return false
end

function onVehicleHitMarker(vehicle) 
	if vehicle.type ~= 'vehicle' then return end
	if vehicle.model ~= setups.car then return end

	if not vehicle:getData('exv_jobDelivery.isVehicle') then
		return
	end

	local player = vehicle:getData('exv_jobDelivery.isVehicleDriver')

	local veh = getVehicleOnLoad(source) 
	if isElement(veh) and veh ~= vehicle then
		triggerClientEvent(player, 'exv_notify.addNotification', player, 'Место погрузки занято! Пожалуйста, подождите.', 2)
		return 
	end


	setElementVisibleTo(source, player, false)

	setVehicleDoorOpenRatio(vehicle, 4, 1, 1500)
	setVehicleDoorOpenRatio(vehicle, 5, 1, 1500)

	vehicles[vehicle].isMarkerTimer = setTimer(
		function(veh, player, marker)
			if not isElement(veh) then return end

			if vehicles[veh].isMarker then return end

			-- не забудь здесь сделать так, чтобы маркер видели грузчики и водитель --
			local carMarker = createMarker(0, 0, 0, "arrow", 1, 255, 0, 0, 255)
			attachElements(carMarker, vehicle, 0, -3.7, 0.5)

			veh:setData('exv_jobDelivery.isVehicleMarker', carMarker)
			carMarker:setData('exv_jobDelivery.isMarkerFromVehicle', veh)

			-- нужно определять, машина на разгрузке или на погрузке --
			if marker ~= storage.marker then 
				triggerClientEvent(player, 'exv_jobLoader.isPlayerUnloadVehicle', player, veh, true)
			end


			vehicles[veh].isMarker = carMarker
		end, 
	1500, 1, vehicle, player, source)

	if source == storage.marker then -- погрузка
		vehicle:setData('exv_jobDelivery.isVehicleOnLoad', true) -- машина под погрузкой
		vehicle:setData('exv_jobDelivery.isVehicleOnMarkerLoad', true) -- машина находится на маркере загрузки
	else -- разгрузка
		-- не забудь здесь сделать так, чтобы маркер видели грузчики и водитель --
		local markers = vehicle:getData('exv_jobDelivery.isVehicleUnloadMarker')
		setElementVisibleTo(markers[2], player, true)	
	end

	triggerClientEvent(player, 'exv_jobDelivery.removeBlipOnStorage', player)  -- ?
	removeEventHandler('onMarkerHit', source, onVehicleHitMarker)      -- ?
	addEventHandler('onMarkerLeave', source, onVehicleLeaveMarker)     -- ?
end

local function closeVehicleDoor(vehicle)
	if not isElement(vehicle) then return end

	setVehicleDoorOpenRatio(vehicle, 4, 0, 1500)
	setVehicleDoorOpenRatio(vehicle, 5, 0, 1500)

	if isTimer(vehicles[vehicle].isMarkerTimer) then 
		killTimer(vehicles[vehicle].isMarkerTimer)
		vehicles[vehicle].isMarkerTimer = nil
	end

	if vehicles[vehicle].isMarker then
		vehicles[vehicle].isMarker:removeData('exv_jobDelivery.isMarkerFromVehicle')
		vehicle:removeData('exv_jobDelivery.isVehicleMarker')

		if vehicle:getData('exv_jobDelivery.isVehicleOnMarkerLoad') then
			vehicle:removeData('exv_jobDelivery.isVehicleOnMarkerLoad')
		end

		vehicles[vehicle].isMarker:removeData('exv_jobDelivery.isMarkerFromVehicle')

		detachElements(vehicles[vehicle].isMarker, vehicle)
		destroyElement(vehicles[vehicle].isMarker)

		vehicles[vehicle].isMarker = nil
	end
end

function onVehicleLeaveMarker(vehicle) 
	if vehicle.type ~= 'vehicle' then return end
	if vehicle.model ~= setups.car then return end

	if not vehicle:getData('exv_jobDelivery.isVehicle') then
		return
	end

	local player = vehicle:getData('exv_jobDelivery.isVehicleDriver')

	setElementVisibleTo(source, player, true)

	local markers = vehicle:getData('exv_jobDelivery.isVehicleUnloadMarker')
	local position 

	if markers then -- МАРКЕР РАЗГРУЗКИ
		setElementVisibleTo(markers[2], player, false)
		position = {x = markers[1].position.x, y = markers[1].position.y, z = markers[1].position.z}

		triggerClientEvent(player, 'exv_jobLoader.isPlayerUnloadVehicle', player, vehicle, false)
	end

	closeVehicleDoor(vehicle)

	triggerClientEvent(player, 'exv_jobDelivery.createBlipOnStorage', player, position or false)

	removeEventHandler('onMarkerLeave', source, onVehicleLeaveMarker) -- ?
	addEventHandler('onMarkerHit', source, onVehicleHitMarker)		  -- ?
end

function getPlayerUnloadPosition(player, vehicle) -- ОПРЕДЕЛЯЕМ МЕСТО РАЗГРУЗКИ
	local delPlace = unloadMarker[math.random(1, #unloadMarker)]

	setElementVisibleTo(delPlace[1], player, true)

	vehicle:setData('exv_jobDelivery.isVehicleUnloadMarker', delPlace)
	delPlace[2]:setData('exv_jobDelivery.isUnloadMarkerFromVehicle', vehicle)
	addEventHandler("onMarkerHit", delPlace[1], onVehicleHitMarker)

	local position = {x = delPlace[1].position.x, y = delPlace[1].position.y, z = delPlace[1].position.z}
	triggerClientEvent(player, 'exv_jobDelivery.createBlipOnStorage', player, position)
end

function addVehicleBox(vehicle) -- ДОБАВИТЬ ЯЩИК 
	local vehicle_tunk = vehicle:getData('exv_jobDelivery.isVehicleTrunk')

	for i, slot in ipairs(vehicle_tunk.tunk) do
		if not slot.box then
			local box = createObject(1271, 0, 0, 0)
			setObjectScale(box, 0.7)
			setElementCollisionsEnabled(box, false)
			attachElements(box, vehicle, slot.x, slot.y, slot.z)
			slot.box = box

			vehicle_tunk.count = vehicle_tunk.count + 1
			vehicle:setData('exv_jobDelivery.isVehicleTrunk', {tunk = vehicle_tunk.tunk, count = vehicle_tunk.count})
			break
		end
	end

	if vehicle_tunk.count == #vehicle_tunk.tunk then -- ПОСЛЕДНИЙ ЯЩИК
		local result = { }

	    for i = #vehicle_tunk.tunk, 1, -1 do
	    	table.insert(result, vehicle_tunk.tunk[i])
	    end
    
		vehicle:setData('exv_jobDelivery.isVehicleTrunk', {tunk = result, count = vehicle_tunk.count})

		closeVehicleDoor(vehicle)

		vehicle:removeData('exv_jobDelivery.isVehicleOnLoad')

		-- необходимо убрать блип для водителя со склада 		 --
		-- а так же не забыть перенаправить грузчиков на корабль --
		local isDriver = vehicle:getData('exv_jobDelivery.isVehicleDriver')

		getPlayerUnloadPosition(isDriver, vehicle)

		setTimer(triggerClientEvent, 100, 1, isDriver, 'exv_jobLoader.blipOnStorage', isDriver, true)
		-----------------------------------------------------------

		removeEventHandler('onMarkerHit', storage.marker, onVehicleHitMarker)		-- ?
		removeEventHandler('onMarkerLeave', storage.marker, onVehicleLeaveMarker)	-- ?
	end
end
addEvent('exv_jobDelivery.addVehicleBox', true)
addEventHandler('exv_jobDelivery.addVehicleBox', root, addVehicleBox)

function takeVehicleBox(vehicle) -- убрать ящик
	local vehicle_tunk = vehicle:getData('exv_jobDelivery.isVehicleTrunk')
	local theBox = false

	for _, slot in ipairs(vehicle_tunk.tunk) do
		if isElement(slot.box) then
			-- destroyElement(slot.box) -- --
			vehicle_tunk.count = vehicle_tunk.count - 1
			theBox = slot.box
			slot.box = false

			vehicle:setData('exv_jobDelivery.isVehicleTrunk', {tunk = vehicle_tunk.tunk, count = vehicle_tunk.count})
			break 
		end
	end

	if vehicle_tunk.count == 0 then 
		setTimer(closeVehicleDoor, 1000, 1, vehicle)

		local isDriver = vehicle:getData('exv_jobDelivery.isVehicleDriver')
		local markers = vehicle:getData('exv_jobDelivery.isVehicleUnloadMarker')

		removeEventHandler('onMarkerHit', markers[1], onVehicleHitMarker) 
		removeEventHandler('onMarkerLeave', markers[1], onVehicleLeaveMarker)
	end

	return theBox
end
addEvent('exv_jobDelivery.takeVehicleBox', true)
addEventHandler('exv_jobDelivery.takeVehicleBox', root, takeVehicleBox)

addEvent('exv_jobDelivery.onPlayerDownBox', true)
addEventHandler('exv_jobDelivery.onPlayerDownBox', root, function(vehicle)
	if not isElement(vehicle) then
		return
	end

	local isDriver = vehicle:getData('exv_jobDelivery.isVehicleDriver')
	local markers = vehicle:getData('exv_jobDelivery.isVehicleUnloadMarker')

	local vehicle_tunk = vehicle:getData('exv_jobDelivery.isVehicleTrunk')
	if vehicle_tunk.count == 0 then 
		-- ЗАВЕРШАЕМ РЕЙС --

		local function getTaskReward(xt, yt, zt)
			local x, y, z = storage.marker.position
			return math.floor(setups.pricePerFeet*getDistanceBetweenPoints3D(xt, yt, zt, x, y, z))
		end

		local money = getTaskReward(markers[1].position.x, markers[1].position.y, markers[1].position.z)

		setTimer(function(pl, salary)
			givePlayerMoney(pl, salary)
			triggerClientEvent(pl, 'exv_notify.addInformation', pl, 'ЗАРПЛАТА: '..salary..'$', true)
		end, 5000, 1, isDriver, money)

		triggerEvent('exv_exp.givePlayerExperience', isDriver, isDriver, 2) -- выдача опыта

		triggerClientEvent(isDriver, 'exv_jobDelivery.removeBlipOnStorage', isDriver)  -- ?
		triggerClientEvent(isDriver, 'exv_jobLoader.isPlayerUnloadVehicle', isDriver, vehicle, false)
		-- не забудь здесь сделать так, чтобы маркер видели грузчики и водитель --
		setElementVisibleTo(markers[2], isDriver, false)
		--------------------

		-- НОВЫЙ РЕЙС --
		setTimer(function(player)
			triggerClientEvent(player, 'exv_jobDelivery.createBlipOnStorage', player)
			triggerClientEvent(player, 'exv_notify.addNotification', player, 'Отправляйтесь в порт Los-Santos.\nИщи метку в навигаторе (F11).', 1)
			setElementVisibleTo(storage.marker, player, true)
			addEventHandler("onMarkerHit", storage.marker, onVehicleHitMarker)
		end, 5000, 1, isDriver)
		----------------

		vehicle:removeData('exv_jobDelivery.isVehicleUnloadMarker')
		vehicle:removeData('exv_jobDelivery.isUnloadMarkerFromVehicle')
	end

end)

local function givePlayerJobVehicle(player)
	if not isElement(player) then return end

	local veh = createVehicle(setups.car, setups.carPosition, 0, 0, -90)
	veh:setColor(255, 255, 255)
	veh:setVariant(255, 255)
	setElementData(veh, 'exv_jobDelivery.isVehicle', true)
	setElementData(veh, 'exv_jobDelivery.isVehicleDriver', player)
	warpPedIntoVehicle(player, veh) 

	addEventHandler("onVehicleStartEnter", veh, function(player, seat)

		if seat == 2 or seat == 3 then -- БЛОКИРУЕМ ЗАДНИЕ ДВЕРИ
			return cancelEvent()
		end

		if seat == 0 then
			if player:getData('exv_jobDelivery.isVehicleFromPlayer') ~= source then -- ДАДИМ ЛЕЩА ВОРУ!
				triggerClientEvent(player, 'exv_notify.addNotification', player, 'У вас нет ключей от этого\nтранспорта!', 2)
				cancelEvent()
			end
		end

	end)

	local vehicle_box = { }

	for _, value in ipairs(setups.carBoxPosition) do
		table.insert(vehicle_box, {x = value.x, y = value.y, z = value.z, box = false})
	end

	veh:setData('exv_jobDelivery.isVehicleTrunk', {tunk = vehicle_box, count = 0})

	addEventHandler("onVehicleDamage", veh, function()
		setVehicleDoorState(source, 4, 0)
		setVehicleDoorState(source, 5, 0)
		if vehicles[source].isMarker then
			setVehicleDoorOpenRatio(source, 4, 1)
			setVehicleDoorOpenRatio(source, 5, 1)
		end
	end)

	triggerClientEvent(player, 'exv_jobDelivery.createBlipOnStorage', player)

	setElementVisibleTo(storage.marker, player, true)
	addEventHandler("onMarkerHit", storage.marker, onVehicleHitMarker)

	player:setData('exv_jobDelivery.isVehicleFromPlayer', veh)
	vehicles[veh] = { }
end

addCommandHandler('give', function(player)
	triggerEvent('exv_jobDelivery.changeJobDelivery', player)
	local vehicle = player:getData('exv_jobDelivery.isVehicleFromPlayer')
	vehicle.position = setups.loadPosition
end)

local function destroyPlayerVehicle(player)
	local vehicle = player:getData('exv_jobDelivery.isVehicleFromPlayer')

	if isElement(vehicle) then
	
		closeVehicleDoor(vehicle)

		local vehicle_tunk = vehicle:getData('exv_jobDelivery.isVehicleTrunk')
		for _, slot in ipairs(vehicle_tunk.tunk) do 
			if isElement(slot.box) then
				detachElements(slot.box, vehicle)
				destroyElement(slot.box)

				slot.box = false
				vehicle_tunk.count = vehicle_tunk.count - 1
				vehicle:setData('exv_jobDelivery.isVehicleTrunk', {tunk = vehicle_tunk.tunk, count = vehicle_tunk.count})
			end
		end

		vehicle:removeData('exv_jobDelivery.isVehicleOnLoad')
		vehicle:removeData('exv_jobDelivery.isVehicle')
		vehicle:removeData('exv_jobDelivery.isVehicleDriver')
		vehicle:removeData('exv_jobDelivery.isVehicleOnMarker')
		vehicle:removeData('exv_jobDelivery.isVehicleTrunk')
		vehicle:removeData('exv_jobDelivery.isVehicleUnloadMarker')
		vehicle:removeData('exv_jobDelivery.isUnloadMarkerFromVehicle')

		removeEventHandler("onMarkerHit", storage.marker, onVehicleHitMarker)
		destroyElement(vehicle)

		vehicles[vehicle] = nil
	end

	player:removeData('exv_jobDelivery.isVehicleFromPlayer')
end

local function onPlayerServerQuit(player, quit, restart)
	local deliveryData = getElementData(player, 'exv_jobDelivery:deliveryData')
	if not deliveryData then return end

	employed_count = employed_count - 1

	destroyPlayerVehicle(player)

	if not restart then
		triggerClientEvent(player, 'exv_jobLoader.blipOnStorage', player, true)
		triggerClientEvent(player, 'exv_jobDelivery.removeBlipOnStorage', player)
	end

	setElementModel(player, deliveryData.oldSkin)
	triggerClientEvent(player, 'exv_notify.addNotification', player, 'Вы закончили рабочую смену.', 1)

	setElementData(player, 'exv_caseMoney.isWeapon', false) 

	removeElementData(player, "exv_jobDelivery:deliveryData")
end
addEvent('exv_jobDelivery.onPlayerServerQuit', true)
addEventHandler('exv_jobDelivery.onPlayerServerQuit', root, onPlayerServerQuit)

addEventHandler("onPlayerWasted", root, function()
	setTimer(onPlayerServerQuit, 5000, 1, source, false, false)
end)

addEventHandler("onElementDestroy", root, function()
	if source.type ~= 'vehicle' then return end
	local isDriver = source:getData('exv_jobDelivery.isVehicleDriver')
	if not isDriver then return end

	onPlayerServerQuit(isDriver, false, false)
end)

addEventHandler("onVehicleExplode", root, function()
	local isDriver = source:getData('exv_jobDelivery.isVehicleDriver')
	if not isDriver then return end

	onPlayerServerQuit(isDriver, false, false)
end)

addEventHandler("onResourceStop", resourceRoot, function()
	for _, player in ipairs(getElementsByType('player')) do
		if getElementData(player, 'player.JOB') == "jobDelivery" then
			onPlayerServerQuit(player, false, true)
		end
	end
end)

addEvent('exv_jobDelivery.changeJobDelivery', true)
addEventHandler('exv_jobDelivery.changeJobDelivery', root, function()
	local deliveryData = getElementData(source, 'exv_jobDelivery:deliveryData')

	if not deliveryData then

		if tonumber(employed_count) >= setups.employed_count then
			triggerClientEvent(source, 'exv_notify.addNotification', source, 'Нам жаль, но у нас не осталось\nсвободного транспорта. Ожидайте!', 2)
			return
		end
		employed_count = employed_count + 1

		givePlayerJobVehicle(source)

		setElementData(source, 'exv_jobDelivery:deliveryData', {delCount = 0, oldSkin = getElementModel(source), salary = 0})
		setElementModel(source, setups.skin)
		setElementData(source, 'exv_caseMoney.isWeapon', true) -- убираем кейс
		triggerClientEvent(source, 'exv_notify.addNotification', source, 'Вы начали рабочую смену.\nОтправляйтесь в порт Los-Santos.\nИщи метку в навигаторе (F11).', 1)
		----------------------
	else
		onPlayerServerQuit(source, false)
	end
end)


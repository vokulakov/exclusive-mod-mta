local playersInTuning = {}

local function playerExitTonerGarage(player)
    if not isElement(player) then
        return
    end
    if not playersInTuning[player] then
        return
    end
    if player.vehicle then
        player.vehicle.interior = 0
        player.vehicle.dimension = 0
        player.vehicle.engineState = true
    else
        player.dimension = 0
    end
    player.interior = 0
    playersInTuning[player] = nil
    clearPlayerDimension(player)

    triggerClientEvent(player, "exv_carToner.playerExitTonerGarage", resourceRoot)
    fadeCamera(player, true, 1)
end

addEvent("exv_carToner.playerExitTonerGarage", true)
addEventHandler("exv_carToner.playerExitTonerGarage", resourceRoot, function (...)
    fadeCamera(client, false, 1)
    setTimer(playerExitTonerGarage, 1100, 1, client, ...)
end)

local function playerEnterTonerGarage(player)
    if not isElement(player) or not player.vehicle then
        return
    end
    -- Позиция
    player.vehicle.position = Config.garageVehiclePosition
    player.vehicle.rotation = Config.garageVehicleRotation
    -- Интерьер
    player.interior = Config.garageInterior
    player.vehicle.interior = Config.garageInterior

    local dimension = getDimensionForPlayer(player)
    player.dimension = dimension
    player.vehicle.dimension = dimension

    player.vehicle.velocity = Vector3()
    player.vehicle.turnVelocity = Vector3()
    player.vehicle.engineState = false

    triggerClientEvent(player, "exv_carToner.playerEnterTonerGarage", resourceRoot, true)
    fadeCamera(player, true, 1)
end

addEvent("exv_carToner.playerEnterTonerGarage", true)
addEventHandler("exv_carToner.playerEnterTonerGarage", resourceRoot, function (x, y, z)
	if client.dimension ~= 0 then
        return
    end

    if not client.vehicle or client.vehicle.controller ~= client then
        return
    end

    if not Config.allowedVehicleTypes[client.vehicle.vehicleType] then
        return
    end

    -- Высадить пассажиров
    for seat, player in pairs(client.vehicle.occupants) do
        if player ~= client then
            player.vehicle = nil
        end
    end

    playersInTuning[client] = true
   	fadeCamera(client, false, 1)
    setTimer(playerEnterTonerGarage, 1100, 1, client, marker)
end)

-- Выбор свободного dimension для игрока

local dimensionsOffset = 2000
local usedDimensions = {}

function getDimensionForPlayer(player)
    if not isElement(player) then
        return 0
    end
    local maxPlayers = getMaxPlayers()
    for i = 1, maxPlayers do
        if not isElement(usedDimensions[i]) or usedDimensions[i] == player then
            usedDimensions[i] = player
            return dimensionsOffset + i
        end
    end
end

function clearPlayerDimension(player)
    if not isElement(player) then
        return
    end
    if isElement(usedDimensions[player.dimension - dimensionsOffset]) then
        usedDimensions[player.dimension - dimensionsOffset] = nil
    end
end

addEventHandler("onResourceStop", resourceRoot, function ()
    for i = 1, getMaxPlayers() do
        if isElement(usedDimensions[i]) then
            usedDimensions[i].dimension = 0
            usedDimensions[i].interior = 0
            if usedDimensions[i].vehicle then
                usedDimensions[i].vehicle.dimension = 0
                usedDimensions[i].vehicle.interior = 0
            end
        end
    end
end)



addEventHandler("onResourceStart", resourceRoot, function()

	for _, garageData in ipairs(Config.tonerGarageMarkers) do
		local cuboid = garageData.garage
		local garageCube = createColCuboid(cuboid.xyz, cuboid.wdh)

		addEventHandler("onColShapeHit", garageCube, function(player)
			if (player.type == "player") then
				if not player.vehicle or player.vehicle.controller ~= player then
        			return
    			end
				if (not isGarageOpen(cuboid.id)) then
					setGarageOpen(cuboid.id, true)
				end
			end
		end)

		addEventHandler("onColShapeLeave", garageCube, function(player)
			if (player.type == "player") then
				if not player.vehicle or player.vehicle.controller ~= player then
        			return
    			end
				if (isGarageOpen(cuboid.id)) then
                    if #getElementsWithinColShape(garageCube, "vehicle") > 1 then
                        return
                    end
					setTimer(setGarageOpen, 2000, 1, cuboid.id, false)
				end
			end
		end)
	end

end)

addEvent("exv_carToner.tonerGarageBuyVehicleToner", true)
addEventHandler("exv_carToner.tonerGarageBuyVehicleToner", root, function(money)
    if not source.vehicle then
        return
    end
    source.vehicle:setData('exv_vehicle.isToner', true)

    setTimer(function(pl, money)
        takePlayerMoney(pl, money)
        triggerClientEvent(pl, 'exv_notify.addInformation', pl, 'ТОНИРОВКА: -'..money..'$', true)
    end, 5500, 1, source, money)

    triggerClientEvent(source, 'exv_notify.addNotification', source, 'Вы затонировали автомобиль\nза '..money..'$', 1, false)
end)

addEvent("exv_carToner.tonerGarageRemoveVehicleToner", true)
addEventHandler("exv_carToner.tonerGarageRemoveVehicleToner", root, function()
    if not source.vehicle then
        return
    end
    source.vehicle:removeData('exv_vehicle.isToner')

    triggerClientEvent(source, 'exv_notify.addNotification', source, 'Вы сняли тонировку с транспорта.', 1, false)
end)
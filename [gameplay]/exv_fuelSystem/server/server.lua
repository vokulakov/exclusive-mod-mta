local REFILLS = { }

addEventHandler("onResourceStart", resourceRoot, function()

	-- ГЕНЕРАЦИЯ ЗАПРАВОК [НАЧАЛО] --
	local xmlFuelingData = xmlLoadFile("assets/garageData.xml")
	for ID, node in ipairs(xmlNodeGetChildren(xmlFuelingData)) do
		
		local moreKids = xmlNodeGetChildren(node)
		for i, v in ipairs(moreKids) do
			REFILLS[ID] = { }
			local mx = tonumber(xmlNodeGetAttribute(v, 'x'))
			local my = tonumber(xmlNodeGetAttribute(v, 'y'))
			local mz = tonumber(xmlNodeGetAttribute(v, 'z'))

			REFILLS[ID][i] = { }
			REFILLS[ID][i].pickup = createPickup(mx, my, mz, 3, 1650, 0)
			REFILLS[ID][i].colSphere = createColSphere(mx, my, mz, 2)

			setElementData(REFILLS[ID][i].pickup, 'exv_fuelSystem.isRefills', true)
			addEventHandler("onColShapeHit", REFILLS[ID][i].colSphere, onVehicleColSphereHit)
		end
	end
	xmlUnloadFile(xmlFuelingData)
	-- ГЕНЕРАЦИЯ ЗАПРАВОК [КОНЕЦ] --

end)

function onPlayerCanisterColSphereHit(player)
	if getElementType(player) ~= 'player' then return end
	triggerClientEvent(player, 'fuel_system.showBuyCanisterWindow', player)
end

function onVehicleColSphereHit(vehicle)
	if getElementType(vehicle) == 'player' then return end
	local driver = getVehicleOccupant(vehicle)
	if not driver then return end
	
	triggerClientEvent(driver, 'fuel_system.showFuelingWindow', driver)
end

-----------------------------------
-- РАБОТА С ТРАНСПОРТОМ [НАЧАЛО] --
-----------------------------------

local vehiclesData = { }
local vehicleTaimer = { }

addEventHandler("onResourceStart", resourceRoot, function()

	local xmlVehiclesData = xmlLoadFile("assets/carData.xml")
    for i, node in ipairs(xmlNodeGetChildren(xmlVehiclesData)) do
        vehiclesData[tonumber(xmlNodeGetAttribute(node, 'id'))] = {}
		vehiclesData[tonumber(xmlNodeGetAttribute(node, 'id'))].fuel = tonumber(xmlNodeGetAttribute(node, 'fuel'))
		vehiclesData[tonumber(xmlNodeGetAttribute(node, 'id'))].typeOfFuel = xmlNodeGetAttribute(node, 'type')
    end
	xmlUnloadFile(xmlVehiclesData)

	for _, veh in ipairs(getElementsByType("vehicle")) do 
		setVehicleFuel(veh)
	end

end)

function setVehicleFuel(veh)
	if isTimer(vehicleTaimer[veh]) then return end
	if getVehicleType(veh) ~= 'Automobile' and getVehicleType(veh) ~= 'Bike' and getVehicleType(veh) ~= 'Monster Truck' and getVehicleType(veh) ~= 'Quad' then return end
	local model = getElementModel(veh)
	if not vehiclesData[model] then model = 0 end

	setElementData(veh, 'exv_fuelSystem.fuel', getElementData(veh, 'exv_fuelSystem.fuel') or vehiclesData[model].fuel)
	setElementData(veh, 'exv_fuelSystem.fuelMax', getElementData(veh, 'exv_fuelSystem.fuelMax') or vehiclesData[model].fuel)
	setElementData(veh, 'exv_fuelSystem.typeOfFuel', getElementData(veh, 'exv_fuelSystem.typeOfFuel') or vehiclesData[model].typeOfFuel)

	vehicleTaimer[veh] = setTimer(fuelUse, 1000, 1, veh)
end

function fuelUse(veh)
	if not veh then return end
	
	local newX, newY, newZ = getElementPosition(veh)
	local oldX = getElementData(veh, 'exv_fuelSystem.oldX') or newX
	local oldY = getElementData(veh,'exv_fuelSystem.oldY') or newY
	local oldZ = getElementData(veh, 'exv_fuelSystem.oldZ') or newZ

	local vel = (getDistanceBetweenPoints2D(oldX, oldY, newX, newY))
	if vel == 0 then takeCarFuel(veh, 0.005) end

	local oldX = setElementData(veh, 'exv_fuelSystem.oldX', newX)
	local oldY = setElementData(veh, 'exv_fuelSystem.oldY', newY)
	local oldZ = setElementData(veh, 'exv_fuelSystem.oldZ', newZ)

	takeCarFuel(veh, math.floor(vel)/coeff)
	
	vehicleTaimer[veh] = setTimer(fuelUse, 1000, 1, veh)
end

function takeCarFuel(veh, amount)
	if getVehicleEngineState(veh) then
		local fuel = getElementData(veh, 'exv_fuelSystem.fuel')
		if not fuel then return end
		if fuel <= 0 then setVehicleEngineState(veh, false) end
		fuel = fuel - amount
		if fuel < 0 then fuel = 0 end
		setElementData(veh, 'exv_fuelSystem.fuel', fuel)
	end
end

local function destroyVehicleFuel()
	if getElementType(source) ~= 'vehicle' then return end
	if isTimer(vehicleTaimer[source]) then
		killTimer(vehicleTaimer[source])
	end
end
addEventHandler("onVehicleExplode", getRootElement(), destroyVehicleFuel)
addEventHandler("onElementDestroy", getRootElement(), destroyVehicleFuel)

function startFuelUse(p, seat)
    if seat ~= 0 then return end
	setVehicleFuel(source)
end
addEventHandler("onVehicleEnter", getRootElement(), startFuelUse)

function addCarFuel(veh, amount, money)
	if not veh then return end
	setElementData(veh, 'exv_fuelSystem.fuel', getElementData(veh, 'exv_fuelSystem.fuel') + amount)
	takePlayerMoney(source, money)
	--outputChatBox('Вы заправили '..amount..' л на '..money..' ₽', source, 0, 255, 0)
	triggerClientEvent(source, 'exv_notify.addNotification', source, 'Вы заправили '..amount..' л на '..money..' ₽', 1, false)
end
addEvent('arst_fueling.onVehicleRefuel', true)
addEventHandler('arst_fueling.onVehicleRefuel', getRootElement(), addCarFuel)

--[[
addCommandHandler('fuel', function(player)
	local veh = getPedOccupiedVehicle(player)
	setElementData(veh, 'fuel', 1)
end)
]]

----------------------------------
-- РАБОТА С ТРАНСПОРТОМ [КОНЕЦ] --
----------------------------------
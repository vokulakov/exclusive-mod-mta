-- rl_glass_r -- переднее левое
-- fl_glass_r -- заднее левое

-- fr_glass_r -- переднее правое
-- rr_glass_r -- заднее правое

local vehiclesData = {

    [529] = true, -- Porsche Panamera Turbo
    [466] = true, -- Porsche Cayene Turbo
    [490] = true, -- Range Rover SVA
    [596] = true, -- BMW X5M F

    [554] = true,
    [580] = true,
    [502] = true,
    [506] = true,
    [535] = true,
    [477] = true,
    [526] = true,
    [575] = true,
    [401] = true,
    [589] = true,
    [436] = true,
    [576] = true,
    [418] = true
}

--------------------------------------------
--------------------------------------------

local streamedVehicles = { }

local function getDoorOpenRatio(vehicle, id)
    local ratio = getVehicleDoorOpenRatio(vehicle, id)

    if not ratio or getVehicleDoorState(vehicle, id) == 4 then
        setVehicleDoorOpenRatio(vehicle, id, 0)
        ratio = 0
    end

    return ratio
end

addEventHandler("onClientPreRender", root, function ()
    for vehicle, components in pairs(streamedVehicles) do
        local fx, fy, fz = 0, 0, 72

    	-- ПЕРЕДНИЕ ДВЕРИ
    	local leftDoorRatio = getDoorOpenRatio(vehicle, 2)
        local rightDoorRatio = getDoorOpenRatio(vehicle, 3)

		setVehicleComponentRotation(vehicle, components.door_lf, -leftDoorRatio*fx, -leftDoorRatio*fy, -leftDoorRatio*fz)
		setVehicleComponentRotation(vehicle, components.window_lf, -leftDoorRatio*fx, -leftDoorRatio*fy, -leftDoorRatio*fz)

		setVehicleComponentRotation(vehicle, components.door_rf, -rightDoorRatio*fx, rightDoorRatio*fy, rightDoorRatio*fz)
		setVehicleComponentRotation(vehicle, components.window_rf, -rightDoorRatio*fx, rightDoorRatio*fy, rightDoorRatio*fz)
		
        setVehicleComponentRotation(vehicle, 'fr_glass_r', -rightDoorRatio*fx, rightDoorRatio*fy, rightDoorRatio*fz)
        setVehicleComponentRotation(vehicle, 'fl_glass_r', -leftDoorRatio*fx, -leftDoorRatio*fy, -leftDoorRatio*fz)

		-- ЗАДНИЕ ДВЕРИ
		local leftDoorRatio = getDoorOpenRatio(vehicle, 4)
        local rightDoorRatio = getDoorOpenRatio(vehicle, 5)

		setVehicleComponentRotation(vehicle, components.door_lr, -leftDoorRatio*fx, -leftDoorRatio*fy, -leftDoorRatio*fz)
		setVehicleComponentRotation(vehicle, components.door_rr, -rightDoorRatio*fx, rightDoorRatio*fy, rightDoorRatio*fz)

        setVehicleComponentRotation(vehicle, 'rr_glass_r', -rightDoorRatio*fx, rightDoorRatio*fy, rightDoorRatio*fz)
        setVehicleComponentRotation(vehicle, 'rl_glass_r', -leftDoorRatio*fx, -leftDoorRatio*fy, -leftDoorRatio*fz)
    end
end)

local function setupVehicleComponentsOpening(vehicle)
    if not isElement(vehicle) then
        return
    end

    streamedVehicles[vehicle] = {
        -- ПЕРЕДНИЕ ДВЕРИ
        door_rf     = "door_rf",
        door_lf     = "door_lf",

        -- ЗАДНИЕ ДВЕРИ
        door_rr     = "door_rr",
        door_lr     = "door_lr",

        -- ОКНА 
        window_lf = "window_lf",
        window_rf = "window_rf",
    }

end

addEventHandler("onClientElementStreamIn", root, function ()
    if source and getElementType(source) == "vehicle" and vehiclesData[getElementModel(source)] then
    	setupVehicleComponentsOpening(source)
    end
end)

addEventHandler("onClientElementStreamOut", root, function()
    if source and getElementType(source) == "vehicle" and vehiclesData[getElementModel(source)] then
        streamedVehicles[source] = nil
    end
end)

addEventHandler("onClientElementModelChange", root, function(oldModel)
	if source and getElementType(source) == "vehicle" and vehiclesData[oldModel] then
		streamedVehicles[source] = nil
	end
end)

addEventHandler("onClientElementDestroy", root, function()
    if source and getElementType(source) == "vehicle" and vehiclesData[getElementModel(source)] then
        streamedVehicles[source] = nil
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    for i, vehicle in ipairs(getElementsByType("vehicle")) do
        if isElementStreamedIn(vehicle) and vehiclesData[getElementModel(vehicle)] then
        	setupVehicleComponentsOpening(vehicle)
        end
    end
end)
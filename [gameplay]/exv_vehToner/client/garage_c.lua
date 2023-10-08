local isActive = false
local currentMarker = nil
local soundBackground

-- Обработка входа в тюнинг
local function handleTuningExit()
    
    if not isActive then
        return
    end

    if localPlayer.vehicle then
        removeEventHandler("onClientElementDestroy", localPlayer.vehicle, exitTonerGarage)
    end
    -- Телепортировать игрока к выходу
    if currentMarker then
        local targetPosition = currentMarker.position
        local targetRotation = Vector3(0, 0, currentMarker.angle)
        if localPlayer.vehicle then
            if localPlayer.vehicle.vehicleType == "Bike" then
                localPlayer.vehicle.frozen = true
                setTimer(function ()
                    localPlayer.vehicle.position = targetPosition + Vector3(0, 0, 1)
                    setElementRotation(localPlayer.vehicle, targetRotation)
                    setCameraTarget(localPlayer)
                end, 50, 1)

                setTimer(function ()
                    localPlayer.vehicle.velocity = Vector3()
                    localPlayer.vehicle.frozen = false
                end, 500, 1)
            else
                localPlayer.vehicle.position = targetPosition + Vector3(0, 0, 1)
                setElementRotation(localPlayer.vehicle, targetRotation)
                setTimer(function ()
                    setCameraTarget(localPlayer)
                    localPlayer.vehicle.frozen = false
                    localPlayer.vehicle.velocity = Vector3()
                end, 50, 1)
            end
        else
            localPlayer.position = targetPosition
            localPlayer.rotaion = targetRotation
        end
    end
    currentMarker = nil

    showTonerUI(false)
    stopTuningCamera()


    isActive = false
    toggleAllControls(true, true)
    fadeCamera(true, 1)

    -------------------------------------------------------
    -- ТУТ МОЖНО ВСТАВИТЬ ФУНКЦИИ ПРИ ВЫХОДЕ ИЗ ПОКРАСКИ --
    triggerEvent("exv_showui.setVisiblePlayerUI", root, true)
    showChat(true)
    toggleControl("radar", false) -- отключение стандартной карты
    saveVehicleToner()

    if soundBackground then
        stopSound(soundBackground)
    end
    -------------------------------------------------------
end

-- Обработка выхода из тюнинга
addEvent("exv_carToner.playerExitTonerGarage", true)
addEventHandler("exv_carToner.playerExitTonerGarage", resourceRoot, handleTuningExit)

local function enterTonerGarage(marker)
    if isActive then
        return
    end

    currentMarker = marker

    triggerServerEvent("exv_carToner.playerEnterTonerGarage", resourceRoot, 
        marker.position.x, 
        marker.position.y, 
        marker.position.z
    )
end

function exitTonerGarage()
    if not isActive then
        return
    end
    triggerServerEvent("exv_carToner.playerExitTonerGarage", resourceRoot)
end

addEvent("exv_carToner.playerEnterTonerGarage", true)
addEventHandler("exv_carToner.playerEnterTonerGarage", resourceRoot, function()
    if not localPlayer.vehicle then
        handleTuningExit()
        return
    end
    GarageObject.dimension = localPlayer.dimension
    GarageObject.interior  = localPlayer.interior

    addEventHandler("onClientElementDestroy", localPlayer.vehicle, exitTonerGarage)

    toggleAllControls(false, true)
    showTonerUI(true)
    
    startTuningCamera()

    ------------------------------------------------------
    -- ТУТ МОЖНО ВСТАВИТЬ ФУНКЦИИ ПРИ ВХОДЕ В ТОНЕРОВКУ --
    triggerEvent("exv_showui.setVisiblePlayerUI", root, false)
    showChat(false)

    soundBackground = exports['exv_sounds']:playSound('paintBG', true)
    setSoundVolume(soundBackground, 0.3)
    ------------------------------------------------------

    isActive = true

    setTimer(function ()
        if localPlayer.vehicle and isActive then
            localPlayer.vehicle.frozen = true
        end
    end, 3000, 1)
end)

local function garageMarkerHit(player)
    if player ~= localPlayer then
        return 
    end
    
    local markerData = source:getData("exv_carToner:garageMarkerData")
    if not markerData then
        return false
    end

    local verticalDistance = localPlayer.position.z - source.position.z
    if verticalDistance > 5 or verticalDistance < -1 then
        return
    end

    if localPlayer.vehicle and localPlayer.vehicle.controller == localPlayer then

        if not Config.vehicleTexture[getElementModel(localPlayer.vehicle)] then
            return 
        end

        setElementVelocity(localPlayer.vehicle, 0, 0, 0)
        enterTonerGarage(markerData)
    end

end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    GarageObject = createObject(Config.tonerGarageModel, Config.tonerGaragePosition)
    GarageObject.dimension = 1337
    GarageObject.interior = Config.garageInterior

    for i, markerData in ipairs(Config.tonerGarageMarkers) do
    	local marker = createMarker(
            markerData.position - Vector3(0, 0, 1),
            "cylinder",
            Config.garageMarkerRadius,
            unpack(Config.garageMarkerColor)
        )

        local blip = createBlipAttachedTo(marker, Config.garageMarkerBlip, 0, 255, 255, 255, 255, 0, 450)
        --blip.visibleDistance = 700
        marker:setData("exv_carToner:garageMarkerData", markerData, false)

        addEventHandler("onClientMarkerHit", marker, garageMarkerHit)
    end

end)

-- ЗВУК КОРАБЛЬ --
local shipSound = playSound3D("https://wav-library.net/sounds/0-0-1-6213-20", 2839.0646972656, -2393.2783203125, 42.313152313232, true) 
setSoundMaxDistance(shipSound, 500)
setSoundEffectEnabled(shipSound, "distortion", true)

-- НАДПИСЬ НАД ПИКАПОМ [НАЧАЛО] --
local FUELING_STREAMED_TEXT = {}

local function dxDrawCustomText(text, x1, y1, x2, y2, color, scale)
	dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1, x2, y2, color, scale, "default-bold", "center", "center")
end

addEventHandler("onClientRender", root, function()
	local cx, cy, cz = getCameraMatrix()
	for _, pickup in pairs(FUELING_STREAMED_TEXT) do
		local xP, yP, zP = getElementPosition(pickup.pickup)
		if (isLineOfSightClear(xP, yP, zP, cx, cy, cz, true, true, false, false, true, true, true, nil)) then
			local x, y = getScreenFromWorldPosition(xP, yP, zP + pickup.z)
			if x and y then
				local distance = getDistanceBetweenPoints3D(cx, cy, cz, xP, yP, zP)
				if distance < 65 then
					dxDrawCustomText(pickup.text, x, y, x, y, tocolor(255, 255, 0), 1)
				end
			end
		end
	end
end)

addEventHandler("onClientElementStreamIn", root, function()
	if getElementType(source) == "pickup" then
		if getElementData(source, "exv_jobLoader:isLoaderJobMarker") then
			FUELING_STREAMED_TEXT[source] = { pickup = source, text = 'Работа грузчика', z = 0.6 }
		end
	end
end)

addEventHandler("onClientElementStreamOut", root, function()
	if getElementType(source) == "pickup" and getElementData(source, "exv_jobLoader:isLoaderJobMarker") then
		FUELING_STREAMED_TEXT[source] = nil
	end
end)
-- НАДПИСЬ НАД ПИКАПОМ [КОНЕЦ] --

local sW, sH = guiGetScreenSize()
local UI = { ['loader'] = {} }

-- GUI [НАЧАЛО] --
local function showLoaderJobWindow()
	if source ~= localPlayer then return end
	if isElement(UI['loader'].wnd) then return end

	if getElementData(localPlayer, 'player.JOB') ~= "jobLoader" then
		triggerEvent('exv_notify.addNotification', localPlayer, 'Вы не работаете в порту города\nLos-Santos. Посетите биржу труда.', 2)
		return
	end

	local loaderData = getElementData(localPlayer, 'exv_jobLoader:loaderData')
	
	UI['loader'].wnd = guiCreateWindow(sW/2-350/2, sH/2-120/2, 350, 120, "Работа грузчика", false)

	local wnd_info, wnd_do 

	if not loaderData then
		wnd_info = 'Ваша задача - переносить ящики со склада.\nОплата производится за каждый ящик.\nВы готовы приступить к работе?'
		wnd_do = 'Приступить к работе'
	else
		wnd_info = 'За рабочую смену вы перенесли '..loaderData.boxCount..' ящиков.\nВаша зарплата составляет '..loaderData.salary..'$\nВы точно хотите закончить работу?'
		wnd_do = 'Закончить рабочую смену'
	end

	UI['loader'].lbl_info = guiCreateLabel(0, 0.2, 1, 0.5, wnd_info, true, UI['loader'].wnd)
	guiSetFont(UI['loader'].lbl_info, "default-bold-small")
	guiLabelSetHorizontalAlign(UI['loader'].lbl_info, "center", false)
	guiLabelSetVerticalAlign(UI['loader'].lbl_info, "top")
	guiLabelSetColor(UI['loader'].lbl_info, 0, 185, 255)

	UI['loader'].but_do = guiCreateButton(140, 85, 220, 25, wnd_do, false, UI['loader'].wnd)
	guiSetProperty(UI['loader'].but_do, "NormalTextColour", "ff5af542")

	UI['loader'].but_close = guiCreateButton(0, 85, 120, 25, "Закрыть", false, UI['loader'].wnd)
    guiSetProperty(UI['loader'].but_close, "NormalTextColour", "ffd43422")

    addEventHandler('onClientGUIClick', UI['loader'].wnd, function(button)
    	if not isElement(UI['loader'].wnd) then return end

    	if button == "left" and isElement(UI['loader'].wnd) then
    		if source == UI['loader'].but_close or source == UI['loader'].but_do then

    			if source == UI['loader'].but_do then
    				triggerServerEvent('exv_jobLoader.changeJobLoader', localPlayer)
    			end

    			destroyElement(UI['loader'].wnd)
    			showCursor(false)
    		end
    	end

    end)

	showCursor(true)
end
addEvent('exv_jobLoader.showLoaderJobWindow', true)
addEventHandler('exv_jobLoader.showLoaderJobWindow', root, showLoaderJobWindow)
-- GUI [КОНЕЦ] --


local isPlayerTargetBox
local isPlayerClickedMouse = false
local isPlayerTargetSphere 

local function setPlayerTargetBox()
	local isPlayerBox = getElementData(localPlayer, 'exv_jobLoader:isPlayerBox')

	if isPlayerTargetBox and not isPlayerBox then
		isPlayerClickedMouse = true
		if isPedDucked(localPlayer) then setPedControlState(localPlayer, 'crouch', true) end

		triggerServerEvent('exv_jobLoader.setBoxPlayer', root, localPlayer, isPlayerTargetBox)
		setTimer(function() exports['exv_sounds']:playSound('box_up') end, 1000, 1)


		-- НАДО СДЕЛАТЬ ТАК, ЧТОБЫ ИГРОК НЕ МОГ ВЫКИНУТЬ ЯЩИК ИЗ МАШИНЫ --
		local veh = isPlayerTargetBox:getData('exv_jobDelivery.isMarkerFromVehicle')
		if isElement(veh) then
			exports['exv_buttons']:dxHideHelpButton()
			isPlayerTargetBox = false
			unbindKey("mouse2", "down", setPlayerTargetBox)
			return
		end

		setTimer(function()
			exports['exv_buttons']:dxShowHelpButton("Выбросить ящик", "mouse_right")
			isPlayerTargetBox = false
		end, 2000, 1)

	else
		if not isPlayerBox or isPlayerTargetBox then return end

		if isElement(isPlayerTargetSphere) then

			-- ДОБАВИМ ЯЩИК В ГРУЗОВИЧОК --
			local veh = isPlayerTargetSphere:getData('exv_jobDelivery.isMarkerFromVehicle')
			if isElement(veh) then
				setTimer(triggerServerEvent, 1000, 1, 'exv_jobDelivery.addVehicleBox', root, veh)
			end

			local veh = isPlayerTargetSphere:getData('exv_jobDelivery.isUnloadMarkerFromVehicle')
			if isElement(veh) then
				setTimer(triggerServerEvent, 1000, 1, 'exv_jobDelivery.onPlayerDownBox', root, veh)
			end

			triggerServerEvent("exv_jobLoader.destroyBoxPlayer", root, localPlayer, true)
		else
			triggerServerEvent("exv_jobLoader.destroyBoxPlayer", root, localPlayer, false)
		end

		setTimer(function() exports['exv_sounds']:playSound('box_down') end, 1000, 1)

		isPlayerTargetSphere = false
		setTimer(function() isPlayerClickedMouse = false end, 5000, 1)
		unbindKey("mouse2", "down", setPlayerTargetBox)
	end

	exports['exv_buttons']:dxHideHelpButton()
end

local function onPlayerTargetBox() -- ВЫВОДИМ ПОДСКАЗКУ
	if isPlayerClickedMouse then 
		removeEventHandler("onClientRender", root, onPlayerTargetBox)
		return 
	end

	local x, y, z = getElementPosition(isPlayerTargetBox)
	local px, py, pz = getElementPosition(localPlayer)
	local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, px, py, pz)

	if distanceBetweenPoints < 1.8 then 
		exports['exv_buttons']:dxShowHelpButton("Взять ящик", "mouse_right")
	else
		exports['exv_buttons']:dxHideHelpButton()
		removeEventHandler("onClientRender", root, onPlayerTargetBox)
		isPlayerTargetBox = false
		unbindKey("mouse2", "down", setPlayerTargetBox)
	end

end

addEventHandler("onClientPlayerTarget", localPlayer, function(box)
	
	local isDelivery = source:getData('exv_jobDelivery:deliveryData')

	if not getElementData(localPlayer, 'exv_jobLoader:loaderData') and not isDelivery then 
		return 
	end

	-- ПРОВЕРИМ НА ВОДИТЕЛЯ ГРУЗОВИКА --
	if isDelivery then
		local isVehicle = localPlayer:getData('exv_jobDelivery.isVehicleFromPlayer')
		if not isElement(isVehicle) or not isVehicle:getData('exv_jobDelivery.isVehicleOnMarkerLoad') then
			return
		end
	end

	if not box or isPlayerTargetBox or isPlayerClickedMouse then return end
	if not getElementType(box) == "object" then return end
	if not getElementData(box, "exv_jobLoader:isBox" ) then return end
	if getElementData(localPlayer, 'exv_jobLoader:isPlayerBox') then return end

	isPlayerTargetBox = box

	unbindKey("mouse2", "down", setPlayerTargetBox)
	bindKey("mouse2", "down", setPlayerTargetBox)

	addEventHandler("onClientRender", root, onPlayerTargetBox)
end)

-- МАРКЕРЫ / БЛИПЫ --

for _, m in ipairs(JOB_MARKER) do -- СОЗДАТЬ БЛИПЫ РАБОТЫ
	createBlip(m.x, m.y, m.z, 12, 0, 0, 170, 170, 255, 0, 450)
end

local storageBlip, shipBlip, shipMarker, shipSphere

local function createShipMarker(remove) -- СОЗДАТЬ МАРКЕР/БЛИП ДЛЯ РАЗГРУЗКИ (КОРАБЛЬ)

	if remove then
		if isElement(shipMarker) then destroyElement(shipMarker) end
		if isElement(shipBlip) then destroyElement(shipBlip) end
		if isElement(shipSphere) then destroyElement(shipSphere) end

		return
	end

	if not isElement(shipMarker) then
		shipMarker = createMarker(SHIP_POS.x, SHIP_POS.y, SHIP_POS.z, "arrow", 1.5, 255, 0, 0, 255)
		shipBlip = createBlipAttachedTo(shipMarker, 41, 0, 255, 0)
		shipSphere = createColSphere(SHIP_POS.x, SHIP_POS.y, SHIP_POS.z-1, 2)

		addEventHandler("onClientColShapeHit", shipSphere, function(hitPlayer, matchingDimension) 
			if hitPlayer == localPlayer and matchingDimension then
				exports['exv_buttons']:dxShowHelpButton("Положить ящик", "mouse_right")
				isPlayerTargetSphere = source
			end
		end)	

		addEventHandler("onClientColShapeLeave", shipSphere, function(hitPlayer, matchingDimension) 
			if hitPlayer == localPlayer and matchingDimension then
				local isPlayerBox = getElementData(localPlayer, 'exv_jobLoader:isPlayerBox')
				if isPlayerBox then
					exports['exv_buttons']:dxShowHelpButton("Выбросить ящик", "mouse_right")
					isPlayerTargetSphere = false
				end
			end
		end)

	end

end
addEvent('exv_jobLoader.createShipMarker', true)
addEventHandler('exv_jobLoader.createShipMarker', root, createShipMarker)

local function blipOnStorage(remove) -- СОЗДАТЬ БЛИП НА СКЛАДЕ

	if remove then 
		if isElement(storageBlip) then destroyElement(storageBlip) end
		return
	end

	if not isElement(storageBlip) then
		storageBlip = createBlip(BOX_POSITIONS[1].x, BOX_POSITIONS[1].y, BOX_POSITIONS[1].z, 41, 0, 255, 0, 0, 255, 0, 450)
	end
end
addEvent('exv_jobLoader.blipOnStorage', true)
addEventHandler('exv_jobLoader.blipOnStorage', root, blipOnStorage)

---------------------

local function onPlayerMarkerUnloadEvent(hitPlayer, matchingDimension)
	if hitPlayer == localPlayer and matchingDimension then
		local isPlayerBox = getElementData(localPlayer, 'exv_jobLoader:isPlayerBox')

		if isElementWithinMarker(localPlayer, source) then -- onMarkerHit
			if isPlayerBox then
				exports['exv_buttons']:dxShowHelpButton("Положить ящик", "mouse_right")
				isPlayerTargetSphere = source
				bindKey("mouse2", "down", setPlayerTargetBox)
			end
		else                                               -- onMarkerLeave
			if isPlayerBox then
				exports['exv_buttons']:dxHideHelpButton()
				unbindKey("mouse2", "down", setPlayerTargetBox)
				isPlayerTargetSphere = false
				return
			end
		end

	end
end

local function isPlayerUnloadVehicle(vehicle, state)
	if source ~= localPlayer then 
		return
	end

	-- МАРКЕР РАЗГРУЗКИ --
	local markers = vehicle:getData("exv_jobDelivery.isVehicleUnloadMarker")
	if state then
		addEventHandler("onClientMarkerHit", markers[2], onPlayerMarkerUnloadEvent)
		addEventHandler("onClientMarkerLeave", markers[2], onPlayerMarkerUnloadEvent)
	else
		removeEventHandler("onClientMarkerHit", markers[2], onPlayerMarkerUnloadEvent)
		removeEventHandler("onClientMarkerLeave", markers[2], onPlayerMarkerUnloadEvent)
		return
	end

	local marker = vehicle:getData('exv_jobDelivery.isVehicleMarker')

	addEventHandler("onClientMarkerHit", marker, function(hitPlayer, matchingDimension) 
		if hitPlayer == localPlayer and matchingDimension then
			if getElementData(localPlayer, 'exv_jobLoader:isPlayerBox') then
				return
			end
			exports['exv_buttons']:dxShowHelpButton("Взять ящик", "mouse_right")
			bindKey("mouse2", "down", setPlayerTargetBox)
			isPlayerTargetBox = source
		end
	end)

	addEventHandler("onClientMarkerLeave", marker, function(hitPlayer, matchingDimension)
		if hitPlayer == localPlayer and matchingDimension then
			if isPlayerTargetBox then
				exports['exv_buttons']:dxHideHelpButton()
				isPlayerTargetBox = false
				unbindKey("mouse2", "down", setPlayerTargetBox)
			end
 		end
	end)

end
addEvent('exv_jobLoader.isPlayerUnloadVehicle', true)
addEventHandler('exv_jobLoader.isPlayerUnloadVehicle', root, isPlayerUnloadVehicle)

local function isPlayerLoadVehicle(vehicle) -- ПОГРУЗКА В АВТОМОБИЛЬ
	shipBlip = createBlip(Vector3(vehicle.position), 41, 0, 255, 0, 0, 255, 0, 450)

	local marker = vehicle:getData('exv_jobDelivery.isVehicleMarker')

	addEventHandler("onClientMarkerHit", marker, function(hitPlayer, matchingDimension) 
		if hitPlayer == localPlayer and matchingDimension then
			if not getElementData(localPlayer, 'exv_jobLoader:isPlayerBox') then
				return
			end
			exports['exv_buttons']:dxShowHelpButton("Положить ящик", "mouse_right")
			isPlayerTargetSphere = source
		end
	end)

	addEventHandler("onClientMarkerLeave", marker, function(hitPlayer, matchingDimension) 
		if hitPlayer == localPlayer and matchingDimension then
			local isPlayerBox = getElementData(localPlayer, 'exv_jobLoader:isPlayerBox')
			if isPlayerBox then
				exports['exv_buttons']:dxShowHelpButton("Выбросить ящик", "mouse_right")
				isPlayerTargetSphere = false
			end
		end
	end)
end
addEvent('exv_jobLoader.isPlayerLoadVehicle', true)
addEventHandler('exv_jobLoader.isPlayerLoadVehicle', root, isPlayerLoadVehicle)

-- ВОЗМОЖНЫЕ БАГИ --
addEventHandler('onClientVehicleEnter', root, function(player)
	if player ~= localPlayer then return end
	if not getElementData(localPlayer, 'exv_jobLoader:isPlayerBox') then return end
	exports['exv_buttons']:destroyHelpButton()

	triggerServerEvent("exv_jobLoader.destroyBoxPlayer", root, localPlayer)
	setTimer(function() exports['exv_sounds']:playSound('box_down') end, 1000, 1)
	setTimer(function() isPlayerClickedMouse = false end, 5000, 1)
end)

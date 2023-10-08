addEventHandler('onClientVehicleEnter', root, function(thePlayer, seat)
    if thePlayer == localPlayer and seat == 0 then 

    	if getElementData(source, 'exv_autoSchool.isVehicle') or getVehicleType(source) == "Bike" then 
    		return
    	end

    	local licenses_tbl = getElementData(thePlayer, 'player.LICENSES')

    	if licenses_tbl then
    		local licenses = fromJSON(licenses_tbl)
    		if licenses[1] then return end
    	end

	    triggerEvent('exv_notify.addNotification', thePlayer, 'У вас нет водительского\nудостоверения!', 2)
	    setPedControlState(thePlayer, "enter_exit", true)
	end
end)

createBlip(PICKUP_AS.eX, PICKUP_AS.eY, PICKUP_AS.eZ, 55, 0, 255, 0, 0, 255, 0, 450)

-- НАДПИСЬ НАД ПИКАПОМ [НАЧАЛО] --
local STREAMED_TEXT = {}

local function dxDrawCustomText(text, x1, y1, x2, y2, color, scale)
	dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1, x2, y2, color, scale, "default-bold", "center", "center")
end

addEventHandler("onClientRender", root, function()
	local cx, cy, cz = getCameraMatrix()
	for _, pickup in pairs(STREAMED_TEXT) do
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
		local data = getElementData(source, "exv_autoSchool.PickupInfo")
		if data then
			STREAMED_TEXT[source] = { pickup = source, text = data.text, z = data.textZ }
		end
	end
end)

addEventHandler("onClientElementStreamOut", root, function()
	if getElementType(source) == "pickup" and getElementData(source, "exv_autoSchool.PickupInfo") then
		STREAMED_TEXT[source] = nil
	end
end)
-- НАДПИСЬ НАД ПИКАПОМ [КОНЕЦ] --

-- УСТАНОВКА ТЕКСТУРЫ --
local shader = { }

local function setAutoSchoolTexture(vehicle)
	if not shader[vehicle] then
		shader[vehicle] = exports["exv_shaders"]:createShader("texreplace.fx")
	end

	local triangle = getElementData(vehicle, 'exv_autoSchool.isVehicleTriangle')

	engineApplyShaderToWorldTexture(shader[vehicle], "avar_znak", triangle)
	dxSetShaderValue(shader[vehicle], "TEXTURE_REMAP", dxCreateTexture("assets/avar_znak.png"))
end

addEventHandler("onClientElementStreamIn", root, function()
	if getElementType(source) == "vehicle" then
        if not getElementData(source, "exv_autoSchool.isVehicle")  then return end
        setAutoSchoolTexture(source)
	end
end)

addEventHandler("onClientElementDataChange", root, function(dataName)
	if getElementType(source) == "vehicle" and dataName == "exv_autoSchool.isVehicle" then
		setAutoSchoolTexture(source)
	end
end)	
------------------------

local sW, sH = guiGetScreenSize()
local UI = { }

local function showAutoSchoolWindow()
	if source ~= localPlayer then return end
	if isElement(UI.wnd) then return end

	local licenses_tbl = getElementData(localPlayer, 'player.LICENSES')
    	
    if licenses_tbl then
    	local licenses = fromJSON(licenses_tbl)
    	if licenses[1] then 
    		triggerEvent('exv_notify.addNotification', localPlayer, 'Вы уже получили водительское\nудостоверение!', 2)
    		--return 
    	end
    end

	UI.wnd = guiCreateWindow(sW/2-350/2, sH/2-120/2, 350, 120, "Автошкола", false)

	UI.lbl_info = guiCreateLabel(0, 0, 1, 0.8, 'Добро пожаловать в автошколу San Fierro!\n\nДля того, чтобы приступить к экзамену\nнеобходимо заплатить '..PRICE_AS..' $', true, UI.wnd)
	guiSetFont(UI.lbl_info, "default-bold-small")
	guiLabelSetHorizontalAlign(UI.lbl_info, "center", false)
	guiLabelSetVerticalAlign(UI.lbl_info, "center")

	UI.but_start = guiCreateButton(140, 85, 220, 25, "Приступить к экзамену", false, UI.wnd)
	guiSetProperty(UI.but_start, "NormalTextColour", "ff5af542")

	UI.but_close = guiCreateButton(0, 85, 120, 25, "Закрыть", false, UI.wnd)
	guiSetProperty(UI.but_close, "NormalTextColour", "ffd43422")

	addEventHandler('onClientGUIClick', UI.wnd, function(button)
    	if not isElement(UI.wnd) then return end

    	if button == "left" and isElement(UI.wnd) then
    		if source == UI.but_close or source == UI.but_start then

    			if source == UI.but_start then
    				if getPlayerMoney(localPlayer) < PRICE_AS then
    					triggerEvent('exv_notify.addNotification', localPlayer, "У вас недостаточно средств!", 2)
    				else
    					createNextPoint()
    					triggerServerEvent('exv_autoSchool.startAutoSchoolExam', localPlayer)
    				end
    			end

    			showCursor(false)
    			destroyElement(UI.wnd)
    		end
    	end

   	end)

	showCursor(true)
end
addEvent('exv_autoSchool.showAutoSchoolWindow', true)
addEventHandler('exv_autoSchool.showAutoSchoolWindow', root, showAutoSchoolWindow)

-- ЭКЗАМЕН [НАЧАЛО] --
local current_point_id = 1, curM, curB, nextM, nextB

function createNextPoint()

	if isElement(curM) then destroyElement(curM) end
	if isElement(curB) then destroyElement(curB) end

	if isElement(nextM) then destroyElement(nextM) end
	if isElement(nextB) then destroyElement(nextB) end

	if current_point_id - 1 == #EXAM_POINTS then
		triggerServerEvent('exv_autoSchool.stopAutoSchoolExam', localPlayer)
		return
	end

	curM = createMarker(
		EXAM_POINTS[current_point_id].x, 
		EXAM_POINTS[current_point_id].y, 
		EXAM_POINTS[current_point_id].z, 
		'checkpoint', 2, 255, 0, 0, 170
	)

	curB = createBlipAttachedTo(curM, 41, 0, 255, 0, 0, 255)

	addEventHandler("onClientMarkerHit", curM, function(player)
		if player ~= localPlayer then return end

		local veh = getPedOccupiedVehicle(localPlayer)
		if not veh then return end

		if getElementData(veh, 'exv_autoSchool.isVehicle') then
			createNextPoint()
		end
	end)

	current_point_id = current_point_id + 1

	if EXAM_POINTS[current_point_id] == nil then
		return
	end

	setMarkerTarget(
		curM, 
		EXAM_POINTS[current_point_id].x, 
		EXAM_POINTS[current_point_id].y, 
		EXAM_POINTS[current_point_id].z
	)

	nextM = createMarker(
		EXAM_POINTS[current_point_id].x,
		EXAM_POINTS[current_point_id].y,
		EXAM_POINTS[current_point_id].z,
		'checkpoint', 2, 255, 255, 255
	)

	nextB = createBlipAttachedTo(nextM, 41, 0, 255, 0, 0, 170)

end


-- ЭКЗАМЕН [КОНЕЦ] --
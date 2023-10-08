createBlip(PICKUP_INFO.eX, PICKUP_INFO.eY, PICKUP_INFO.eZ, 22, 0, 255, 0, 0, 255, 0, 450)

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
		local data = getElementData(source, "exv_jobDepartament.PickupInfo")
		if data then
			FUELING_STREAMED_TEXT[source] = { pickup = source, text = data.text, z = data.textZ }
		end
	end
end)

addEventHandler("onClientElementStreamOut", root, function()
	if getElementType(source) == "pickup" and getElementData(source, "exv_jobDepartament.PickupInfo") then
		FUELING_STREAMED_TEXT[source] = nil
	end
end)
-- НАДПИСЬ НАД ПИКАПОМ [КОНЕЦ] --

local sW, sH = guiGetScreenSize()
local UI = { }

local function showDepartamentWindow()
	if source ~= localPlayer then return end
	if isElement(UI.wnd) then return end

	if getElementData(localPlayer, 'player.JOB') == '-' then
		UI.wnd = guiCreateWindow(sW/2-350/2, sH/2-330/2, 350, 330, "Биржа труда", false)

		UI.gridList = guiCreateGridList(0.01, 0.07, 1, 0.65, true, UI.wnd)
		guiGridListAddColumn(UI.gridList, "№", 0.15)
		guiGridListAddColumn(UI.gridList, "Организация", 0.5)
		guiGridListAddColumn(UI.gridList, "Требования", 0.25)

		for i, job in ipairs(JOB_TABLE) do
			local row = guiGridListAddRow(UI.gridList)
			guiGridListSetItemText(UI.gridList, row, 1, i..".", false, false)
		 	guiGridListSetItemText(UI.gridList, row, 2, job.title, false, false)
		 	guiGridListSetItemText(UI.gridList, row, 3, "["..job.level.." уровень]", false, false)

		 	guiGridListSetItemData(UI.gridList, row, 1, i)

		 	local r, g, b = 255, 255, 255

		 	if job.level > getElementData(localPlayer, 'player.LEVEL') then
		 		r, g, b = 170, 0, 0
		 	end

		 	guiGridListSetItemColor(UI.gridList, row, 1, r, g, b, 255)
		 	guiGridListSetItemColor(UI.gridList, row, 2, r, g, b, 255)
		 	guiGridListSetItemColor(UI.gridList, row, 3, r, g, b, 255)
		end

		UI.but_jobEmployed = guiCreateButton(0, 0.76, 1, 0.1, "Устроиться на работу", true, UI.wnd)
    	guiSetProperty(UI.but_jobEmployed, "NormalTextColour", "ff00b9ff")
    	guiSetEnabled(UI.but_jobEmployed, false)

		UI.but_close = guiCreateButton(0, 0.88, 1, 0.08, "Закрыть", true, UI.wnd)
	    guiSetProperty(UI.but_close, "NormalTextColour", "ffd43422")
	else
	    UI.wnd = guiCreateWindow(sW/2-350/2, sH/2-120/2, 350, 120, "Биржа труда", false)

		UI.lbl_info = guiCreateLabel(0, 0, 1, 0.8, 'Вы уже имеете работу, желаете уволиться?', true, UI.wnd)
		guiSetFont(UI.lbl_info, "default-bold-small")
	    guiLabelSetHorizontalAlign(UI.lbl_info, "center", false)
	    guiLabelSetVerticalAlign(UI.lbl_info, "center")

	    UI.but_stop = guiCreateButton(140, 85, 220, 25, "Уволиться", false, UI.wnd)
	    guiSetProperty(UI.but_stop, "NormalTextColour", "ff5af542")

		UI.but_close = guiCreateButton(0, 85, 120, 25, "Закрыть", false, UI.wnd)
	    guiSetProperty(UI.but_close, "NormalTextColour", "ffd43422")
	end

    addEventHandler('onClientGUIClick', UI.wnd, function(button)
    	if not isElement(UI.wnd) then return end

    	if button == "left" and isElement(UI.wnd) then

    		local sel, id

    		if isElement(UI.gridList) then
    			sel = guiGridListGetSelectedItem(UI.gridList) 
    			id = guiGridListGetItemData(UI.gridList, sel, 1) or ''
    		end

    		if source == UI.but_close or source == UI.but_jobEmployed or source == UI.but_stop then
    			if source == UI.but_jobEmployed then -- устроиться
	    			local v = JOB_TABLE[tonumber(id)]

	    			if v.level > getElementData(localPlayer, 'player.LEVEL') then
	    				triggerEvent('exv_notify.addNotification', localPlayer, "К сожалению вашего опыта\nнедостаточно, для работы в этой\nорганизации.", 2)
	    			else
	    				triggerServerEvent('exv_jobDepartament.playerEmployed', localPlayer, v.data)
	    				triggerEvent('exv_notify.addNotification', localPlayer, v.text, 1)
	    			end
	    		elseif source == UI.but_stop then
	    			triggerServerEvent('exv_jobDepartament.playerEmployed', localPlayer, '-')
	    			triggerEvent('exv_notify.addNotification', localPlayer, 'Вы уволены с организации.', 1)
	    		end

	    		showCursor(false)
    			destroyElement(UI.wnd)

    			return
    		end

    		if sel == -1 then 
        		guiSetEnabled(UI.but_jobEmployed, false)
        		return 
    		end

    		guiSetEnabled(UI.but_jobEmployed, true)
    	end
	end)

	showCursor(true)
end
addEvent('exv_jobDepartament.showDepartamentWindow', true)
addEventHandler('exv_jobDepartament.showDepartamentWindow', root, showDepartamentWindow)
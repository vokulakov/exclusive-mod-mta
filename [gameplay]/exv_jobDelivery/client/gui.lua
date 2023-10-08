local sW, sH = guiGetScreenSize()
local UI = { ['delivery'] = {} }

-- GUI [НАЧАЛО] --
local function showDeliveryJobWindow()
	if source ~= localPlayer then return end
	if isElement(UI['delivery'].wnd) then return end

	if getElementData(localPlayer, 'player.JOB') ~= "jobDelivery" then
		triggerEvent('exv_notify.addNotification', localPlayer, 'Вы не работаете в нашей организации.\nПосетите биржу труда.', 2)
		return
	end

	local deliveryData = getElementData(localPlayer, 'exv_jobDelivery:deliveryData')
	
	UI['delivery'].wnd = guiCreateWindow(sW/2-350/2, sH/2-120/2, 350, 120, "Работа доставщика продуктов", false)

	local wnd_info, wnd_do 

	if not deliveryData then
		wnd_info = 'Ваша задача - загружать фургон продуктами\nи доставлять в организации.\nОплата производится за каждый рейс.\nВы готовы приступить к работе?'
		wnd_do = 'Приступить к работе'
	else
		wnd_info = 'За рабочую смену вы '..deliveryData.delCount..' сделали рейсов.\nВаша зарплата составляет '..deliveryData.salary..'$\nВы точно хотите закончить работу?'
		wnd_do = 'Закончить рабочую смену'
	end

	UI['delivery'].lbl_info = guiCreateLabel(0, 0.2, 1, 0.5, wnd_info, true, UI['delivery'].wnd)
	guiSetFont(UI['delivery'].lbl_info, "default-bold-small")
	guiLabelSetHorizontalAlign(UI['delivery'].lbl_info, "center", false)
	guiLabelSetVerticalAlign(UI['delivery'].lbl_info, "top")
	guiLabelSetColor(UI['delivery'].lbl_info, 0, 185, 255)

	UI['delivery'].but_do = guiCreateButton(140, 85, 220, 25, wnd_do, false, UI['delivery'].wnd)
	guiSetProperty(UI['delivery'].but_do, "NormalTextColour", "ff5af542")

	UI['delivery'].but_close = guiCreateButton(0, 85, 120, 25, "Закрыть", false, UI['delivery'].wnd)
    guiSetProperty(UI['delivery'].but_close, "NormalTextColour", "ffd43422")

    addEventHandler('onClientGUIClick', UI['delivery'].wnd, function(button)
    	if not isElement(UI['delivery'].wnd) then return end

    	if button == "left" and isElement(UI['delivery'].wnd) then
    		if source == UI['delivery'].but_close or source == UI['delivery'].but_do then

    			if source == UI['delivery'].but_do then
    				triggerServerEvent('exv_jobDelivery.changeJobDelivery', localPlayer)
    			end

    			destroyElement(UI['delivery'].wnd)
    			showCursor(false)
    		end
    	end

    end)

	showCursor(true)
end
addEvent('exv_jobDelivery.showDeliveryJobWindow', true)
addEventHandler('exv_jobDelivery.showDeliveryJobWindow', root, showDeliveryJobWindow)
-- GUI [КОНЕЦ] --

createBlip(setups.employed.x, setups.employed.y, setups.employed.z, 12, 0, 0, 210, 0, 255, 0, 450)

-- НАДПИСЬ НАД ПИКАПОМ [НАЧАЛО] --
local FUELING_STREAMED_TEXT = {}

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
		if getElementData(source, "exv_jobDelivery:isDeliveryJobMarker") then
			FUELING_STREAMED_TEXT[source] = { pickup = source, text = 'Работа доставщика продуктов', z = 0.6 }
		end
	end
end)

addEventHandler("onClientElementStreamOut", root, function()
	if getElementType(source) == "pickup" then
		if getElementData(source, "exv_jobDelivery:isDeliveryJobMarker") then
			FUELING_STREAMED_TEXT[source] = nil
		end
	end
end)
-- НАДПИСЬ НАД ПИКАПОМ [КОНЕЦ] --
local xmlFuelingData = xmlLoadFile("assets/garageData.xml")
for ID, node in ipairs(xmlNodeGetChildren(xmlFuelingData)) do
	local x = tonumber(xmlNodeGetAttribute(node, 'x'))
	local y = tonumber(xmlNodeGetAttribute(node, 'y'))
	local z = tonumber(xmlNodeGetAttribute(node, 'z'))
		
	createBlip(x, y, z, 47, 0, 255, 0, 0, 255, 0, 450)
end

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
		if getElementData(source, "exv_fuelSystem.isRefills") then
			FUELING_STREAMED_TEXT[source] = { pickup = source, text = 'АЗС', z = 0.4 }
		end
	end
end)

addEventHandler("onClientElementStreamOut", root, function()
	if getElementType(source) == "pickup" and getElementData(source, "exv_fuelSystem.isRefills") then
		FUELING_STREAMED_TEXT[source] = nil
	end
end)
-- НАДПИСЬ НАД ПИКАПОМ [КОНЕЦ] --

local sW, sH = guiGetScreenSize()
local UI = { ['refills'] = { }, ['canister'] = { } }

local totals_price = 0
local totals_litres = 0
local fuel_type = -1
local fuel_type_text = "-"

local PRICE = { 	-- ЦЕНЫ
	[1] = 43, 		-- АИ - 92
	[2] = 46, 		-- АИ - 95
	[3] = 53, 		-- АИ - 98
	[4] = 45, 		-- ДТ
}

canister_price = 9000 -- цена одной канистры

local function getVehicleFuelType()
	local veh = getPedOccupiedVehicle(localPlayer)
	if not veh then return end

	local fuel_type = {"АИ-92", "АИ-95", "АИ-98", "ДТ"}
	local result = ""

	local veh_fuel_type = getElementData(veh, 'exv_fuelSystem.typeOfFuel')
	for w in string.gmatch(veh_fuel_type, "%d+") do
		local fuel = fuel_type[tonumber(w)]
		if fuel ~= nil  then
			result = result..' '..tostring(fuel)..', '
		end
	end

	return string.sub(result, 1, result:len() - 2)
end

local function showFuelingWindow()
	UI['refills'].wnd = guiCreateWindow(sW/2-250/2, sH/2-330/2, 250, 330, "АЗС", false)

	UI['refills'].but_ai92 = guiCreateButton(0, 0.13, 1, 0.07, "АИ-92", true, UI['refills'].wnd)
	UI['refills'].but_ai95 = guiCreateButton(0, 0.21, 1, 0.07, "АИ-95", true, UI['refills'].wnd)
	UI['refills'].but_ai98 = guiCreateButton(0, 0.29, 1, 0.07, "АИ-98", true, UI['refills'].wnd)
	UI['refills'].but_dt = guiCreateButton(0, 0.37, 1, 0.07, "ДТ", true, UI['refills'].wnd)

	UI['refills'].lbl_type = guiCreateLabel(0, 0.07, 1, 0.06, 'Вам подходит: '..getVehicleFuelType(), true, UI['refills'].wnd)
	guiSetFont(UI['refills'].lbl_type, "default-bold-small")
    guiLabelSetHorizontalAlign(UI['refills'].lbl_type, "center", false)
    guiLabelSetVerticalAlign(UI['refills'].lbl_type, "top")
    guiLabelSetColor(UI['refills'].lbl_type, 0, 185, 255)

	UI['refills'].lbl_info = guiCreateLabel(0, 0.43, 1, 0.25, 'Тип топлива: -\nЦена за 1 л: -\nЗалить: 0 л\nНа: 0 ₽\n', true, UI['refills'].wnd)
	guiSetFont(UI['refills'].lbl_info, "default-bold-small")
    guiLabelSetHorizontalAlign(UI['refills'].lbl_info, "center", false)
    guiLabelSetVerticalAlign(UI['refills'].lbl_info, "center")
    guiLabelSetColor(UI['refills'].lbl_info, 0, 185, 255)

    UI['refills'].scroll_bar = guiCreateScrollBar(0, 0.67, 1, 0.07, true, true, UI['refills'].wnd)

    UI['refills'].but_fill = guiCreateButton(0, 0.76, 1, 0.1, "Заправить", true, UI['refills'].wnd)
    guiSetProperty(UI['refills'].but_fill, "NormalTextColour", "ff00b9ff")

    UI['refills'].but_close = guiCreateButton(0, 0.88, 1, 0.08, "Закрыть", true, UI['refills'].wnd)
    guiSetProperty(UI['refills'].but_close, "NormalTextColour", "ffd43422")
end

addEvent('fuel_system.showFuelingWindow', true)
addEventHandler('fuel_system.showFuelingWindow', root, function()
	if isElement(UI['refills'].wnd) then return end

	totals_price = 0
	totals_litres = 0
	fuel_type = -1
	fuel_type_text = "-"

	showFuelingWindow()
	showCursor(true)
end)

addEventHandler("onClientGUIClick", getRootElement(), function(button)
	if button == "left" and isElement(UI['refills'].wnd) then
		if source == UI['refills'].but_close then
			destroyElement(UI['refills'].wnd)
			showCursor(false)
			return
		-- ЗАПРАВКА --
		elseif source == UI['refills'].but_fill then
			if totals_litres == 0 then return end
			
			local veh = getPedOccupiedVehicle(localPlayer)
			if not veh then return end

			local vehicleFuel = getElementData(veh, 'exv_fuelSystem.fuel')
			local vehicleFuelMax = getElementData(veh, 'exv_fuelSystem.fuelMax')
			local veh_fuel_type = getElementData(veh, 'exv_fuelSystem.typeOfFuel')

			if string.find(veh_fuel_type, fuel_type) == nil then
				triggerEvent('exv_notify.addNotification', localPlayer, 'Выбранный вид топлива не\nподходит для вашего транспорта.', 2)
				return
			end

			if getPlayerMoney(localPlayer) < totals_price then
				--outputChatBox('У вас недостаточно средств.', 170, 0, 0)
				triggerEvent('exv_notify.addNotification', localPlayer, 'У вас недостаточно средств.', 2)
				return
			end

			local total_fuel = math.ceil(vehicleFuelMax - vehicleFuel)
			if total_fuel < totals_litres or vehicleFuel == vehicleFuelMax then
				totals_litres = total_fuel
				totals_price = total_fuel*PRICE[fuel_type]

				if totals_price == 0 then
					--outputChatBox('Бак полный!', 170, 0, 0)
					triggerEvent('exv_notify.addNotification', localPlayer, 'Бак полный!', 2)
					return
				end
			end

			triggerServerEvent('arst_fueling.onVehicleRefuel', localPlayer, veh, totals_litres, totals_price)
			exports["exv_sounds"]:playSound("sell")
			destroyElement(UI['refills'].wnd)
			showCursor(false)

			return
		--------------
		elseif source == UI['refills'].but_ai92 then 
			fuel_type = 1
			fuel_type_text = 'АИ-92'
		elseif source == UI['refills'].but_ai95 then 
			fuel_type = 2
			fuel_type_text = 'АИ-95'
		elseif source == UI['refills'].but_ai98 then 
			fuel_type = 3
			fuel_type_text = 'АИ-98'
		elseif source == UI['refills'].but_dt then 
			fuel_type = 4 
			fuel_type_text = 'ДТ'
		end

		if fuel_type ~= -1 then
			totals_price = totals_litres*PRICE[fuel_type]
			guiSetText(UI['refills'].lbl_info, 'Тип топлива: '..fuel_type_text..'\nЦена за 1 л: '..PRICE[fuel_type]..' ₽\nЗалить: '..totals_litres..' л\nНа: '..totals_price..' ₽\n')
		end

	end
end)

addEventHandler("onClientGUIScroll", root, function()
	if not isElement(UI['refills'].wnd) then return end
	local scroll_pos = guiScrollBarGetScrollPosition(source)

	local veh = getPedOccupiedVehicle(localPlayer)
	if not veh then return end

	local fuel = getElementData(veh, 'exv_fuelSystem.fuel')
	local maxFuel = getElementData(veh, 'exv_fuelSystem.fuelMax')

	if not fuel or not maxFuel then return end

	totals_litres = math.floor(((maxFuel*scroll_pos)/100))

	if fuel_type ~= -1 then
		totals_price = totals_litres*PRICE[fuel_type]
		guiSetText(UI['refills'].lbl_info, 'Тип топлива: '..fuel_type_text..'\nЦена за 1 л: '..PRICE[fuel_type]..' ₽\nЗалить: '..totals_litres..' л\nНа: '..totals_price..' ₽\n')
	end

end)

if showCoeff then
	addEventHandler('onClientRender', root, function()
		local veh = getPedOccupiedVehicle(localPlayer)
		if not veh then return end

		local fuel = getElementData(veh, 'exv_fuelSystem.fuel') or nil
		local maxFuel = getElementData(veh, 'exv_fuelSystem.fuelMax') or nil

		dxDrawText('Показатель расхода топлива: '..fuel..'/'..maxFuel, 10, sH-20, sW, sH)
	end)
end

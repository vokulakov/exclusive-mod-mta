local screenW, screenH = guiGetScreenSize()

UI = { }

local width, height = 330, 435

UI.sectionsWindow = GuiWindow(20, screenH-height-20, width, height, "Покраска", false)
guiWindowSetSizable(UI.sectionsWindow, false)
guiWindowSetMovable(UI.sectionsWindow, false)

-- ТИП ПОКРАСКИ --
UI.rButStock = guiCreateRadioButton(0, 300, 100, 20, "Стандартный", false, UI.sectionsWindow)
UI.rButGloss = guiCreateRadioButton(0, 320, 100, 20, "Глянец", false, UI.sectionsWindow)
UI.rButMatte = guiCreateRadioButton(0, 340, 100, 20, "Матовый", false, UI.sectionsWindow)
UI.rButChrome = guiCreateRadioButton(0, 360, 150, 20, "Хром", false, UI.sectionsWindow)
UI.rButChameleon = guiCreateRadioButton(0, 380, 150, 20, "Перламутровый", false, UI.sectionsWindow)
------------------

UI.chekBoxColor1 = guiCreateCheckBox(170, 300, 90, 20, 'Цвет кузова', true, false, UI.sectionsWindow)
UI.chekBoxColor3 = guiCreateCheckBox(170, 320, 150, 20, 'Дополнительный цвет', false, false, UI.sectionsWindow)
UI.chekBoxColor2 = guiCreateCheckBox(170, 340, 90, 20, 'Цвет блеска', false, false, UI.sectionsWindow)

UI.buttonPaint = GuiButton(170, 370, 150, 30, "Покрасить", false, UI.sectionsWindow)
--guiSetProperty(UI.buttonPaint, "NormalTextColour", "ff5af542")

UI.buttonExit = GuiButton(10, 405, 330, 20, "Выход", false, UI.sectionsWindow)
--guiSetProperty(UI.buttonExit, "NormalTextColour", "ffd43422")

UI.sectionsWindow.visible = false

function showPaintUI(visible)
	----------------------------
	local currentColorType = localPlayer.vehicle:getData('exv_carPaint.colorType') 
	if not currentColorType then
		guiRadioButtonSetSelected(UI.rButStock, true)
		guiSetText(UI.buttonPaint, 'Покрасить за '..Config.paintPrice['stock']..' $')
		colorType = 'stock'
	else
		if currentColorType == 'matte' then
			guiRadioButtonSetSelected(UI.rButMatte, true)
		elseif currentColorType == 'gloss' then
			guiRadioButtonSetSelected(UI.rButGloss, true)
		elseif currentColorType == 'chrome' then
			guiRadioButtonSetSelected(UI.rButChrome, true)
		elseif currentColorType == 'chameleon' then
			guiRadioButtonSetSelected(UI.rButChameleon, true)
		end
		guiSetText(UI.buttonPaint, 'Покрасить за '..Config.paintPrice[currentColorType]..' $')
		colorType = currentColorType
	end
	----------------------------
	if not visible then
		colorPickerDestroy()
	else
		local r1, g1, b1, r2, g2, b2 = getVehicleColor(localPlayer.vehicle, true)
		createColorPicker(tocolor(r1, g1, b1))
	end

	UI.sectionsWindow.visible = visible
end

-------------------------- EVENTS --------------------------
addEventHandler("onClientGUIClick", UI.buttonPaint, function()
	if not UI.sectionsWindow.visible then
		return 
	end
	-- ПОКРАСИМ ? :) --
	showPaintUI(false)

	local money = tonumber(Config.paintPrice[colorType])
	if tonumber(getPlayerMoney()) >= money then
		exports["exv_sounds"]:playSound('paint', false)
		local r1, g1, b1, r2, g2, b2 = getVehicleColor(localPlayer.vehicle, true)
		triggerServerEvent('exv_carPaint.paintGarageBuyVehicleColor', localPlayer, money, r1, g1, b1, r2, g2, b2)
		setTimer(exitPaintGarage, 3000, 1)
	else
		setTimer(function()
			triggerEvent('exv_notify.addNotification', localPlayer, 'У вас недостаточно средств.', 2)
		end, 1500, 1)
		--outputChatBox("#1E90FF[Покрасочная] #FFFFFFУ вас недостаточно средств.", 255, 255, 255, true)
		exitPaintGarage()
		resetVehiclePreview() 
	end
	
end, false)

addEventHandler("onClientGUIClick", UI.buttonExit, function()
	if not UI.sectionsWindow.visible then
		return 
	end
    exitPaintGarage()
    resetVehiclePreview() 
end, false)

addEventHandler('exv_carPaint.onColorPickerChange', root, function(hex, r, g, b)
    setVehiclePreviewColor(r, g, b)
end)

addEventHandler("onClientGUIClick", root, function()
	if not UI.sectionsWindow.visible then
		return 
	end
    
    if source == UI.rButStock or source == UI.rButGloss or source == UI.rButMatte or source == UI.rButChrome or source == UI.rButChameleon then
	    if source == UI.rButStock then colorType = 'stock'
	    elseif source == UI.rButGloss then colorType = 'gloss'
	    elseif source == UI.rButMatte then colorType = 'matte'
	    elseif source == UI.rButChrome then colorType = 'chrome'
	    elseif source == UI.rButChameleon then colorType = 'chameleon'
	    end
	    guiSetText(UI.buttonPaint, 'Покрасить за '..Config.paintPrice[colorType]..' $')
	    setVehiclePreviewFX(colorType)
	end
end)
------------------------------------------------------------


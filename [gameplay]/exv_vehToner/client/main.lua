setDevelopmentMode(true)

local screenW, screenH = guiGetScreenSize()

UI = { }

local width, height = 330, 445

UI.sectionsWindow = GuiWindow(20, screenH-height-20, width, height, "Тонировка", false)
guiWindowSetSizable(UI.sectionsWindow, false)
guiWindowSetMovable(UI.sectionsWindow, false)

-----------
UI.chekBoxColor_zad = guiCreateCheckBox(0, 335, 140, 20, 'Задняя полусфера', false, false, UI.sectionsWindow)
UI.chekBoxColor_lob = guiCreateCheckBox(0, 355, 140, 20, 'Лобовое стекло', false, false, UI.sectionsWindow)
UI.chekBoxColor_pered = guiCreateCheckBox(170, 335, 140, 20, 'Передние стекла', false, false, UI.sectionsWindow)
UI.chekBoxColor_all = guiCreateCheckBox(170, 355, 140, 20, 'Выбрать все', false, false, UI.sectionsWindow)
-----------

UI.buttonRemove = GuiButton(0, 385, 150, 50, "Снять тонировку", false, UI.sectionsWindow) 
UI.buttonAccept = GuiButton(170, 385, 150, 25, "Установить", false, UI.sectionsWindow)
UI.buttonExit = GuiButton(170, 415, 150, 20, "Выход", false, UI.sectionsWindow)

UI.sectionsWindow.visible = false

function showTonerUI(visible)

	if not visible then
		colorPickerDestroy()
	else
		createColorPicker()
		guiCheckBoxSetSelected(UI.chekBoxColor_all, false)
		guiCheckBoxSetSelected(UI.chekBoxColor_zad, false)
		guiCheckBoxSetSelected(UI.chekBoxColor_pered, false)
		guiCheckBoxSetSelected(UI.chekBoxColor_lob, false)
	end

	UI.sectionsWindow.visible = visible
end

-------------------------- EVENTS --------------------------
addEventHandler("onClientGUIClick", UI.buttonAccept, function()
	if not UI.sectionsWindow.visible then
		return 
	end

	if source ~= UI.buttonAccept then
		return
	end

	if not guiCheckBoxGetSelected(UI.chekBoxColor_zad) and not guiCheckBoxGetSelected(UI.chekBoxColor_pered) and not guiCheckBoxGetSelected(UI.chekBoxColor_lob) then
		return
	end
	-- ЗАТОНИРОВАТЬСЯ КАРОЧЕ --
	if tonumber(getPlayerMoney()) >= tonumber(Config.tonerPrice) then
		triggerServerEvent('exv_carToner.tonerGarageBuyVehicleToner', localPlayer, tonumber(Config.tonerPrice))
	else
		setTimer(function()
			triggerEvent('exv_notify.addNotification', localPlayer, 'У вас недостаточно средств.', 2)
		end, 1500, 1)
		-- нужно убрать тонировку, которая в гараже --
		removeVehicleToner()
	end

	exitTonerGarage()
end)

addEventHandler("onClientGUIClick", UI.buttonRemove, function()
	if not UI.sectionsWindow.visible then
		return 
	end

	if source ~= UI.buttonRemove then
		return
	end
	-- сделать проверку на то, установлена ли тонировка вообще
	if not localPlayer.vehicle:getData('exv_vehicle.isToner') then
		return
	end
	removeVehicleToner(true)
	exitTonerGarage()
	triggerServerEvent('exv_carToner.tonerGarageRemoveVehicleToner', localPlayer)
end)

addEventHandler("onClientGUIClick", root, function()
	if not UI.sectionsWindow.visible then
		return 
	end

	if source ~= UI.chekBoxColor_all   and source ~= UI.chekBoxColor_zad and 
	   source ~= UI.chekBoxColor_pered and source ~= UI.chekBoxColor_lob 
	then
		return 
	end

	if source == UI.chekBoxColor_all then
		local state = guiCheckBoxGetSelected(source)
		guiCheckBoxSetSelected(UI.chekBoxColor_zad, state)
		guiCheckBoxSetSelected(UI.chekBoxColor_pered, state)
		guiCheckBoxSetSelected(UI.chekBoxColor_lob, state)
	end

	local r, g, b, a = getColorPickerColor()
	setVehiclePreviewToner(r, g, b, a)
end)

addEventHandler("onClientGUIClick", UI.buttonExit, function()
	if not UI.sectionsWindow.visible then
		return 
	end
  	exitTonerGarage()
    -- нужно убрать тонировку, которая в гараже --
    removeVehicleToner()
end, false)
------------------------------------------------------------

addEventHandler('exv_carToner.onColorPickerChange', root, function(hex, r, g, b, a)
    setVehiclePreviewToner(r, g, b, a)
end)
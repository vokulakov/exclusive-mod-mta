local sx, sy = guiGetScreenSize()

local function showLoadingScreen()
	-- Настройки
	showChat(false) -- скрытие чата
	setPlayerHudComponentVisible("all", false) -- скрытие HUD
	setBlurLevel(0) -- отключение размытия при движении
	setOcclusionsEnabled(false) -- отключение скрытия объектов
	setWorldSoundEnabled(5, false) -- отключение фоновых звуков стрельбы
	toggleAllControls(false, true, true)
	
	fadeCamera(true, 5)
	setCameraMatrix(1468.8785400391, -919.25317382813, 100.153465271, 1468.388671875, -918.42474365234, 99.881813049316)

	message = guiCreateLabel(0, sy-180, sx, sy, "Пожалуйста дождитесь загрузки игрового мода", false)
	guiSetEnabled(message, false)

	guiLabelSetHorizontalAlign(message, "center")
end
addEventHandler("onClientResourceStart", resourceRoot, showLoadingScreen)


addEvent('exv_loadingScreens.destroyLoadingScreen', true)
addEventHandler('exv_loadingScreens.destroyLoadingScreen', root, function()
	if not isElement(message) then return end
	destroyElement(message)
end)
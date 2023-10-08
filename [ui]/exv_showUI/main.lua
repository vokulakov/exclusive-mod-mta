local UI = {
	['all'] = true, -- весь HUD
	['radar'] = true, -- радар
	['hud'] = true, -- статистика игрока
	['speed'] = true, -- спидометр
	['map'] = true, -- карта
	['scoreboard'] = true, -- список игроков

	['notify'] = true, -- уведомления
	['vehControl'] = true, -- управление авто
	
	['nicknames'] = true -- ники игроков
}

local UI_vehControl 

local function setVisiblePlayerUI(state)

	if not state then -- управление авто
		local PLAYER_UI = getElementData(localPlayer, 'exv_player.UI')
		if PLAYER_UI then
			UI_vehControl = PLAYER_UI['vehControl']
		end
	end

	for component in pairs(UI) do 
		UI[component] = state 
	end

	if not UI_vehControl then
		UI['vehControl'] = false
	end

	setElementData(localPlayer, "exv_player.UI", UI)
end
addEvent("exv_showui.setVisiblePlayerUI", true)
addEventHandler("exv_showui.setVisiblePlayerUI", getRootElement(), setVisiblePlayerUI)


local function setVisiblePlayerComponentUI(theComponent, state)
	for component in pairs(UI) do 
		if component == theComponent then
			UI[component] = state 
		end
		setElementData(localPlayer, "exv_player.UI", UI)
	end
end
addEvent("exv_showui.setVisiblePlayerComponentUI", true)
addEventHandler("exv_showui.setVisiblePlayerComponentUI", getRootElement(), setVisiblePlayerComponentUI)


addEventHandler("onClientResourceStart", resourceRoot, function()
	setVisiblePlayerUI(true) -- --

	setElementData(localPlayer, "exv_player.ACTIVE_UI", false) -- Active
	toggleControl("radar", false) -- отключение стандартной карты
end)

-- РАЗМЫТИЕ --
local sx, sy = guiGetScreenSize()
local myScreenSource = dxCreateScreenSource(sx, sy)
local BLUR_SHADER = exports["exv_shaders"]:createShader("blur.fx")
local blurShow = false

local function blurShaderShow()
    dxUpdateScreenSource(myScreenSource)     
    dxSetShaderValue(BLUR_SHADER, "ScreenSource", myScreenSource)
	dxSetShaderValue(BLUR_SHADER, "BlurStrength", 6);
	dxSetShaderValue(BLUR_SHADER, "UVSize", sx, sy);
    dxDrawImage(-10, -10, sx+10, sy+10, BLUR_SHADER)
end

local function blurShaderStart()
	if blurShow then return end
	addEventHandler("onClientPreRender", getRootElement(), blurShaderShow)
	blurShow = true
end
addEvent("exv_showui.blurShaderStart", true)
addEventHandler("exv_showui.blurShaderStart", getRootElement(), blurShaderStart)

local function blurShaderStop()
	if not blurShow then return end
	removeEventHandler("onClientPreRender", getRootElement(), blurShaderShow)
	blurShow = false
end
addEvent("exv_showui.blurShaderStop", true)
addEventHandler("exv_showui.blurShaderStop", getRootElement(), blurShaderStop)

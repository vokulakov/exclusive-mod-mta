local screenX, screenY = guiGetScreenSize()
local screenSource = dxCreateScreenSource(screenX, screenY)
local damageShader = exports["exv_shaders"]:createShader("damage.fx")

local screenDamageShow = false

local impactSoundVolume = 0
local heartSound
local tinnitusSound
local blurStrength = 0
local colorFadeValue = 0

local function deadScreen()
	if (damageShader) then
		dxUpdateScreenSource(screenSource)

		blurStrength = blurStrength - 0.1
		
		if (blurStrength <= 0) then
			blurStrength = 0
		end
		
		colorFadeValue = colorFadeValue - 0.0025
		
		if (colorFadeValue <= 0) then
			colorFadeValue = 0
		end

		-- sounds --
		impactSoundVolume = impactSoundVolume - 0.005
		
		if (impactSoundVolume <= 0) then
			impactSoundVolume = 0
			
			if (heartSound) and (isElement(heartSound)) then
				heartSound:stop()
			end
		end
		
		if (heartSound) and (isElement(heartSound)) then
			heartSound:setVolume(impactSoundVolume * 3)
		end
		
		if (tinnitusSound) and (isElement(tinnitusSound)) then
			tinnitusSound:setVolume(impactSoundVolume)
		end
		------------

		dxSetShaderValue(damageShader, "screenSource", screenSource)
		dxSetShaderValue(damageShader, "blurStrength", blurStrength)
		dxSetShaderValue(damageShader, "colorFadeValue", colorFadeValue)

		dxDrawImage(0, 0, screenX, screenY, damageShader)
	end
end

local function showDeadScreen()
	addEventHandler("onClientPreRender", root, deadScreen)
	triggerEvent("exv_showui.setVisiblePlayerUI", getRootElement(), false)
	showChat(false)

	blurStrength = _blurStrength or 20
	colorFadeValue = 1
	impactSoundVolume = 1

	screenDamageShow = true

	heartSound = exports["exv_sounds"]:playSound('heart', true)
	tinnitusSound = exports["exv_sounds"]:playSound("tinnitus", false)
end

local function destroyDeadScreen()
	removeEventHandler("onClientPreRender", root, deadScreen)
	triggerEvent("exv_showui.setVisiblePlayerUI", getRootElement(), true)
	showChat(true)

	screenDamageShow = false

	if (heartSound) and (isElement(heartSound)) then
		heartSound:stop()
	end

	if (tinnitusSound) and (isElement(tinnitusSound)) then
		tinnitusSound:stop()
	end
end

addEvent("exv.showDeadScreen", true)
addEventHandler("exv.showDeadScreen", root, function(state, _blurStrength)
	if screenDamageShow and state then 
		destroyDeadScreen()
	end

	if state then
		showDeadScreen()
	else
		destroyDeadScreen()
	end

end)
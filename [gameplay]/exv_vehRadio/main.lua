local vehicles = { }

local CURRENT_RADIO_IND = 1

local SOUND_TIMER = nil
local SHOW_TIMER = nil
local SOUND_TUNE = nil
local SOUND_RADIO = nil

local SHOW_RADIO_UI = false

local RADIO_STATIONS = { 0, 
	{name = 'Radio Record', url = 'http://air.radiorecord.ru:8101/rr_320', logo = 'assets/rr.png'},
	{name = 'NRJ', url = 'http://ic3.101.ru:8000/v1_1?userid=0&setst=4n1u717imnoap1h9sd37r9jo24', logo = 'assets/energy.png'},
	{name = 'Дорожное', url = 'http://dorognoe.hostingradio.ru:8000/dorognoe', logo = 'assets/drj.png'},
	{name = 'Европа +', url = 'http://ep256.hostingradio.ru:8052/europaplus256.mp3', logo = 'assets/ep.png'},
	{name = 'Пульс', url = 'http://178.208.82.215:8000/puls.mp3', logo = 'assets/pr.png'}
}

local sX, sY = guiGetScreenSize()

local FONTS = { 
	['TITTLE'] = exports["exv_fonts"]:createFont("Roboto-Bold.ttf", 13),
	['INFO'] = exports["exv_fonts"]:createFont("Roboto-Regular.ttf", 11)
}

local function showRadioSwitch() -- UI
	local veh = getPedOccupiedVehicle(localPlayer) 
	if not veh then return end

	if not isElement(SOUND_RADIO) then return end

	local radio = RADIO_STATIONS[CURRENT_RADIO_IND]
	if type(radio) == 'number' then return end

	local sound_meta = getSoundMetaTags(SOUND_RADIO)

	dxDrawRectangle(sX/2-410/2, 35, 90, 90, tocolor(33, 33, 33, 255), false)
	dxDrawRectangle(sX/2-320/2, 35, 320, 90, tocolor(33, 33, 33, 200), false)

	dxDrawImage(sX/2-400/2, 40, 80, 80, radio.logo)

	dxDrawText(string.upper(radio.name), sX/2-100, 55, 0, 0, tocolor(255, 255, 255), 1, FONTS['TITTLE'], left, top)

	if sound_meta.title then
		dxDrawText(sound_meta.title, sX/2-100, 80, 0, 0, tocolor(255, 255, 255, 175), 1, FONTS['INFO'], left, top)
	else
		dxDrawText('Название трека неизвестно', sX/2-100, 80, 0, 0, tocolor(255, 255, 255, 175), 1, FONTS['INFO'], left, top)
	end
end

local function stopPlayRadio()
	if isElement(SOUND_RADIO) then 
		destroyElement(SOUND_RADIO)
	end

	if isTimer(SOUND_TIMER) then
		killTimer(SOUND_TIMER)
		if isElement(SOUND_TUNE) then
			stopSound(SOUND_TUNE)
		end
	end

	if isTimer(SHOW_TIMER) then
		killTimer(SHOW_TIMER)
		removeEventHandler("onClientPreRender", root, showRadioSwitch)
		SHOW_RADIO_UI = false
	end
end

local function onPlayerRadioSwitch()

	stopPlayRadio()

	if CURRENT_RADIO_IND == 1 then -- ВЫКЛЮЧИТЬ РАДИО
		return
	end

	if not isElement(SOUND_TUNE) then
		SOUND_TUNE = exports["exv_sounds"]:playSound('veh_radio_tune', false)
		
		if isElement(SOUND_RADIO) then
			setSoundVolume(SOUND_RADIO, 0.1)
		end
		
		SOUND_TIMER = setTimer(function()
			stopSound(SOUND_TUNE)

			local radio = RADIO_STATIONS[CURRENT_RADIO_IND]
	
			if isElement(SOUND_RADIO) then 
				destroyElement(SOUND_RADIO) 
			end

			if type(radio) == 'number' then return end

			SOUND_RADIO = playSound(radio.url)
			setSoundVolume(SOUND_RADIO, 1.0)

			if not SHOW_RADIO_UI then
				addEventHandler("onClientPreRender", root, showRadioSwitch)
				SHOW_RADIO_UI = true
			end

			SHOW_TIMER = setTimer(function()
				removeEventHandler("onClientPreRender", root, showRadioSwitch)
				SHOW_RADIO_UI = false
			end, 5000, 1)

		end, 2000, 1)
	end

end

local function onRadioNext()
	local nextIndex = ((CURRENT_RADIO_IND)%(#RADIO_STATIONS))+1
	CURRENT_RADIO_IND = nextIndex
	onPlayerRadioSwitch()
end

local function onRadioPrevios()
	local nextIndex = ((CURRENT_RADIO_IND-2)%(#RADIO_STATIONS))+1
    CURRENT_RADIO_IND = nextIndex
    onPlayerRadioSwitch()
end

addEventHandler('onClientPlayerVehicleEnter', root, function(veh, seat)
	if source ~= localPlayer then return end
	if seat ~= 0 then return end

	bindKey("radio_next", "down", onRadioNext)
	bindKey("radio_previous", "down", onRadioPrevios)

	setRadioChannel(0) 
	onPlayerRadioSwitch()
end)

addEventHandler('onClientVehicleExit', root, function(player, seat)
	if player ~= localPlayer then return end
	if seat ~= 0 then return end

	stopPlayRadio()

	unbindKey("radio_next", "down", onRadioNext)
	unbindKey("radio_previous", "down", onRadioPrevios)	
end)

addEventHandler("onClientVehicleStartExit", root, function(player, seat)
	if player ~= localPlayer then return end
	if seat ~= 0 then return end

	stopPlayRadio()

	unbindKey("radio_next", "down", onRadioNext)
	unbindKey("radio_previous", "down", onRadioPrevios)	
end)

addEventHandler("onClientElementDestroy", root, function()
	if source and getElementType(source) == "vehicle" then
		if source == getPedOccupiedVehicle(localPlayer) then
			if isElement(SOUND_RADIO) then 
				stopPlayRadio()
			end
		end
	end
end)

addEventHandler("onClientVehicleExplode", root, function()
	if source and getElementType(source) == "vehicle" then
		if source == getPedOccupiedVehicle(localPlayer) then
			if isElement(SOUND_RADIO) then 
				stopPlayRadio()
			end
		end
	end
end)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	if isElement(SOUND_RADIO) then 
		stopPlayRadio()
	end
end)

addEventHandler("onClientPlayerRadioSwitch", localPlayer, function(station) if station ~= 0 then cancelEvent() end end)

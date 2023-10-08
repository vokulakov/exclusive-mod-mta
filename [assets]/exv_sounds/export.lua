local sounds = { 

	['error'] = "assets/systems/error.wav",
	['notify'] = "assets/systems/notify.mp3",
	['sell'] = "assets/systems/sell.wav",
	['tinnitus'] = "assets/systems/tinnitus.ogg",
	['heart'] = "assets/systems/heart.mp3",
	['sound_mission'] = "assets/systems/sound_mission.mp3",
	
	['box_up'] = "assets/systems/jobLoader/box_up.mp3",
	['box_down'] = "assets/systems/jobLoader/box_down.mp3",

	['paint'] = "assets/systems/vehPaint/paint.mp3",
	['paintBG'] = "assets/systems/vehPaint/paint_bg.wav",
	-- --

	['veh_radio_tune'] = "assets/vehicles/radio_tune.mp3",
	['veh_lightswitch'] = "assets/vehicles/lightswitch.mp3",
	['veh_doorlock'] = "assets/vehicles/doorlock.mp3",
	['veh_belt_out'] = "assets/vehicles/belt-out.mp3",
	['veh_belt_in'] = "assets/vehicles/belt-in.mp3",
	['veh_belt_alarm'] = "assets/vehicles/belt-alarm.wav",
	['veh_starter_car'] = "assets/vehicles/starter_car.mp3",

	['veh_signal_1'] = "assets/vehicles/signal/sound_a.wav",
	['veh_signal_2'] = "assets/vehicles/signal/sound_b.wav",
	['veh_signal_3'] = "assets/vehicles/signal/sound_c.wav",
	['veh_signal_4'] = "assets/vehicles/signal/sound_d.wav",
	['veh_signal_5'] = "assets/vehicles/signal/sound_e.wav",
	['veh_signal_6'] = "assets/vehicles/signal/sound_escooter.wav",
	-- --
	
}

function playSound(name, ...)
	local sound = sounds[name]
	
	if not sound then
		return false
	end

	if type(name) ~= "string" then
		return false
	end

	return Sound(sound, ...)
end

function playSound3D(name, ...)
	local sound = sounds[name]

	if not sound then
		return false
	end

	if type(name) ~= "string" then
		return false
	end

	return Sound3D(sound, ...)
end

addEvent('exv_sounds.playMoneySound', true)
addEventHandler('exv_sounds.playMoneySound', root, function()
	playSound('sell')
end)
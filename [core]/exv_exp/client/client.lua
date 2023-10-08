local function newLevel() 
	exports["exv_sounds"]:playSound("sound_mission")
end
addEvent("exv_exp.newLevel", true)
addEventHandler("exv_exp.newLevel", root, newLevel)

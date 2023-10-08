local function setWorldTime()
	local TIME_HOUR, TIME_MINUTE = getTime()
	setTime(TIME_HOUR, TIME_MINUTE)
    setMinuteDuration(10000)
end
addEvent("exv_world.setWorldTime", true)
addEventHandler("exv_world.setWorldTime", getRootElement(), setWorldTime)

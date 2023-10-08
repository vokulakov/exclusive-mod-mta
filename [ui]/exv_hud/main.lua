local screenW, screenH = guiGetScreenSize()
local posX, posY = 10, 10


local HUD_FONTS = {
	['MONEY'] = exports["exv_fonts"]:createFont("Roboto-Bold.ttf", 12, false, "draft"),
	['TIME'] = exports["exv_fonts"]:createFont("Roboto-Bold.ttf", 10, false, "draft"),
	['DATE'] = exports["exv_fonts"]:createFont("Roboto-Bold.ttf", 7, false, "draft"),
	['EXP'] = exports["exv_fonts"]:createFont("Roboto-Regular.ttf", 8, false, "draft")
}

addEventHandler("onClientRender", root, function()
	local PLAYER_UI = getElementData(localPlayer, "exv_player.UI")
	if not PLAYER_UI['hud'] then return end

	dxDrawRectangle((screenW-220)-posX, posY, 80, 40, tocolor(33, 33, 33, 255), false)
	dxDrawRectangle((screenW-140)-posX, posY, 140, 40, tocolor(33, 33, 33, 200), false)

	-- TIME --
	local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute

	local monthday = time.monthday
	local month = time.month + 1
	local year = time.year + 1900

	local TimeFormate = string.format("%02d:%02d", hours, minutes)
	local DateFormate = string.format("%02d.%02d.%02d", monthday, month, year)

	dxDrawImage((screenW-205)-posX, posY+9, 14, 14, "assets/i_time.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	dxDrawText(TimeFormate, (screenW-205)+18-posX, posY+8, screenW, screenH, tocolor(255, 255, 255, 255), 1, HUD_FONTS['TIME'])
    dxDrawText(DateFormate, (screenW-205)-posX, posY+23, screenW, screenH, tocolor(255, 255, 255, 200), 1, HUD_FONTS['DATE'])
	----------

	-- MONEY --
	local p_money = convertNumber(getPlayerMoney(localPlayer))
	dxDrawImage((screenW-130)-posX, posY+8, 24, 24, "assets/i_money.png", 0, 0, 0, tocolor(255,255,255, 255), false)
	dxDrawText(p_money, (screenW-40)-20-posX, posY+10, (screenW-40)-10-posX, screenH, tocolor(255, 255, 255, 255), 1, HUD_FONTS['MONEY'], "center")
	-----------

	-- HEALTH --
	dxDrawRectangle((screenW-220)-posX, posY+40, 220, 4, tocolor(114, 137, 218, 100), false)
	dxDrawRectangle((screenW-220)-posX, posY+40, (getElementHealth(localPlayer)*220)/100, 4, tocolor(114, 137, 218, 255), false)
	------------

	-- EXP --

	local lvl = getElementData(localPlayer, 'player.LEVEL')
	if not lvl then return end

	local exp = getElementData(localPlayer, 'player.EXP')
	local efl = exports.exv_exp:getExperienceForLevel(lvl)

	dxDrawRectangle(15, screenH-45, 35, 25, tocolor(33, 33, 33, 255), false)
	dxDrawRectangle(50, screenH-45, 195, 25, tocolor(33, 33, 33, 200), false)

	dxDrawText(lvl, 15, screenH-43, 50, 25, tocolor(255, 255, 255, 255), 1, HUD_FONTS['MONEY'], "center")
	dxDrawText(exp..' / '..efl, 35, screenH-39, 245, 25, tocolor(255, 255, 255, 255), 1, HUD_FONTS['EXP'], "center")
	dxDrawRectangle(15, screenH-20, 230, 4, tocolor(114, 137, 218, 100), false)

	dxDrawRectangle(15, screenH-20, (exp*230)/efl, 4, tocolor(114, 137, 218, 255), false)
	---------

end)

function convertNumber(number)
	local formatted = number

	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
		if ( k==0 ) then
			break
		end
	end

	return formatted
end
local screenW, screenH = guiGetScreenSize()
local SB_WIDTH, SB_HEIGHT = 492, 446
local SB_POSX, SB_POSY = screenW/2-SB_WIDTH/2, screenH/2-SB_HEIGHT/2

local HEAD_FONT = exports.exv_fonts:createFont("Roboto-Bold.ttf", 13)
local COLUMNS_FONT = exports.exv_fonts:createFont("Roboto-Bold.ttf", 11)
local ITEM_FONT = exports.exv_fonts:createFont("Roboto-Regular.ttf", 10)

local SB_DATA = getElementData(resourceRoot, "exv_scoreboard.data")

local playersList = {}
local playersOnlineCount = 0
local playersMaxCount = SB_DATA.MAXPLAYERS
local scrollOffset = 0

-- SETUPS
local itemsCount = 10
local headerColor = tocolor(255, 255, 255, 255) 
local columnsColor = tocolor(255, 255, 255, 255)
local playerLocalColor = tocolor(114, 137, 218, 255)
local playerAunColor = tocolor(255, 255, 255, 125)
local playerColor = tocolor(255, 255, 255, 255)

local columns = {
	{name = "Ник", size = 0.2, data = "name"},
	{name = "Уровень", size = 0.6, data = "level"},
	{name = "Пинг", size = 0.15},
}

local function drawScoreBoard()
	dxDrawRectangle(SB_POSX, SB_POSY, SB_WIDTH, 40, tocolor(33, 33, 33, 255), false)
	dxDrawRectangle(SB_POSX, SB_POSY, SB_WIDTH, SB_HEIGHT, tocolor(33, 33, 33, 200), false)

	dxDrawText("СПИСОК ИГРОКОВ", SB_POSX+15, SB_POSY+10, SB_WIDTH, SB_HEIGHT, headerColor, 1, HEAD_FONT)
	dxDrawText(playersOnlineCount.."/"..playersMaxCount, SB_POSX+15, SB_POSY+10, SB_POSX+SB_WIDTH-15, SB_HEIGHT, headerColor, 1, HEAD_FONT, "right")

	local x = SB_POSX
	for i, column in ipairs(columns) do
		local width = SB_WIDTH * column.size
		dxDrawText(tostring(column.name), x, SB_POSY+75, x+width, SB_POSY+75, columnsColor, 1, COLUMNS_FONT, "center", "center")
		x = x + width
	end
	dxDrawRectangle(SB_POSX+15, SB_POSY+85, SB_WIDTH-37, 1, tocolor(224, 225, 231, 255))

	local y = SB_POSY+70
	for i = scrollOffset + 1, math.min(itemsCount + scrollOffset, #playersList) do
		local item = playersList[i]
		local color = playerColor
		if item.isLocalPlayer then
			color = playerLocalColor
		end
		if item.isLogin then
			color = playerAunColor
		end
		x = SB_POSX
		for j, column in ipairs(columns) do
			local text = item[column.data]
			if text == nil then text = getPlayerPing(item.player) end
			local width = SB_WIDTH * column.size
			dxDrawText(tostring(text), x, y, x+width, y+65, color, 1, ITEM_FONT, "center", "center")
			x = x + width
		end
		y = y + 35
	end
end

local function mouseDown()
	if #playersList <= itemsCount then
		return
	end
	scrollOffset = scrollOffset + 1
	if scrollOffset > #playersList - itemsCount then
		scrollOffset = #playersList - itemsCount + 1
	end
end

local function mouseUp()
	if #playersList <= itemsCount then
		return
	end
	scrollOffset = scrollOffset - 1
	if scrollOffset < 0 then
		scrollOffset = 0
	end
end

local function startScoreBoard()
	addEventHandler("onClientRender", root, drawScoreBoard)
	triggerEvent("exv_showui.blurShaderStart", localPlayer) -- включаем размытие

	playersList = {}

	local function addPlayerToList(player, login, isLocalPlayer)
		if type(player) == "table" then
			table.insert(playersList, player)
			return
		end
		table.insert(playersList, {
			isLogin = login,
			isLocalPlayer = isLocalPlayer,
			level = player:getData("player.LEVEL") or "-",
			name = player:getName(),
			player = player 
		})
	end

	local players = getElementsByType("player")

	playersOnlineCount = #players

	addPlayerToList(localPlayer, false, true)

	if #players > 0 then
		for i, player in ipairs(players) do
			if player ~= localPlayer then
				addPlayerToList(player, nil)
			end
		end
	end

	bindKey("mouse_wheel_up", "down", mouseUp)
	bindKey("mouse_wheel_down", "down", mouseDown)
end

local function stopScoreBoard()
	removeEventHandler("onClientRender", root, drawScoreBoard)
	triggerEvent("exv_showui.blurShaderStop", localPlayer) -- выключаем размытие
	
	unbindKey("mouse_wheel_up", "down", mouseUp)
	unbindKey("mouse_wheel_down", "down", mouseDown)
end

local function setScoreBoardVisible()
	if not getElementData(localPlayer, "exv_player.ACTIVE_UI") == 'scoreboard' then return end

	local PLAYER_UI = getElementData(localPlayer, "exv_player.UI")
	if not PLAYER_UI['scoreboard'] then return end

	SB_VISIBLE = not SB_VISIBLE
	showCursor(SB_VISIBLE)
	showChat(not SB_VISIBLE)
	
	if SB_VISIBLE then
		startScoreBoard()
		setElementData(localPlayer, "exv_player.ACTIVE_UI", "scoreboard")
	else
		stopScoreBoard()
		setElementData(localPlayer, "exv_player.ACTIVE_UI", false)
	end

	-- СКРЫТИЕ HUD
	triggerEvent("exv_showui.setVisiblePlayerUI", getRootElement(), not SB_VISIBLE)
	triggerEvent("exv_showui.setVisiblePlayerComponentUI", getRootElement(), "scoreboard", true)
end

bindKey("tab", "down", setScoreBoardVisible)
bindKey("tab", "up", setScoreBoardVisible)
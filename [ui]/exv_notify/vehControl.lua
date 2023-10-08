local sW, sH = guiGetScreenSize()

local CONTROLS = {
	{'H', 'Гудок'},
	{'B', 'Ремень безопасности'},
	{'K', 'Двери'},
	{'L', 'Фары'},
	{'2', 'Двигатель'},
}

local FONTS = {
	['TITTLE'] = exports["exv_fonts"]:createFont("Roboto-Bold.ttf", 8, false, "draft"),
	['CONTROL'] = exports["exv_fonts"]:createFont("Roboto-Regular.ttf", 8, false, "draft"),
	['HELP'] = exports["exv_fonts"]:createFont("Roboto-Regular.ttf", 7, false, "draft")
}

local posX, posY = 15, sH-205
local offset = 30
local width, height = 230, #CONTROLS*offset+20

local activeEvent 

local function drawVehControl()
	local PLAYER_UI = getElementData(localPlayer, "exv_player.UI")
	if not PLAYER_UI['vehControl'] then return end

	if #messages ~= 0 then
		return
	end
	local veh = getPedOccupiedVehicle(localPlayer)
	if not veh then return end


	-- ШАПКА --
	dxDrawRectangle(posX, posY-24-height, width, 20, tocolor(33, 33, 33, 255), false)
	dxDrawText('Управление', posX+5, posY-21-height, width, 20, tocolor(255, 255, 255, 255), 1, FONTS['TITTLE'], 'left', 'top')
	--       --
	dxDrawRectangle(posX, posY-height-4, width, height, tocolor(33, 33, 33, 200), false)

	local prev = 15
	for index, data in ipairs(CONTROLS) do

		-- КНОПКА --
		dxDrawRectangle(posX+5, posY-(prev)-offset, 18, 18, tocolor(114, 137, 218, 100), false)
		dxDrawText(data[1], posX+10, posY-(10+prev), width, posY-(prev)-offset, tocolor(255, 255, 255, 255), 1, FONTS['TITTLE'], 'left', 'center')
		-- ДЕЙСТВИЕ --
		dxDrawText(data[2], width, posY-(10+prev), width+10, posY-(prev)-offset, tocolor(255, 255, 255, 150), 1, FONTS['CONTROL'], 'right', 'center')
		-- ПОЛОСКА --
		dxDrawRectangle(posX+5, posY-(10+prev), width-10, 1, tocolor(255, 255, 255, 100), false)

		prev = prev + offset
	end
	--dxDrawRectangle((screenW-140)-posX, posY, 140, 40, tocolor(33, 33, 33, 200), false)
	-- ПОДВАЛ --
	dxDrawText("Скрыть/показать окно помощи 'F5'", posX+5, posY-20, width, 20, tocolor(255, 255, 255, 100), 1, FONTS['HELP'])
	--dxDrawRectangle(posX, posY-4, width, 4, tocolor(114, 137, 218, 100), false)
	------------

end

local function showVehControl()
	local PLAYER_UI = getElementData(localPlayer, "exv_player.UI")
	local state = not PLAYER_UI['vehControl'] 
	triggerEvent("exv_showui.setVisiblePlayerComponentUI", root, "vehControl", state)
end

addEventHandler("onClientVehicleEnter", root, function (thePlayer, seat)
	if thePlayer == localPlayer and seat == 0 then
		if activeEvent then
			removeEventHandler("onClientRender", root, drawVehControl)
			unbindKey("F5", "down", showVehControl)
			activeEvent = nil
		end
		activeEvent = addEventHandler("onClientRender", root, drawVehControl)
		bindKey("F5", "down", showVehControl)
	end
end)

addEventHandler("onClientVehicleStartExit", root, function(thePlayer, seat)
    if thePlayer == localPlayer and seat == 0 then
        removeEventHandler("onClientRender", root, drawVehControl)
        unbindKey("F5", "down", showVehControl)
    end
end)

addEventHandler("onClientElementDestroy", getRootElement(), function ()
	if getElementType(source) == "vehicle" and getPedOccupiedVehicle(getLocalPlayer()) == source then
		removeEventHandler("onClientRender", root, drawVehControl)
		unbindKey("F5", "down", showVehControl)
	end
end)

addEventHandler("onClientPlayerWasted", getLocalPlayer(), function()
	if not getPedOccupiedVehicle(source) then return end
	removeEventHandler("onClientRender", root, drawVehControl)
	unbindKey("F5", "down", showVehControl)
end)
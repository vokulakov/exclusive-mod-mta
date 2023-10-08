local sW, sH = guiGetScreenSize()

local dxHelpPanelActive = false
local dxHelpText
local dxHelpButton

local TEXT_FONT = exports["exv_fonts"]:createFontGui("Roboto-Regular.ttf", 12)
local DX_TEXT_FONT = exports["exv_fonts"]:createFont("Roboto-Regular.ttf", 11)

function guiHelpButton(text, button)
	-- РАСЧЕТ РАЗМЕРОВ --
	local TEST_TEXT = guiCreateLabel(0, 0, 1, 1, text, true)
	guiSetFont(TEST_TEXT, TEXT_FONT)
	local WIDTH, HEIGHT = guiLabelGetTextExtent(TEST_TEXT), guiLabelGetFontHeight(TEST_TEXT)
	destroyElement(TEST_TEXT)
	---------------------

	-- ЦЕНТРАЛЬНАЯ ПАНЕЛЬ --
	local w, h = WIDTH+10+26, HEIGHT+10
	local x, y = sW/2-w/2, sH-45

	local HELP_PANEL = guiCreateStaticImage(x, y, w, h, "assets/panel/pane.png", false)
	guiSetProperty(HELP_PANEL, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
	guiSetAlpha(HELP_PANEL, 0.7)
	guiSetEnabled(HELP_PANEL, false)
	------------------------

	-- ЛЕВЫЙ КРАЙ --
	local HELP_LEFT_UP = guiCreateStaticImage(x-6, y, 6, 6, "assets/panel/round_1.png", false)
	guiSetProperty(HELP_LEFT_UP, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
	guiSetAlpha(HELP_LEFT_UP, 0.7)
	setElementParent(HELP_LEFT_UP, HELP_PANEL)

	local HELP_LEFT_CENTER = guiCreateStaticImage(x-6, y+6, 6, HEIGHT-2, "assets/panel/pane.png", false)
	guiSetProperty(HELP_LEFT_CENTER, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
	guiSetAlpha(HELP_LEFT_CENTER, 0.7)
	setElementParent(HELP_LEFT_CENTER, HELP_PANEL)

	local HELP_LEFT_DOWN = guiCreateStaticImage(x-6, y+10+HEIGHT-6, 6, 6, "assets/panel/round_4.png", false)
	guiSetProperty(HELP_LEFT_DOWN, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
	guiSetAlpha(HELP_LEFT_DOWN, 0.7)
	setElementParent(HELP_LEFT_DOWN, HELP_PANEL)
	----------------
	
	-- ПРАВЫЙ КРАЙ --
	local HELP_RIGHT_UP = guiCreateStaticImage(x+w, y, 6, 6, "assets/panel/round_2.png", false)
	guiSetProperty(HELP_RIGHT_UP, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
	guiSetAlpha(HELP_RIGHT_UP, 0.7)
	setElementParent(HELP_RIGHT_UP, HELP_PANEL)

	local HELP_RIGHT_CENTER = guiCreateStaticImage(x+w, y+6, 6, HEIGHT-2, "assets/panel/pane.png", false)
	guiSetProperty(HELP_RIGHT_CENTER, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
	guiSetAlpha(HELP_RIGHT_CENTER, 0.7)
	setElementParent(HELP_RIGHT_CENTER, HELP_PANEL)

	local HELP_RIGHT_DOWN = guiCreateStaticImage(x+w, y+10+HEIGHT-6, 6, 6, "assets/panel/round_3.png", false)
	guiSetProperty(HELP_RIGHT_DOWN, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
	guiSetAlpha(HELP_RIGHT_DOWN, 0.7)
	setElementParent(HELP_RIGHT_DOWN, HELP_PANEL)
	-----------------

	-- ТЕКСТ --
	local HELP_TEXT = guiCreateLabel(x, y+5, WIDTH, HEIGHT, text, false)
	guiLabelSetHorizontalAlign(HELP_TEXT, "center")
	guiSetFont(HELP_TEXT, TEXT_FONT)
	setElementParent(HELP_TEXT, HELP_PANEL)
	-----------

	local HELP_BUTTON = guiCreateStaticImage(WIDTH+10, HEIGHT/2-13+5, 26, 26, "assets/"..button..".png", false, HELP_PANEL)
	guiSetEnabled(HELP_BUTTON, false)

	return HELP_PANEL
end

function dxDrawHelpButton()
	if not dxHelpButton or not dxHelpText then return end

	local textW = dxGetTextWidth(dxHelpText, 1, DX_TEXT_FONT)
	local w, h = textW+30, 20
	local x, y = sW/2-w/2, sH-45

	dxDrawImage(x, y, w+4, h+10, "assets/panel/pane.png", 0, 0, 0, tocolor(0, 0, 0, 178))

	-- ЛЕВЫЙ КРАЙ --
	dxDrawImage(x-6, y, 6, 6, "assets/panel/round_1.png", 0, 0, 0, tocolor(0, 0, 0, 178))
	dxDrawImage(x-6, y+6, 6, h-2, "assets/panel/pane.png", 0, 0, 0, tocolor(0, 0, 0, 178))
	dxDrawImage(x-6, y+10+h-6, 6, 6, "assets/panel/round_4.png", 0, 0, 0, tocolor(0, 0, 0, 178))

	-- ПРАВЫЙ КРАЙ --
	dxDrawImage(x+w+3.5, y, 6, 6, "assets/panel/round_2.png", 0, 0, 0, tocolor(0, 0, 0, 178))
	dxDrawImage(x+w+3.5, y+6, 6, h-2, "assets/panel/pane.png", 0, 0, 0, tocolor(0, 0, 0, 178))
	dxDrawImage(x+w+3.5, y+10+h-6, 6, 6, "assets/panel/round_3.png", 0, 0, 0, tocolor(0, 0, 0, 178))

	-- ТЕКСТ --
	dxDrawText(dxHelpText, x, y, x, y+h+10, tocolor(255, 255, 255, 255), 1, DX_TEXT_FONT, 'left', 'center')

	-- КНОПКА --
	dxDrawImage(x+w-22, y+h/2-13+5, 26, 26, "assets/"..dxHelpButton..".png")
end


function dxShowHelpButton(text, button)
	dxHelpText = text
	dxHelpButton = button

	if dxHelpPanelActive then return end
	
	addEventHandler("onClientRender", root, dxDrawHelpButton)

	dxHelpPanelActive = true
end

function dxHideHelpButton()
	if not dxHelpPanelActive then return end

	dxHelpText = false
	dxHelpButton = false

	removeEventHandler("onClientRender", root, dxDrawHelpButton)

	dxHelpPanelActive = false
end

--dxHelpButton("Выбросить ящик", "mouse_right")
--guiHelpButton("Выбросить ящик", "b_enter")


--[[
function createRectangle(x, y, w, h, alpha, round)
	local RECTANGLE_PANEL = guiCreateStaticImage(x, y, w, h, "assets/panel/pane.png", false)
	guiSetProperty(RECTANGLE_PANEL, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
	guiSetAlpha(RECTANGLE_PANEL, alpha)
	guiSetEnabled(RECTANGLE_PANEL, false)

	if round then
		-- ЛЕВЫЙ КРАЙ
		local RECTANGLE_LEFT_UP = guiCreateStaticImage(x-6, y, 6, 6, "assets/panel/round_1.png", false)
		guiSetProperty(RECTANGLE_LEFT_UP, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
		guiSetAlpha(RECTANGLE_LEFT_UP, alpha)
		setElementParent(RECTANGLE_LEFT_UP, RECTANGLE_PANEL)

		local RECTANGLE_LEFT_CENTER = guiCreateStaticImage(x-6, y+6, 6, h-12, "assets/panel/pane.png", false)
		guiSetProperty(RECTANGLE_LEFT_CENTER, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
		guiSetAlpha(RECTANGLE_LEFT_CENTER, alpha)
		setElementParent(RECTANGLE_LEFT_CENTER, RECTANGLE_PANEL)

		local RECTANGLE_LEFT_DOWN = guiCreateStaticImage(x-6, y+h-6, 6, 6, "assets/panel/round_4.png", false)
		guiSetProperty(RECTANGLE_LEFT_DOWN, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
		guiSetAlpha(RECTANGLE_LEFT_DOWN, alpha)
		setElementParent(RECTANGLE_LEFT_DOWN, RECTANGLE_PANEL)

		-- ПРАВЫЙ КРАЙ
		local RECTANGLE_RIGHT_UP = guiCreateStaticImage(x+w, y, 6, 6, "assets/panel/round_2.png", false)
		guiSetProperty(RECTANGLE_RIGHT_UP, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
		guiSetAlpha(RECTANGLE_RIGHT_UP, alpha)
		setElementParent(RECTANGLE_RIGHT_UP, RECTANGLE_PANEL)

		local RECTANGLE_RIGHT_CENTER = guiCreateStaticImage(x+w, y+6, 6, h-12, "assets/panel/pane.png", false)
		guiSetProperty(RECTANGLE_RIGHT_CENTER, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
		guiSetAlpha(RECTANGLE_RIGHT_CENTER, alpha)
		setElementParent(RECTANGLE_RIGHT_CENTER, RECTANGLE_PANEL)

		local RECTANGLE_RIGHT_DOWN = guiCreateStaticImage(x+w, y+h-6, 6, 6, "assets/panel/round_3.png", false)
		guiSetProperty(RECTANGLE_RIGHT_DOWN, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
		guiSetAlpha(RECTANGLE_RIGHT_DOWN, alpha)
		setElementParent(RECTANGLE_RIGHT_DOWN, RECTANGLE_PANEL)
	end

	return RECTANGLE_PANEL
end

function setRectangleSize(rectangle, width, height)
	local elements = getElementChildren(rectangle)
	local rectangle_x, rectangle_y = guiGetPosition(rectangle, false)
	local rectangle_w, rectangle_h = guiGetSize(rectangle, false)
	guiSetSize(rectangle, width, height, false)
	for k, v in ipairs(elements) do
		if getElementType(v) == 'gui-staticimage' then
			local element_x, element_y = guiGetPosition(v, false)
			if tonumber(rectangle_x + rectangle_w) == tonumber(element_x) then
				guiSetPosition(v, rectangle_x + width, element_y, false)
			end
		end
	end
end
]]
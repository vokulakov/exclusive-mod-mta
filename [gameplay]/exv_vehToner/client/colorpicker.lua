local sw, sh = guiGetScreenSize()
local color = { }
local gui = { }

addEvent('exv_carToner.onColorPickerChange', true)

local function colorPickerGuiFocus()
	colorPickerFocus = true
  	guiSetAlpha(UI.sectionsWindow, 0.8)
end

local function colorPickerGuiBlur()
	colorPickerFocus = false
  	guiSetAlpha(UI.sectionsWindow, 0.5)
end

-- FUNCTION --
function getColorPickerColor()
  color.r, color.g, color.b = hsv2rgb(color.h, color.s, color.v)
  return color.r, color.g, color.b, color.a
end

local function colorPickerUpdateColor()
	color.r, color.g, color.b = hsv2rgb(color.h, color.s, color.v)
  color.current = tocolor(color.r, color.g, color.b, 255)
 	color.huecurrent = tocolor(hsv2rgb(color.h, 1, 1))
  color.hex = string.format("#%02X%02X%02X", color.r, color.g, color.b)
  if color.r >= 0 and color.g >= 0 and color.b >= 0 then
    triggerEvent("exv_carToner.onColorPickerChange", root, color.hex, color.r, color.g, color.b, color.a) 
  end
end

local function colorPickerMouseSnap()
  	if gui.track and source == gui.track then
    	if color.s < gui.snaptreshold or color.s > 1-gui.snaptreshold then color.s = math.round(color.s) end
    	if color.v < gui.snaptreshold or color.v > 1-gui.snaptreshold then color.v = math.round(color.v) end
    	colorPickerUpdateColor()
  	end
end

local function colorPickerMouseMove(x,y)
  	if gui.track and source == gui.track then
    	local gx,gy = guiGetPosition(UI.sectionsWindow, false)
    	if source == gui.svmap then
      		local offsetx, offsety = x - (gx + 8), y - (gy + 32)
     	 	color.s = offsetx/255
      		color.v = (255-offsety)/255
    	elseif source == gui.hbar then
      		local offset = y - (gy + 32)
      		color.h = (255-offset)/255
      elseif source == gui.abar then -- яркость
          local offset = x - (gx + 8)
          --outputDebugString(offset)
          color.a = offset
    	end 
    	colorPickerUpdateColor()
  	end
end

local function colorPickerMouseDown()
  	if source == gui.svmap or source == gui.hbar or source == gui.abar then
    	gui.track = source
    	local cx, cy = getCursorPosition()
    	colorPickerMouseMove(sw*cx, sh*cy)
  	end  
end

local function colorPickerMouseUp(button, state)
  	if not state or state ~= "down" then
    	if gui.track then 
     	 	--triggerEvent("exv_carToner.onColorPickerChange", root, color.hex, color.r, color.g, color.b, color.a) 
    	end
    	gui.track = false 
  	end  
end
--------------

local function drawColorPicker()
	local x, y = guiGetPosition(UI.sectionsWindow, false)
	dxDrawRectangle(x+10, y+32, 256, 256, color.huecurrent, colorPickerFocus)

	dxDrawImage(x+10, y+32, 256, 256, "assets/colorpicker/sv.png", 0, 0, 0, color.white, colorPickerFocus)
  dxDrawImageSection(x+1+math.floor(256*color.s), y+24+(256-math.floor(256*color.v)), 16, 16, 0, 0, 16, 16, "assets/colorpicker/cursor.png", 0, 0, 0, color.white, colorPickerFocus)
  	
  dxDrawImage(x+288, y+32, 32, 256, "assets/colorpicker/h.png", 0, 0, 0, color.white, colorPickerFocus)
  dxDrawImageSection(x+280, y+24+(256-math.floor(256*color.h)), 48, 16, 16, 0, 48, 16, "assets/colorpicker/cursor.png", 0, 0, 0, color.huecurrent, colorPickerFocus)
	
  -- Курсор на яркости --
  --[[
    Из за полоски регуляции яркости идет нормальная нагрузка до 16-20%
    Можно оптимизировать, тобишь переделать регулятор яркости
  --]]
  for i = 0, 255 do 
      color.r, color.g, color.b = hsv2rgb(color.h, color.s, color.v)
      local color = tocolor(color.r, color.g, color.b, i)
      dxDrawRectangle(x+10+i, y+300, 1, 15, color, true)
  end

  local arrowX = x + 10 + color.a 
  local arrowY = y + 300
  dxDrawLine(arrowX, arrowY+20, arrowX, arrowY+30, tocolor(255, 255, 255, 255), 2, true)
  -----------------------
end

function createColorPicker(startColor)
	color.h, color.s, color.v, color.r, color.g, color.b, color.hex = 0, 1, 1, 255, 0, 0, "#FF0000"
	color.white = tocolor(255, 255, 255, 255)
	color.black = tocolor(0, 0, 0, 255)
	color.current = tocolor(255, 0, 0, 255)
	color.huecurrent = tocolor(255, 0, 0, 255)

  color.a  = 255

	gui.snaptreshold = 0.02

	local colorType = type(startColor)
  	if colorType == 'string' and getColorFromString(startColor) then
    	color.h, color.s, color.v = rgb2hsv(getColorFromString(startColor))
 	elseif colorType == 'number' then
   		color.h, color.s, color.v = rgb2hsv(HEXtoRGB(startColor))
      color.huecurrent = startColor
  	end

  -- ЯРКОСТЬ --
  gui.alpha = guiCreateStaticImage(10, 300, 256, 15, "assets/colorpicker/alpha.png", false, UI.sectionsWindow)
  -------------

  gui.svmap = guiCreateStaticImage(10, 32, 256, 256, "assets/colorpicker/blank.png", false, UI.sectionsWindow)
  gui.hbar = guiCreateStaticImage(288, 32, 32, 256, "assets/colorpicker/blank.png", false, UI.sectionsWindow)
  gui.abar = guiCreateStaticImage(10, 300, 256, 15, "assets/colorpicker/blank.png", false, UI.sectionsWindow)

	addEventHandler("onClientGUIMouseDown", gui.svmap, colorPickerMouseDown, false)
  addEventHandler("onClientMouseLeave", gui.svmap, colorPickerMouseSnap, false)
  addEventHandler("onClientMouseMove", gui.svmap, colorPickerMouseMove, false)

  addEventHandler("onClientGUIMouseDown", gui.hbar, colorPickerMouseDown, false)
  addEventHandler("onClientMouseLeave", gui.hbar, colorPickerMouseSnap, false)
  addEventHandler("onClientMouseMove", gui.hbar, colorPickerMouseMove, false)

  addEventHandler("onClientGUIMouseDown", gui.abar, colorPickerMouseDown, false)
  addEventHandler("onClientMouseLeave", gui.abar, colorPickerMouseSnap, false)
  addEventHandler("onClientMouseMove", gui.abar, colorPickerMouseMove, false)

  addEventHandler("onClientClick", root, colorPickerMouseUp)
  addEventHandler("onClientGUIMouseUp", root, colorPickerMouseUp)

  addEventHandler("onClientGUIFocus", UI.sectionsWindow, colorPickerGuiFocus, false)
  addEventHandler("onClientGUIBlur", UI.sectionsWindow, colorPickerGuiBlur, false)

  addEventHandler("onClientRender", root, drawColorPicker)

  guiBringToFront(UI.sectionsWindow)
  colorPickerGuiFocus()
end

function colorPickerDestroy()
	 removeEventHandler("onClientGUIMouseDown", gui.svmap, colorPickerMouseDown, false)
  	removeEventHandler("onClientMouseLeave", gui.svmap, colorPickerMouseSnap, false)
  	removeEventHandler("onClientMouseMove", gui.svmap, colorPickerMouseMove, false)

  	removeEventHandler("onClientGUIMouseDown", gui.hbar, colorPickerMouseDown, false)
    removeEventHandler("onClientMouseLeave", gui.hbar, colorPickerMouseMove, false)
  	removeEventHandler("onClientMouseMove", gui.hbar, colorPickerMouseMove, false)

    removeEventHandler("onClientGUIMouseDown", gui.abar, colorPickerMouseDown, false)
    removeEventHandler("onClientMouseLeave", gui.abar, colorPickerMouseMove, false)
    removeEventHandler("onClientMouseMove", gui.abar, colorPickerMouseMove, false)

  	removeEventHandler("onClientClick", root, colorPickerMouseUp)
  	removeEventHandler("onClientGUIMouseUp", root, colorPickerMouseUp)

  	removeEventHandler("onClientGUIFocus", UI.sectionsWindow, colorPickerGuiFocus, false)
  	removeEventHandler("onClientGUIBlur", UI.sectionsWindow, colorPickerGuiBlur, false)

  	removeEventHandler("onClientRender", root, drawColorPicker)
end

-- UTILS [НАЧАЛО] --

function hsv2rgb(h, s, v)
	local r, g, b
	local i = math.floor(h * 6)
	local f = h * 6 - i
	local p = v * (1 - s)
	local q = v * (1 - f * s)
	local t = v * (1 - (1 - f) * s)
	local switch = i % 6
	if switch == 0 then
		r = v g = t b = p
	elseif switch == 1 then
		r = q g = v b = p
	elseif switch == 2 then
		r = p g = v b = t
	elseif switch == 3 then
		r = p g = q b = v
	elseif switch == 4 then
		r = t g = p b = v
	elseif switch == 5 then
		r = v g = p b = q
	end
	return math.floor(r*255), math.floor(g*255), math.floor(b*255)
end

function rgb2hsv(r, g, b)
	r, g, b = r/255, g/255, b/255
	local max, min = math.max(r, g, b), math.min(r, g, b)
	local h, s 
	local v = max
	local d = max - min
	s = max == 0 and 0 or d/max
	if max == min then 
		h = 0
	elseif max == r then 
	    h = (g - b) / d + (g < b and 6 or 0)
	elseif max == g then 
	    h = (b - r) / d + 2
	elseif max == b then 
	    h = (r - g) / d + 4
	end
	h = h/6
	return h, s, v
end

HEXtoRGB = function(color)
	local b = color % 2^8
  	local g = ( ( color - b ) % 2^16 ) / 2^8
  	local r = ( ( color - b - g * 2^8 ) % 2^24 ) / 2^16
  	local a = ( ( color - b - g * 2^8 - r * 2^16 ) % 2^32 ) / 2^24
  	return r, g, b, a
end

function math.round(v)
  return math.floor(v+0.5)
end

-- UTILS [КОНЕЦ] --
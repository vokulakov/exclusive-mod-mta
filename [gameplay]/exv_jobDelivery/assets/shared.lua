setups = { }

setups.skin = 50 -- рабочий скин
setups.employed_count = 2 -- количество рабочих
setups.car = 440 -- Rumpo (рабочий транспорт)

setups.pricePerFeet = 5 -- зарплата за каждый фут растояния

setups.employed = {x = 1769.1940917969, y = -2022.7886962891, z = 14.145761489868} 

setups.carPosition = Vector3(1768.4951171875, -2031.0473632813, 13.78) -- позиция спавна транспорта

setups.loadPosition = Vector3(2758.7397460938, -2410.9096679688, 13.560119628906) -- позиция загрузки 

setups.unloadPosition = { -- позиция разгрузки
	{
		car_pos = {2753.8269042969, -2425.7143554688, 13.648056030273},
		pl_pos =  {2746.0925292969, -2421.1904296875, 13.628854751587}
	}
}

setups.carBoxPosition = { -- позиция ящиков в авто
	-- --
	{x = -0.56, y = 0, 	   z = -0.15}, --{x = 0, y = 0,     z = -0.15}, {x = 0.56, y = 0,     z = -0.15},
	--[[
	{x = -0.56, y = 0,     z =  0.33}, {x = 0, y = 0,     z =  0.33}, {x = 0.56, y = 0,     z =  0.33},
	-- --
	{x = -0.56, y = -0.55, z = -0.15}, {x = 0, y = -0.55, z = -0.15}, {x = 0.56, y = -0.55, z = -0.15},
	{x = -0.56, y = -0.55, z =  0.33}, {x = 0, y = -0.55, z =  0.33}, {x = 0.56, y = -0.55, z =  0.33},
	-- --
	{x = -0.56, y = -1.1,  z = -0.15}, {x = 0, y = -1.1,  z = -0.15}, {x = 0.56, y = -1.1,  z = -0.15},
	{x = -0.56, y = -1.1,  z =  0.33}, {x = 0, y = -1.1,  z =  0.33}, {x = 0.56, y = -1.1,  z =  0.33},
	-- --
	{x = -0.56, y = -1.65, z = -0.15}, {x = 0, y = -1.65, z = -0.15}, {x = 0.56, y = -1.65, z = -0.15},
	{x = -0.56, y = -1.65, z =  0.33}, {x = 0, y = -1.65, z =  0.33}, {x = 0.56, y = -1.65, z =  0.33},
	-- --
	{x = -0.56, y = -2.2,  z = -0.15}, {x = 0, y = -2.2,  z = -0.15}, {x = 0.56, y = -2.2,  z = -0.15},
	{x = -0.56, y = -2.2,  z =  0.33}, {x = 0, y = -2.2,  z =  0.33}, {x = 0.56, y = -2.2,  z =  0.33},
	--]]
}

function dxDrawCustomText(text, x1, y1, x2, y2, color, scale)
	dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1, x2, y2, color, scale, "default-bold", "center", "center")
end
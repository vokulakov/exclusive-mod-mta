Config = {}

-- Координаты объекта гаража
Config.paintGaragePosition = Vector3(0, 0, 200)
Config.paintGarageModel = 1337

-- Положение машины в покрасочной
Config.garageVehiclePosition = Config.paintGaragePosition + Vector3(0, 0, 0.7)
Config.garageVehicleRotation = Vector3(0, 0, 90)
Config.garageInterior = 1

-- Входы в покрасочные
Config.garageMarkerRadius = 3.5
Config.garageMarkerBlip = 63
Config.garageMarkerColor = {255, 255, 255, 100}

Config.paintGarageMarkers = {

	-- Pay 'n' Spray (Temple) --
	{ 	
		garage = { id = 11, xyz = Vector3(1022, -1035, 31), wdh = Vector3(6, 17, 4) },
		position = Vector3(1024.9, -1023, 31.5),
	}
	
} 

-- Виды транспорта, которые можно красить
Config.allowedVehicleTypes = {
    Automobile = true,
    Bike = true
}

-- цены на покраску
Config.paintPrice = { 
	['stock'] = 20000, -- стандартный
	['gloss'] = 30000, -- глянцевый
	['matte'] = 40000, -- матовый
	['chrome'] = 50000, -- хром
	['chameleon'] = 60000 -- хамелеон
}
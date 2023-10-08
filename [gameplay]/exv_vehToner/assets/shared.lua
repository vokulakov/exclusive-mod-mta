Config = {}

-- Координаты объекта гаража
Config.tonerGaragePosition = Vector3(0, 0, 700)
Config.tonerGarageModel = 1860

-- Положение машины в покрасочной
Config.garageVehiclePosition = Config.tonerGaragePosition + Vector3(0, 0.5, -2.8)
Config.garageVehicleRotation = Vector3(0, 0, 90)
Config.garageInterior = 1

-- Входы в покрасочные
Config.garageMarkerRadius = 3.5
Config.garageMarkerBlip = 63
Config.garageMarkerColor = {255, 255, 255, 100}

Config.tonerGarageMarkers = {

	-- Pay 'n' Spray (Idlewood) --
	{ 	
		garage = { id = 8, xyz = Vector3(2060, -1834.5, 12.6), wdh = Vector3(16, 6, 4) },
		position = Vector3(2063.8, -1831.6, 13.2),
		angle = 90
	}
	
} 

-- Цена
Config.tonerPrice = 45000 

-- Виды транспорта, которые можно красить
Config.allowedVehicleTypes = {
    Automobile = true
}


Config.vehicleTexture = {
	[479] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"}, -- Lamborghini Urus
	[516] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[507] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[547] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[603] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[555] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[458] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[409] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[596] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[470] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[550] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[415] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[560] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[561] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[566] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[490] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[558] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[438] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[551] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[529] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[466] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[492] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[604] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[546] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[426] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[489] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[500] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[496] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[585] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[445] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[405] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[579] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[602] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[467] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[540] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[404] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[599] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[442] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[420] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	[421] = {p="pered_steklo", z="zad_steklo", l="lob_steklo"},
	-------------------------------------------------------------------------------------------------------------------
	[580] = {p={'fr_glass_r','fl_glass_r'}, z={'r_glass_r','rl_glass_r','rr_glass_r'}, l="ws_glass_r"}, -- BMW 750
	[526] = {p={'fl_glass_r','fr_glass_r'}, z={'r_glass_r','rl_glass_r','rr_glass_r'}, l="ws_glass_r"}, -- Golf
	[401] = {p={'fl_glass_r','fr_glass_r'}, z={'r_glass_r','rl_glass_r','rr_glass_r'}, l="ws_glass_r"}, -- ОКА
	[589] = {p={'fl_glass_r','fr_glass_r'}, z={'r_glass_r','rl_glass_r','rr_glass_r'}, l="ws_glass_r"}, -- ВАЗ 2112
	[576] = {p={'fl_glass_r','fr_glass_r'}, z={'r_glass_r','rl_glass_r','rr_glass_r'}, l="ws_glass_r"}, -- ВАЗ 2106
	[418] = {p={'fl_glass_r','fr_glass_r'}, z={'r_glass_r','rl_glass_r','rr_glass_r'}, l="ws_glass_r"}, -- S63 AMG

	[554] = {p={'fr_glass_r','fl_glass_r'}, z={'r_glass_r'}, l="ws_glass_r"}, -- AUDI TT
	[494] = {p={'fl_glass_r','fr_glass_r'}, z={'r_glass_r'}, l="ws_glass_r"}, -- Lamborghini Aventador
	[502] = {p={'fl_glass_r','fr_glass_r'}, z={'r_glass_r'}, l="ws_glass_r"}, -- Ferrari
	[506] = {p={'fl_glass_r','fr_glass_r'}, z={'r_glass_r'}, l="ws_glass_r"}, -- Jaguar F-type
	[535] = {p={'fl_glass_r','fr_glass_r'}, z={'r_glass_r'}, l="ws_glass_r"}, -- Silvia
	[477] = {p={'fl_glass_r','fr_glass_r'}, z={'r_glass_r'}, l="ws_glass_r"}, -- GTR
	[575] = {p={'fl_glass_r','fr_glass_r'}, z={'r_glass_r'}, l="ws_glass_r"}, -- ЗАЗ
	[436] = {p={'fl_glass_r','fr_glass_r'}, z={'r_glass_r'}, l="ws_glass_r"}, -- ВАЗ 2113
	-------------------------------------------------------------------------------------------------------------------
	[562] = {p="tint_2", z="tint_3", l="tint_1"}, -- BMW M4
	[400] = {p="tint_2", z="tint_3", l="tint_1"},
	[505] = {p="tint_2", z="tint_3", l="tint_1"},
	[541] = {p="tint_2", z="tint_3", l="tint_1"},
	[451] = {p="tint_2", z="tint_3", l="tint_1"},
	[503] = {p="tint_2", z="tint_3", l="tint_1"},
	[527] = {p="tint_2", z="tint_3", l="tint_1"},
	-------------------------------------------------------------------------------------------------------------------
	[543] = {p={'tlevopered', 'tpravopered'}, z={'tpravozad','tlevozad','tzad'}, l='tlob'} -- CONTINENTAL GT
}

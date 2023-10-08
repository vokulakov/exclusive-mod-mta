local vehiclesTable = {

	[554] = { number_r = 'r_plate_blank_r', number_f = 'f_plate_blank_r' }, 	-- Audi TT
	[516] = { number = 'nomer', plate = 'ramka' }, 								-- Audi RS6
	[507] = { number = 'nomer', plate = 'ramka' }, 								-- Audi RS7
	[547] = { number = 'nomer', plate = 'ramka' }, 								-- Audi A6
	[503] = { number = 'nplate' },												-- Audi Q7


	[562] = { number = 'nplate', plate = 'ramka' },								-- BMW M4
	[603] = { number = 'nomer', plate = 'ram' },								-- BMW M2
	[555] = { number = 'nomer' },												-- BMW M3 E92
	[458] = { number = 'nomer', plate = 'ram' },								-- BMW M5 F90
	[409] = { number = 'nomer', plate = 'ramka' },								-- BMW E34
	[505] = { number = 'nplate', plate = 'ramka' },								-- BMW I8
	[596] = { number = 'nomer', plate = 'license_frame' },						-- BMW X5M F
	[470] = { number = 'nomer', plate = 'ramka' },								-- BMW X5M E
	[550] = { number = 'nomer', plate = 'ramka' },								-- BMW M5 E60
	[580] = { number_r = 'r_plate_blank_r', number_f = 'f_plate_blank_r' },		-- BMW 750


	[494] = { number_r = 'r_plate_blank_r' },									-- Lamborghini Aventador
	[415] = { number = 'nomer', plate = 'ramka' },								-- Lamborghini
	[479] = { number = 'nomer' },												-- Lamborghini Urus


	[502] = { number_r = 'r_plate_blank_r' },									-- Ferrari
	[541] = { number = 'nplate' }, 												-- Bugatti Chiron
	[451] = { number = 'nplate' }, 												-- Aston Martin
	[506] = { number_r = 'r_plate_blank_r', number_f = 'f_plate_blank_r' },		-- Jaguar F-Type
	[560] = { number = 'nomer', plate = 'ramka' }, 								-- Bentley Bentayga
	[543] = { number = 'nomer', plate = 'ramka' }, 								-- Bentley Continental GT
	[561] = { number = 'nomer', plate = 'ramka' }, 								-- Rolls Royce Ghost
	[566] = { number = 'nomer', plate = 'ramka' }, 								-- Lexus LX 570
	[490] = { number = 'nomer', plate = 'license_frame' }, 						-- Range Rover SVA


	[558] = { number = 'nomer', plate = 'ramka' }, 								-- Toyota GT86
	[438] = { number = 'nomer', plate = 'ramka' }, 								-- Toyota Land Cruise
	[551] = { number = 'nomer', plate = 'ramka' }, 								-- Toyota Camry 70


	[503] = { number = 'nplate' }, 												-- Porsche 911 Turbo S
	[529] = { number = 'nomer', plate = 'license_frame' }, 						-- Porsche Panamera Turbo
	[466] = { number = 'nomer', plate = 'license_frame' }, 						-- Porsche Cayene Turbo


	[535] = { number_r = 'r_plate_blank_r', number_f = 'f_plate_blank_r' }, 	-- Nissan Silvia
	[477] = { number_r = 'r_plate_blank_r', number_f = 'f_plate_blank_r' }, 	-- Nissan GTR35


	[492] = { number = 'nomer', plate = 'ramka' }, 								-- Volvo XC90
	[604] = { number = 'nomer', plate = 'ramka' }, 								-- Mazda 626
	[526] = { number_r = 'r_plate_blank_r', number_f = 'f_plate_blank_r' }, 	-- Volkswagen Golf
	[546] = { number = 'nomer', plate = 'ramka' }, 								-- Mitsubisi Lancer EVO
	[426] = { number = 'nomer', plate = 'ramka' }, 								-- Kia Stinger GT
	[489] = { number = 'nomer' }, 												-- Chevrolet Tahoe


	[575] = { number_r = 'r_plate_blank_r', number_f = 'f_plate_blank_r' }, 	-- ЗАЗ
	[401] = { number_r = 'r_plate_blank_r', number_f = 'f_plate_blank_r' }, 	-- ОКА
	[500] = { number = 'nomer', plate = 'ramka' },								-- NIVA
	[496] = { number = 'nomer', plate = 'ramka' }, 								-- ВАЗ 2108
	[589] = { number_r = 'r_plate_blank_r', number_f = 'f_plate_blank_r' }, 	-- ВАЗ 2112
	[436] = { number_r = 'r_plate_blank_r', number_f = 'f_plate_blank_r' }, 	-- ВАЗ 2113
	[585] = { number = 'nomer' }, 												-- ГАЗ 3110
	[445] = { number = 'nomer', plate = 'ramka' }, 								-- ВАЗ 2170
	[405] = { number = 'nomer', plate = 'ramka' }, 								-- ВАЗ 2107
	[576] = { number_r = 'r_plate_blank_r', number_f = 'f_plate_blank_r' }, 	-- ВАЗ 2106


	[579] = { number = 'nomer', plate = 'ramka' }, -- Mercedes-Benz G500
	[602] = { number = 'nomer', plate = 'ramka' }, -- Mercedes-Benz AMG GT
	[527] = { number = 'nplate' }, -- Mercedes-Benz SLS
	[418] = { number_r = 'r_plate_blank_r', number_f = 'f_plate_blank_r' }, -- Mercedes-Benz S63 AMG
	[467] = { number = 'nomer', plate = 'ramka' }, -- Mercedes-Benz C63 AMG
	[540] = { number = 'nomer', plate = 'license_frame' }, -- Mercedes-Benz GTs
	[404] = { number = 'nomer', plate = 'ramka' }, -- Mercedes-Benz s600
	[599] = { number = 'nomer', plate = 'ramka' }, -- Mercedes-Benz GL63
	[442] = { number = 'nomer', plate = 'ramka' }, -- Mercedes-Benz E63s
	[421] = { number = 'nomer', plate = 'ramka' }, -- Mercedes-Benz W124
 	[420] = { number = 'nomer', plate = 'ramka' } -- Mercedes-Benz W212 E63 AMG
}

local plateShaders = { }

local nomerShaders = { }

local function dxDrawTexture()
	local renderTarget = dxCreateRenderTarget(256, 64)

	dxSetRenderTarget(renderTarget)
		dxDrawImage(0, 0, 256, 64, dxCreateTexture('assets/plate_a.png'))
	dxSetRenderTarget()

	local texture = dxCreateTexture(dxGetTexturePixels(renderTarget))
	destroyElement(renderTarget)

	return texture
end

local function dxDrawPlate()
	local renderTarget = dxCreateRenderTarget(1024, 1024, true)

	dxSetRenderTarget(renderTarget)
		dxDrawImage(0, 0, 1024, 1024, dxCreateTexture('assets/license_frame.png'))
	dxSetRenderTarget()

	local texture = dxCreateTexture(dxGetTexturePixels(renderTarget))
	destroyElement(renderTarget)

	return texture
end

local function setVehicleNumberPlate(vehicle, data)
	if not vehicle then return end

	-- НОМЕРА --
	if data.number then
		if not nomerShaders[vehicle] then
			nomerShaders[vehicle] = { }	
			nomerShaders[vehicle].shader = exports["exv_shaders"]:createShader("texreplace.fx")
			nomerShaders[vehicle].texture = data.number
		end

		engineApplyShaderToWorldTexture(nomerShaders[vehicle].shader, nomerShaders[vehicle].texture, vehicle)
		dxSetShaderValue(nomerShaders[vehicle].shader, "TEXTURE_REMAP", dxDrawTexture())
	end
	------------

	-- НОМЕРА (RDMR) --
	if data.number_r or data.number_f then

		if not nomerShaders[vehicle] then
			nomerShaders[vehicle] = { }
			nomerShaders[vehicle].shader = exports["exv_shaders"]:createShader("texreplace.fx")
		end

		if data.number_r then
			nomerShaders[vehicle].texture_r = data.number_r
			engineApplyShaderToWorldTexture(nomerShaders[vehicle].shader, nomerShaders[vehicle].texture_r, vehicle)
		end

		if data.number_f then
			nomerShaders[vehicle].texture_f = data.number_f
			engineApplyShaderToWorldTexture(nomerShaders[vehicle].shader, nomerShaders[vehicle].texture_f, vehicle)
		end

		dxSetShaderValue(nomerShaders[vehicle].shader, "TEXTURE_REMAP", dxDrawTexture())
	end
	-------------------

	-- РАМКА --
	if data.plate then
		if not plateShaders[vehicle] then
			plateShaders[vehicle] = { }
			plateShaders[vehicle].shader = exports["exv_shaders"]:createShader("texreplace.fx")
			plateShaders[vehicle].texture = data.plate
		end

		engineApplyShaderToWorldTexture(plateShaders[vehicle].shader, plateShaders[vehicle].texture, vehicle)
		dxSetShaderValue(plateShaders[vehicle].shader, "TEXTURE_REMAP", dxDrawPlate())
	end
	-----------

end

local function destroyVehiclePlate(vehicle)
	if not vehicle then return end

	if nomerShaders[vehicle] then

		if nomerShaders[vehicle].texture_r or nomerShaders[vehicle].texture_f then
			if nomerShaders[vehicle].texture_r then
				engineRemoveShaderFromWorldTexture(nomerShaders[vehicle].shader, nomerShaders[vehicle].texture_r, vehicle)
			end

			if nomerShaders[vehicle].texture_f then
				engineRemoveShaderFromWorldTexture(nomerShaders[vehicle].shader, nomerShaders[vehicle].texture_f, vehicle)
			end
		else
			engineRemoveShaderFromWorldTexture(nomerShaders[vehicle].shader, nomerShaders[vehicle].texture, vehicle)
		end

		nomerShaders[vehicle] = nil
	end

	if plateShaders[vehicle] then
		engineRemoveShaderFromWorldTexture(plateShaders[vehicle].shader, plateShaders[vehicle].texture, vehicle)
		plateShaders[vehicle] = nil
	end

end

addEventHandler("onClientElementStreamIn", root, function ()
    if source and getElementType(source) == "vehicle" then
    	local data = vehiclesTable[getElementModel(source)]
    	if data then
    		setVehicleNumberPlate(source, data)
    	end
    end
end)

addEventHandler("onClientElementStreamOut", root, function()
    if source and getElementType(source) == "vehicle" then
        destroyVehiclePlate(source)
    end
end)

addEventHandler("onClientElementDestroy", root, function()
    if source and getElementType(source) == "vehicle" then
    	destroyVehiclePlate(source)
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	for _, vehicle in ipairs(getElementsByType("vehicle")) do
		if isElementStreamedIn(vehicle) then
			local data = vehiclesTable[getElementModel(vehicle)]
    		if data then
				setVehicleNumberPlate(vehicle, data)
			end
		end
	end
end)
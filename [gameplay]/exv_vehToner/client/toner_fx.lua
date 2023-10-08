local scx, scy = guiGetScreenSize()

local shadersCars = { }
local timersVeh = { }

local Lightning = { }

local textures = {
	ColorRamp01   = dxCreateTexture("assets/fx/ColorRamp01.png"),
	smallnoise3d  = dxCreateTexture("assets/fx/smallnoise3d.dds")
}

Lightning.setting = {}

local function setEffectv()
	local v = Lightning.setting
	
	v.renderDistance = 30 

	v.sparkleSize = 0.5	
	v.brightnessFactorPaint = 1.022
	v.brightnessFactorWShield = 1.099
	
	v.bumpSize = 0.05 
	v.bumpSizeWnd = 0 
	
	v.normalXY = 1.2 
	v.normalZ = 2.2
	
	v.minZviewAngleFade = -0.5
	
	v.brightnessAdd = 1 
	v.brightnessMul = 1.25 
	v.brightpassCutoff = 1.16 
	v.brightpassPower = 2 
	
	v.uvMul = {2.0, 0.5} 
	v.uvMov = {0, -2.8} 
	
	v.skyLightIntensity = 1.0

	v.filmDepth = 0.03
	v.filmIntensity = 0.051
end

local myScreenSource = dxCreateScreenSource(scx, scy)

addEventHandler("onClientHUDRender", root, function()
	if myScreenSource then
		dxUpdateScreenSource(myScreenSource)
	end
end)

local function initVehicleToner(veh) -- ИНИЦИАЛИЗАЦИЯ ТОНИРОВКИ
	shadersCars[veh]       = { }
	shadersCars[veh].toner = { }

	shadersCars[veh].car_refgrun = exports["exv_shaders"]:createShader("car_refgrun.fx", 2, 30, true, 'vehicle')
	--dxCreateShader("assets/fx/car_refgrun.fx", 2, 30, true, 'vehicle')

	local v = Lightning.setting
	setEffectv()

	dxSetShaderValue(shadersCars[veh].car_refgrun, "minZviewAngleFade",v.minZviewAngleFade)
	dxSetShaderValue(shadersCars[veh].car_refgrun, "sCutoff",v.brightpassCutoff)
	dxSetShaderValue(shadersCars[veh].car_refgrun, "sPower", v.brightpassPower)			
	dxSetShaderValue(shadersCars[veh].car_refgrun, "sAdd", v.brightnessAdd)
	dxSetShaderValue(shadersCars[veh].car_refgrun, "sMul", v.brightnessMul)
	dxSetShaderValue(shadersCars[veh].car_refgrun, "sNorFacXY", v.normalXY)
	dxSetShaderValue(shadersCars[veh].car_refgrun, "sNorFacZ", v.normalZ)
    dxSetShaderValue(shadersCars[veh].car_refgrun, "brightnessFactor", v.brightnessFactorPaint)  
	dxSetShaderValue(shadersCars[veh].car_refgrun, "uvMul", v.uvMul[1],v.uvMul[2])
	dxSetShaderValue(shadersCars[veh].car_refgrun, "uvMov", v.uvMov[1],v.uvMov[2])
	dxSetShaderValue(shadersCars[veh].car_refgrun, "skyLightIntensity", v.skyLightIntensity)
	dxSetShaderValue(shadersCars[veh].car_refgrun, "sparkleSize", v.sparkleSize)
	dxSetShaderValue(shadersCars[veh].car_refgrun, "filmDepth", v.filmDepth)
	dxSetShaderValue(shadersCars[veh].car_refgrun, "gFilmIntensity", v.filmIntensity)

	dxSetShaderValue(shadersCars[veh].car_refgrun, "bumpSize", v.bumpSize)

	dxSetShaderValue(shadersCars[veh].car_refgrun, "sRandomTexture", textures.smallnoise3d)
	dxSetShaderValue(shadersCars[veh].car_refgrun, "sFringeTexture", textures.ColorRamp01)

	dxSetShaderValue(shadersCars[veh].car_refgrun, "sReflectionTexture", myScreenSource)

	if v.skyLightIntensity == 0 then return end
	local pntBright = v.skyLightIntensity

	timersVeh[veh] = setTimer(function()
		local rSkyTop, gSkyTop, bSkyTop, rSkyBott, gSkyBott, bSkyBott= getSkyGradient()
		local cx, cy, cz = getCameraMatrix()
		if (isLineOfSightClear(cx, cy, cz, cx, cy, cz+30, true, false, false, true, false, true, false, localPlayer)) then 
			pntBright = pntBright+0.015 else pntBright=pntBright-0.015 end
			if pntBright > v.skyLightIntensity then pntBright = v.skyLightIntensity end
			if pntBright < 0 then pntBright = 0 end 
			dxSetShaderValue(shadersCars[veh].car_refgrun, "sSkyColorTop", rSkyTop/255, gSkyTop/255, bSkyTop/255)
			dxSetShaderValue(shadersCars[veh].car_refgrun, "sSkyColorBott", rSkyBott/255, gSkyBott/255, bSkyBott/255)
			dxSetShaderValue(shadersCars[veh].car_refgrun, "sSkyLightIntensity", pntBright)				
	end, 50, 0)	
end

local function setVehicleToner(veh, toner_type, data) -- УСТАНАВЛИВАЕМ ТОНИРОВКУ НА ТРАНСПОРТ (ИЗНАЧАЛЬНО)
	shadersCars[veh].toner[toner_type] = exports["exv_shaders"]:createShader("tex_toner.fx")
	--dxCreateShader("assets/fx/shader.fx")

	dxSetShaderValue(shadersCars[veh].toner[toner_type], "gRedColor", data.r/255)
	dxSetShaderValue(shadersCars[veh].toner[toner_type], "gGrnColor", data.g/255)
	dxSetShaderValue(shadersCars[veh].toner[toner_type], "gBluColor", data.b/255)
	dxSetShaderValue(shadersCars[veh].toner[toner_type], "gAlpha",    data.a/255)

	if type(data.txt) ~= 'table' then
		engineApplyShaderToWorldTexture(shadersCars[veh].toner[toner_type], data.txt, veh)
		engineApplyShaderToWorldTexture(shadersCars[veh].car_refgrun, data.txt, veh)
	else
		for _, v in pairs(data.txt) do
			engineApplyShaderToWorldTexture(shadersCars[veh].toner[toner_type], v, veh)
			engineApplyShaderToWorldTexture(shadersCars[veh].car_refgrun, v, veh)
		end
	end
end

local function updateVehicleToner(veh, toner_type, data) -- ОБНОВИТЬ ТЕКУЩУЮ ТОНИРОВКУ
	if shadersCars[veh].toner[toner_type] then
		dxSetShaderValue(shadersCars[veh].toner[toner_type], "gRedColor", data.r/255)
		dxSetShaderValue(shadersCars[veh].toner[toner_type], "gGrnColor", data.g/255)
		dxSetShaderValue(shadersCars[veh].toner[toner_type], "gBluColor", data.b/255)
		dxSetShaderValue(shadersCars[veh].toner[toner_type], "gAlpha",    data.a/255)
	end
end


local function destroyVehicleToner(veh, toner_type, data) -- УДАЛЕНИЕ ТОНИРОВКИ
	if not shadersCars[veh] then
		return
	end

    if shadersCars[veh].toner[toner_type] then
	    if type(data) ~= 'table' then
			engineRemoveShaderFromWorldTexture(shadersCars[veh].toner[toner_type], data, veh)
			engineRemoveShaderFromWorldTexture(shadersCars[veh].car_refgrun, data, veh)
		else
			for _, v in pairs(data) do
				engineRemoveShaderFromWorldTexture(shadersCars[veh].toner[toner_type], v, veh)
				engineRemoveShaderFromWorldTexture(shadersCars[veh].car_refgrun, v, veh)
			end
		end

		destroyElement(shadersCars[veh].toner[toner_type])
		shadersCars[veh].toner[toner_type] = nil
    end

    if not shadersCars[veh].toner['zad'] and not shadersCars[veh].toner['pered'] and not shadersCars[veh].toner['lob']
    then
    	if isTimer(timersVeh[veh]) then 
    		killTimer(timersVeh[veh]) 
    		timersVeh[veh] = nil
    	end
    	shadersCars[veh] = nil
    end

end

local initialToner = { }

function saveVehicleToner() -- сохранем то что было
	local vehicle = localPlayer.vehicle

	if not vehicle then 
		return
	end

	if vehicle:getData('exv_vehicle.isToner') then -- СОХРАНЯЕМ ТЕКУЩИЙ ТОНЕР
    	local toner_z = vehicle:getData('exv_vehicle.toner_z') or false
    	local toner_p = vehicle:getData('exv_vehicle.toner_p') or false
    	local toner_l = vehicle:getData('exv_vehicle.toner_l') or false

    	if toner_z and not toner_z.remove then
    		initialToner.z = {r = toner_z.r, g = toner_z.g, b = toner_z.b, a = toner_z.a}
    	end

    	if toner_p and not toner_p.remove then
    		initialToner.p = {r = toner_p.r, g = toner_p.g, b = toner_p.b, a = toner_p.a}
    	end

    	if toner_l and not toner_l.remove then
    		initialToner.l = {r = toner_l.r, g = toner_l.g, b = toner_l.b, a = toner_l.a}
    	end
    end
end

function setVehiclePreviewToner(r, g, b, a) -- ПРЕДВАРИТЕЛЬНЫЙ ПРОСМОТР ТОНИРОВКИ
	local vehicle = localPlayer.vehicle

    if not vehicle then
        return
    end

    local vehData = Config.vehicleTexture[getElementModel(vehicle)]

    if guiCheckBoxGetSelected(UI.chekBoxColor_zad) then -- ЗАДНЯЯ ПОЛУСФЕРА
    	vehicle:setData('exv_vehicle.toner_z', {txt = vehData.z, r = r, g = g, b = b, a = a})
    end

    if guiCheckBoxGetSelected(UI.chekBoxColor_pered) then -- ПЕРЕДНИЕ СТЕКЛА
    	vehicle:setData('exv_vehicle.toner_p', {txt = vehData.p, r = r, g = g, b = b, a = a})
    end

    if guiCheckBoxGetSelected(UI.chekBoxColor_lob) then -- ЛОБОВОЕ СТЕКЛО
    	vehicle:setData('exv_vehicle.toner_l', {txt = vehData.l, r = r, g = g, b = b, a = a})
    end

end

function removeVehicleToner(remove) 
	local vehicle = localPlayer.vehicle

    if not vehicle then
        return
    end

    vehicle:setData('exv_vehicle.toner_z', {remove = true, txt = 'zad_steklo'})
    vehicle:setData('exv_vehicle.toner_p', {remove = true, txt = 'pered_steklo'})
    vehicle:setData('exv_vehicle.toner_l', {remove = true, txt = 'lob_steklo'})

    if remove then
    	return
    end
    
    if vehicle:getData('exv_vehicle.isToner') then
    	if initialToner.z then
    		vehicle:setData('exv_vehicle.toner_z', 
	    		{
	    			txt = 'zad_steklo', 
	    			r = initialToner.z.r, 
	    			g = initialToner.z.g, 
	    			b = initialToner.z.b, 
	    			a = initialToner.z.a
	    		}
    		)
    	end

    	if initialToner.p then
    		vehicle:setData('exv_vehicle.toner_p', 
    			{
    				txt = 'pered_steklo', 
    				r = initialToner.p.r, 
    				g = initialToner.p.g, 
    				b = initialToner.p.b, 
    				a = initialToner.p.a
    			}
    		)
    	end

    	if initialToner.l then
    		vehicle:setData('exv_vehicle.toner_l', 
    			{
    				txt = 'lob_steklo', 
    				r = initialToner.l.r, 
    				g = initialToner.l.g, 
    				b = initialToner.l.b, 
    				a = initialToner.l.a
    			}
    		)
    	end
    end
end


local function addVehicleToner(veh, dataKey, vehData)
	if not shadersCars[veh] then
		initVehicleToner(veh)
	end

	if not shadersCars[veh].toner[dataKey] then 
		setVehicleToner(veh, dataKey, vehData)
		return
	end
	-- обновить тонировку
	updateVehicleToner(veh, dataKey, vehData)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    for i, vehicle in ipairs(getElementsByType("vehicle")) do
        if isElementStreamedIn(vehicle) then
        	local toner_z = vehicle:getData('exv_vehicle.toner_z') or false
    		local toner_p = vehicle:getData('exv_vehicle.toner_p') or false
    		local toner_l = vehicle:getData('exv_vehicle.toner_l') or false

    		if toner_z and not toner_z.remove then
    			addVehicleToner(vehicle, 'zad', toner_z)
    		end

    		if toner_p and not toner_p.remove then
    			addVehicleToner(vehicle, 'pered', toner_p)
    		end

    		if toner_l and not toner_l.remove then
    			addVehicleToner(vehicle, 'lob', toner_l)
    		end
        end
    end
end)

addEventHandler("onClientElementStreamIn", root, function()
    if getElementType(source) == "vehicle" then
    	local toner_z = source:getData('exv_vehicle.toner_z') or false
		local toner_p = source:getData('exv_vehicle.toner_p') or false
		local toner_l = source:getData('exv_vehicle.toner_l') or false

		if toner_z and not toner_z.remove then
			addVehicleToner(source, 'zad', toner_z)
		end

		if toner_p and not toner_p.remove then
			addVehicleToner(source, 'pered', toner_p)
		end

		if toner_l and not toner_l.remove then
			addVehicleToner(source, 'lob', toner_l)
		end
    end
end)

addEventHandler("onClientElementStreamOut", root, function()
    if getElementType(source) == "vehicle" then
    	local toner_z = source:getData('exv_vehicle.toner_z') or false
    	local toner_p = source:getData('exv_vehicle.toner_p') or false
    	local toner_l = source:getData('exv_vehicle.toner_l') or false

    	if toner_z and not toner_z.remove then
    		destroyVehicleToner(source, 'zad', toner_z.txt)
    	end

    	if toner_p and not toner_p.remove then
    		destroyVehicleToner(source, 'pered', toner_p.txt)
    	end

    	if toner_l and not toner_l.remove then
    		destroyVehicleToner(source, 'lob', toner_l.txt)
    	end
    end
end)

addEventHandler("onClientElementDestroy", root, function()
    if source and getElementType(source) == "vehicle" then
    	local toner_z = source:getData('exv_vehicle.toner_z') or false
    	local toner_p = source:getData('exv_vehicle.toner_p') or false
    	local toner_l = source:getData('exv_vehicle.toner_l') or false

    	if toner_z and not toner_z.remove then
    		destroyVehicleToner(source, 'zad', toner_z.txt)
    	end

    	if toner_p and not toner_p.remove then
    		destroyVehicleToner(source, 'pered', toner_p.txt)
    	end

    	if toner_l and not toner_l.remove then
    		destroyVehicleToner(source, 'lob', toner_l.txt)
    	end
    end
end)

addEventHandler("onClientElementDataChange", root, function(data)
	if getElementType(source) ~= "vehicle" then return end

	if not isElementStreamedIn(source) then
		return
	end

	local dataKey = false

	if data == 'exv_vehicle.toner_z' then dataKey = 'zad'
	elseif data == 'exv_vehicle.toner_p' then dataKey = 'pered'
	elseif data == 'exv_vehicle.toner_l' then dataKey = 'lob'
	end

	if not dataKey then return end

	local vehData = source:getData(data)

	if vehData.remove then
		destroyVehicleToner(source, dataKey, vehData.txt)
		return 
	end

	addVehicleToner(source, dataKey, vehData)
end)

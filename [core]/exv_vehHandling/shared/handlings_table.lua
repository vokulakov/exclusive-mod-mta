local handlingsTable = {}

------------------------------------------------------
--------------------- HANDLINGS ----------------------
------------------------------------------------------

handlingsTable['YOSEMITE'] = { -- AUDI TT
	street = {
		'YOSEMITE 3000 6000 3 0 0.35 0 80 0.6 0.8 0.4 5 170 10 15 r p 8.5 0.3 false 30 1 0.12 0 0.24 -0.09 0.5 0.5 0.44 0.3 40000 20202020 506600 0 1 0'
	}
}

handlingsTable['ADMIRAL'] = { -- ВАЗ 2170
	street = {
		'ADMIRAL 1650 3851.4 2 0 0 -0.05 75 0.65 0.9 0.51 5 165 8.8 8 f p 8.5 0.52 false 30 1 0.15 0 0.27 0.01 0.5 0.55 0.2 0.56 35000 0 400000 0 1 0'
	}
}

handlingsTable['HUNTLEY'] = { -- Mercedes-Benz G500
	street = {
		'HUNTLEY 2500 6000 2.5 0 0 -0.2 80 0.62 0.89 0.5 5 160 10 25 4 p 7 0.45 false 35 1 0.05 0 0.45 -0.21 0.45 0.3 0.44 0.35 40000 2020 6604 0 1 0'
	}
}

handlingsTable['FAGGIO'] = { -- Escooter
	street = {
		'MOPED 1350 135 5 0 0.05 -0.1 103 1.8 0.9 0.48 3 190 12 5 r p 14 0.5 false 35 1 0.15 0 0.12 -0.17 0.5 0 0 0.11 10000 1001000 0 1 1 5'
	}
}
------------------------------------------------------


local handlingProperties = {"identifier", "mass", "turnMass", "dragCoeff", "centerOfMassX", "centerOfMassY", "centerOfMassZ", "percentSubmerged", "tractionMultiplier", "tractionLoss", "tractionBias", "numberOfGears", "maxVelocity", "engineAcceleration", "engineInertia", "driveType", "engineType", "brakeDeceleration", "brakeBias", "ABS", "steeringLock", "suspensionForceLevel", "suspensionDamping", "suspensionHighSpeedDamping", "suspensionUpperLimit", "suspensionLowerLimit", "suspensionFrontRearBias", "suspensionAntiDiveMultiplier", "seatOffsetDistance", "collisionDamageMultiplier", "monetary", "modelFlags", "handlingFlags", "headLight", "tailLight", "animGroup", "identifier", "mass", "turnMass", "dragCoeff", "centerOfMassX", "centerOfMassY", "centerOfMassZ", "percentSubmerged", "tractionMultiplier", "tractionLoss", "tractionBias", "numberOfGears", "maxVelocity", "engineAcceleration", "engineInertia", "driveType", "engineType", "brakeDeceleration", "brakeBias", "ABS", "steeringLock", "suspensionForceLevel", "suspensionDamping", "suspensionHighSpeedDamping", "suspensionUpperLimit", "suspensionLowerLimit", "suspensionFrontRearBias", "suspensionAntiDiveMultiplier", "seatOffsetDistance", "collisionDamageMultiplier", "monetary", "modelFlags", "handlingFlags", "headLight", "tailLight", "animGroup"}

function hasVehicleHandling(vehicleName, handlingName, level)
	if type(vehicleName) ~= "string" then
		return false
	end
	if handlingName == "job" then
		return true
	end
	if type(handlingsTable[vehicleName]) ~= "table" then
		return false
	end
	if type(handlingName) == "string" then
		if type(handlingsTable[vehicleName][handlingName]) ~= "table" then
			return false
		end
		if #handlingsTable[vehicleName][handlingName] == 0 then
			return false
		end 		
		if type(level) == "number" then
			if type(handlingsTable[vehicleName][handlingName][level]) ~= "string" then
				return false
			end
		end
	end
	return true
end

function getVehicleHandlingString(vehicleName, handlingName, level)
	if not hasVehicleHandling(vehicleName, handlingName, level) then
		return false
	end
	return handlingsTable[vehicleName][handlingName][level]
end

function getVehicleHandlingTable(vehicleName, handlingName, level)
	local handlingString = getVehicleHandlingString(vehicleName, handlingName, level)
	if type(handlingString) ~= "string" then
		return false
	end
	--outputConsole(handlingString)
	return importHandling(handlingString)
end

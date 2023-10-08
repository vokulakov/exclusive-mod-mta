local spawnPosition = {
	--{ x = 1770, y = -1897, z = 13 }, 	-- ЖД
	{ x = 1109, y = -1797, z = 16 } 	-- Автовокзал
}

local function playerSpawn()
 	local num = math.random(1, #spawnPosition)
	local x, y, z = spawnPosition[num].x, spawnPosition[num].y, spawnPosition[num].z
	spawnPlayer(source, x, y, z, 90, 73, 0, 0)
	fadeCamera(source, true, 5)
	setCameraTarget(source, source)
end
addEvent("exv_spawn.spawnPlayer", true)
addEventHandler("exv_spawn.spawnPlayer", root, playerSpawn)

-- SPAWN ПОСЛЕ СМЕРТИ [НАЧАЛО] --
local hospitalPosition = { 
	{ x = -1514.80188, y = 2525.52979, 	z = 55.77423 },
	{ x = -316.49615,  y = 1055.57141, 	z = 19.74219 },
	{ x = 1608.25195,  y = 1822.24780, 	z = 10.82031 },
	{ x = 1244.96936,  y = 333.32199,  	z = 19.55469 },
	{ x = 2038.15881,  y = -1411.80151, z = 17.16406 },
	{ x = 1185.15271,  y = -1323.09509, z = 13.57261 },
	{ x = -2191.75269, y = -2297.68970, z = 30.62500 },
	{ x = -2646.44482, y = 632.93457, 	z = 14.45455 }
}

local function getHospitalForPlayer(player)
	if not player then return end
	local playerHospital = { }

	local xPlayer, yPlayer, zPlayer = getElementPosition(player)
	for i, hospital in ipairs(hospitalPosition) do
		local distance = getDistanceBetweenPoints3D (hospital.x, hospital.y, hospital.z, xPlayer, yPlayer, zPlayer)
		playerHospital[i] = {}
		playerHospital[i].num = i
		playerHospital[i].dis = distance
	end


	local n = #hospitalPosition
	for i = 1, n - 1 do
		for j = 1, n - i do
			if playerHospital[j].dis > playerHospital[j+1].dis then
				local nH, dH = playerHospital[j].num, playerHospital[j].dis
				playerHospital[j].num = playerHospital[j+1].num
				playerHospital[j].dis = playerHospital[j+1].dis
				playerHospital[j+1].num = nH
				playerHospital[j+1].dis = dH
			end
		end
	end

	return hospitalPosition[playerHospital[1].num].x, hospitalPosition[playerHospital[1].num].y, hospitalPosition[playerHospital[1].num].z
end

addEventHandler("onPlayerWasted", root, function()
	
	triggerClientEvent(source, "exv.showDeadScreen", source, true)

	setTimer(
		function(player)
			local x, y, z = getHospitalForPlayer(player)
			
			spawnPlayer(player, x, y, z, 
				getElementRotation(player), 
				getPedSkin(player), 
				getElementInterior(player), 
				getElementDimension(player)
			)

			-- Необходимо добавить списание денег за лечение

			triggerClientEvent(player, "exv.showDeadScreen", player, false)
		end, 
	5000, 1, source)

end)
-- SPAWN ПОСЛЕ СМЕРТИ [КОНЕЦ] --
local pos = Vector3(2107.6064453125, -1213.2869873047, 23.965547561646)

-- fire_med
-- fire_large
-- fire_bike
-- fire_car

-- overheat_car

-- prt_smokeII_3_expand
-- prt_smoke_huge

createEffect('prt_smokeII_3_expand', pos, 0, 0, 0)

local function addFire(position)

	local ped = createPed(120, position)
	--setElementCollisionsEnabled(ped, false)

	createEffect('fire_car', position, 0, 0, 0)
	setElementFrozen(ped, true)
	setElementAlpha(ped, 50)

	addEventHandler("onClientPedDamage", ped, function() cancelEvent() end)

	addEventHandler("onClientPedHitByWaterCannon", root, function()
		outputDebugString('Boom!')
	end)
end

addFire(Vector3(2068.4099121094, -1731.6169433594, 13.87615776062))
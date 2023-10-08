addEventHandler("onResourceStart", resourceRoot, function()

	for _, garageData in ipairs(Config.paintGarageMarkers) do
		local cuboid = garageData.garage
		local garageCube = createColCuboid(cuboid.xyz, cuboid.wdh)

		addEventHandler("onColShapeHit", garageCube, function(player)
			if (player.type == "player") then
				if not player.vehicle or player.vehicle.controller ~= player then
        			return
    			end
				if (not isGarageOpen(cuboid.id)) then
					setGarageOpen(cuboid.id, true)
				end
			end
		end)

		addEventHandler("onColShapeLeave", garageCube, function(player)
			if (player.type == "player") then
				if not player.vehicle or player.vehicle.controller ~= player then
        			return
    			end
				if (isGarageOpen(cuboid.id)) then
					if #getElementsWithinColShape(garageCube, "vehicle") > 1 then
						return
					end
					setTimer(setGarageOpen, 2000, 1, cuboid.id, false)
				end
			end
		end)
	end

end)

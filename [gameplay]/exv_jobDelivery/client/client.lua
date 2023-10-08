local storageBlip, storagePickup

local function createMarkerOnStorage(position)

	if type(position) ~= 'table' then 
		position = setups.loadPosition
	else
		position = Vector3(position.x, position.y, position.z)
	end

	storagePickup = createPickup(position + Vector3(0, 0, 2), 3, 1318, 1000)
	storageBlip = createBlip(position, 41, 0, 255, 0, 0, 255, 0, 450)
end
addEvent('exv_jobDelivery.createBlipOnStorage', true)
addEventHandler('exv_jobDelivery.createBlipOnStorage', root, createMarkerOnStorage)

addEvent('exv_jobDelivery.removeBlipOnStorage', true)
addEventHandler('exv_jobDelivery.removeBlipOnStorage', root, function()
	if isElement(storagePickup) then destroyElement(storagePickup) end
	if isElement(storageBlip) then destroyElement(storageBlip) end
end)

addEventHandler("onClientRender", root, function()
	local cx, cy, cz = getCameraMatrix()
	for _, veh in ipairs(getElementsByType('vehicle', true)) do
		if veh:getData('exv_jobDelivery.isVehicle') then

			local marker = veh:getData('exv_jobDelivery.isVehicleMarker')
			if marker then
				local xP, yP, zP = getElementPosition(marker)
				if (isLineOfSightClear(xP, yP, zP, cx, cy, cz, true, true, false, false, true, true, true, nil)) then
					local x, y = getScreenFromWorldPosition(xP, yP, zP + 0.4)
					if x and y then
						local distance = getDistanceBetweenPoints3D(cx, cy, cz, xP, yP, zP)
						if distance < 65 then
							local vehicle_tunk = veh:getData('exv_jobDelivery.isVehicleTrunk')
							dxDrawCustomText('Груз:\n'..vehicle_tunk.count..' из '..#vehicle_tunk.tunk..'', x, y, x, y, tocolor(255, 255, 255), 1)
						end
					end
				end
			end
		end
	end
end)
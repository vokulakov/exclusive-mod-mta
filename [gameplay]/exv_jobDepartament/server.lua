local function onPickupHitEnter(player)
	if getPedOccupiedVehicle(player) then return end
	local pickup_data = getElementData(source, 'exv_jobDepartament.PickupInfo')
	setElementPosition(player, pickup_data.x, pickup_data.y, pickup_data.z)
	setElementDimension(player, pickup_data.dim)
	setElementInterior(player, pickup_data.int) 
end

addEventHandler('onResourceStart', resourceRoot, function()
	local dep_pic = createPickup(PICKUP_INFO.X, PICKUP_INFO.Y, PICKUP_INFO.Z, 3, 1239, 0)
	setElementData(dep_pic, 'exv_jobDepartament.PickupInfo', 
		{
			text = 'Устройство на работу',
			textZ = 0.6
		}
	)
	setElementDimension(dep_pic, 1)
	setElementInterior(dep_pic, 3)

	addEventHandler("onPickupHit", dep_pic, function(player)
		if getElementType(player) ~= 'player' then return end
		triggerClientEvent(player, 'exv_jobDepartament.showDepartamentWindow', player)
	end)

	local pickup_entrance = createPickup(PICKUP_INFO.eX, PICKUP_INFO.eY, PICKUP_INFO.eZ, 3, 1318, 1, 1)
	setElementData(pickup_entrance, 'exv_jobDepartament.PickupInfo', 
		{
			x = PICKUP_INFO.exitX, 
			y = PICKUP_INFO.exitY,
			z = PICKUP_INFO.exitZ, 
			dim = 1, 
			int = 3,
			text = 'Биржа труда',
			textZ = 0.8
		}
	)
	addEventHandler("onPickupHit", pickup_entrance, onPickupHitEnter)

	local pickup_exit = createPickup(PICKUP_INFO.exitX, PICKUP_INFO.exitY, PICKUP_INFO.exitZ, 3, 1318, 1, 1)
	setElementDimension(pickup_exit, 1)
	setElementInterior(pickup_exit, 3)
	
	setElementData(pickup_exit, 'exv_jobDepartament.PickupInfo', 
		{
			x = PICKUP_INFO.eX, 
			y = PICKUP_INFO.eY, 
			z = PICKUP_INFO.eZ, 
			dim = 0, 
			int = 0,

			text = 'Выход',
			textZ = 0.8
		}
	)
	addEventHandler("onPickupHit", pickup_exit, onPickupHitEnter)

end)

addEvent('exv_jobDepartament.playerEmployed', true)
addEventHandler('exv_jobDepartament.playerEmployed', root, function(data)

	local oldJob = getElementData(source, 'player.JOB')

	if oldJob then
		if oldJob == 'jobLoader' then -- работа грузчика
			triggerEvent('exv_jobLoader.onPlayerServerQuit', source, source, false, false)
		elseif oldJob == 'jobDelivery' then
			triggerEvent('exv_jobDelivery.onPlayerServerQuit', source, source, false, false)
		end
	end

	setElementData(source, 'player.JOB', data)
end)
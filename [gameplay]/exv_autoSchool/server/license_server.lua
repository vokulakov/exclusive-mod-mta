--[[
local veh = createVehicle(445, -2042, -123, 35)
setVehicleColor(veh, 255, 255, 255)

local znak = createObject(1806, 0, 0, 0, 0, 0, 0)
setElementCollisionsEnabled(znak, false)
attachElements(znak, veh, 0, -0.5, 0.99, 0, 0, 90)
]]

local function onPickupHitEnter(player)
	if getPedOccupiedVehicle(player) then return end
	local pickup_data = getElementData(source, 'exv_autoSchool.PickupInfo')
	setElementPosition(player, pickup_data.x, pickup_data.y, pickup_data.z)
	setElementDimension(player, pickup_data.dim)
	setElementInterior(player, pickup_data.int) 
end

addEventHandler('onResourceStart', resourceRoot, function()

	local lic_pic = createPickup(PICKUP_AS.X, PICKUP_AS.Y, PICKUP_AS.Z, 3, 1581, 0)
	setElementData(lic_pic, 'exv_autoSchool.PickupInfo', 
		{
			text = 'Водительское удостоверение',
			textZ = 0.6
		}
	)
	setElementDimension(lic_pic, 1)
	setElementInterior(lic_pic, 3)

	addEventHandler("onPickupHit", lic_pic, function(player)
		if getElementType(player) ~= 'player' then return end
		triggerClientEvent(player, 'exv_autoSchool.showAutoSchoolWindow', player)
	end)

	local pickup_entrance = createPickup(PICKUP_AS.eX, PICKUP_AS.eY, PICKUP_AS.eZ, 3, 1318, 1, 1)
	setElementData(pickup_entrance, 'exv_autoSchool.PickupInfo', 
	{
		x = PICKUP_AS.exitX, 
		y = PICKUP_AS.exitY,
		z = PICKUP_AS.exitZ, 
		dim = 1, 
		int = 3,
		text = 'Автошкола',
		textZ = 0.8
	})
	addEventHandler("onPickupHit", pickup_entrance, onPickupHitEnter)

	local pickup_exit = createPickup(PICKUP_AS.exitX, PICKUP_AS.exitY, PICKUP_AS.exitZ, 3, 1318, 1, 1)
	setElementDimension(pickup_exit, 1)
	setElementInterior(pickup_exit, 3)
	
	setElementData(pickup_exit, 'exv_autoSchool.PickupInfo', 
		{
			x = PICKUP_AS.eX, 
			y = PICKUP_AS.eY, 
			z = PICKUP_AS.eZ, 
			dim = 0, 
			int = 0,

			text = 'Выход',
			textZ = 0.8
		}
	)
	addEventHandler("onPickupHit", pickup_exit, onPickupHitEnter)
end)

local function destroyVehicle(veh)
	if not getElementData(veh, 'exv_autoSchool.isVehicle') then
		return
	end

	local ped = getElementData(veh, 'exv_autoSchool.isVehiclePed')
	local znak = getElementData(veh, 'exv_autoSchool.isVehicleTriangle')

	removeElementData(veh, 'exv_autoSchool.isVehicle')
	removeElementData(veh, 'exv_autoSchool.isVehicleOwned')
	removeElementData(veh, 'exv_autoSchool.isVehicleTriangle')
	removeElementData(veh, 'exv_autoSchool.isVehiclePed')

	destroyElement(ped)
	destroyElement(znak)
	destroyElement(veh)
end

local function startAutoSchoolExam()
	--fadeCamera(source, false, 2)

	-- УЧЕБНАЯ МАШИНА --
	local veh = createVehicle(445, -2020, -189, 35)
	setVehicleColor(veh, 255, 255, 255)
	setElementData(veh, 'exv_autoSchool.isVehicle', true)
	setElementData(veh, 'exv_autoSchool.isVehicleOwned', source)

	local ped = createPed(281, 0, 0, 0)
	warpPedIntoVehicle(ped, veh, 1) 
	setElementData(veh, 'exv_autoSchool.isVehiclePed', ped)

	local znak = createObject(1806, 0, 0, 0, 0, 0, 0)
	setElementCollisionsEnabled(znak, false)
	attachElements(znak, veh, 0, -0.5, 0.99, 0, 0, 90)

	setElementData(veh, 'exv_autoSchool.isVehicleTriangle', znak)

	addEventHandler("onVehicleStartExit", veh, function(player)
		destroyVehicle(veh)
		triggerClientEvent(player, 'exv_notify.addNotification', player, "Вы провалили экзамен!", 2)
	end)

	addEventHandler("onVehicleStartEnter", veh, function(player)
		if not getElementData(veh, 'exv_autoSchool.isVehicle') then
			return
		end

		if getElementData(veh, 'exv_autoSchool.isVehicleOwned') ~= player then
			cancelEvent()
		end
	end)

	setElementDimension(source, 0)
	setElementInterior(source, 0) 
	warpPedIntoVehicle(source, veh)

	setVehicleOverrideLights(veh, 1)  
	setVehicleEngineState(veh, false)

	takePlayerMoney(source, PRICE_AS)
	triggerClientEvent(source, 'exv_notify.addInformation', source, 'ЭКЗАМЕН В АВТОШКОЛЕ: -'..PRICE_AS..'$', true)
	--------------------

end
addEvent('exv_autoSchool.startAutoSchoolExam', true)
addEventHandler('exv_autoSchool.startAutoSchoolExam', root, startAutoSchoolExam)

local function stopAutoSchoolExam()
	triggerClientEvent(source, 'exv_notify.addNotification', source, "Поздравляем!\nВы успешно сдали экзамен.", 1)
	destroyVehicle(getPedOccupiedVehicle(source))

	local licenses = toJSON({true})
	setAccountData(getPlayerAccount(source), 'exv_account.LICENSES', licenses)
	setElementData(source, 'player.LICENSES', licenses)

end
addEvent('exv_autoSchool.stopAutoSchoolExam', true)
addEventHandler('exv_autoSchool.stopAutoSchoolExam', root, stopAutoSchoolExam)

addEventHandler("onPlayerLogin", root, function(_, account)
	local lic_tbl = getAccountData(account, "exv_account.LICENSES")
	if lic_tbl then
		setElementData(source, 'player.LICENSES', lic_tbl)
	end
end)
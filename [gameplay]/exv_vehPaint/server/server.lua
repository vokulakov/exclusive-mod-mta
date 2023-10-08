addEvent("exv_carPaint.paintGarageBuyVehicleColor", true)
addEventHandler("exv_carPaint.paintGarageBuyVehicleColor", root, function(money, r, g, b, r1, g1, b1)
	if not source.vehicle then
        return
    end

	setVehicleColor(source.vehicle, r, g, b, r1, g1, b1)

	setTimer(function(pl, money)
		takePlayerMoney(pl, money)
		triggerClientEvent(pl, 'exv_notify.addInformation', pl, 'ПОКРАСКА: -'..money..'$', true)
	end, 7000, 1, source, money)

	triggerClientEvent(source, 'exv_notify.addNotification', source, 'Вы покрасили транспорт за '..money..'$', 1, false)
end)
local user_serial = {
	['891BE8A566A01E24C32E1DD5A1C37752'] = true, -- Вовка
	['E10F6EF3EB73D2AA872F42F8FD1465F2'] = true, -- Ильдар
	['46775019EC1EB4926E864EBA38958971'] = true, -- Вовка (ПК)
	['91FF13D2D1EF80F2A9CB5B790692DAF3'] = true -- РОСТИК
}

addEventHandler("onPlayerJoin", root, function()
	local player_serial = getPlayerSerial(source)

	if not user_serial[player_serial] then
		return kickPlayer(source, "", "У вас нет доступа!")
	end
end)
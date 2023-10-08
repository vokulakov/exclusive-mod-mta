bindKey("t", "down", "chatbox", "Сказать")
bindKey("y", "down", "chatbox", "")

-- клиентские команды
function startCommandClient(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	if source ~= localPlayer then return end
	local state = executeCommandHandler(arg1, arg2, arg3, arg4, arg5, arg6, arg7)

	if not state then
		triggerEvent('exv_notify.addNotification', source, 'Неизвестная команда', 2)
	end

end
addEvent("startCommandClient", true)
addEventHandler("startCommandClient", root, startCommandClient)

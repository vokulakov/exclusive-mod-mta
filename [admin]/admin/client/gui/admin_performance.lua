﻿--[[**********************************
*
*	Multi Theft Auto - Admin Panel
*
*	gui\admin_performance.lua
*
*	Original File by lil_Toady
*
**************************************]]

aPerformanceForm = nil

function aPerformance ()
	if ( aPerformanceForm == nil ) then
		local x, y = guiGetScreenSize()
		aPerformanceForm	= guiCreateWindow ( x / 2 - 160, y / 2 - 100, 320, 320, "Настройки админа", false )
		aPerformanceLabel	= guiCreateLabel ( 0.03, 0.87, 0.74, 0.18, "Рекомендуется выгружать при редком использовании сохранения RAM", true, aPerformanceForm )
					   guiLabelSetHorizontalAlign ( aPerformanceLabel, "left", true )
					   guiLabelSetColor ( aPerformanceLabel, 255, 0, 0 )
		aPerformanceSpectator	= guiCreateCheckBox ( 0.05, 0.10, 0.90, 0.08, "Выгрузка слежения если не используется", false, true, aPerformanceForm )
		aPerformanceEditor	= guiCreateCheckBox ( 0.05, 0.18, 0.90, 0.08, "Выгрузка редактора карт если не используется", false, true, aPerformanceForm )
		aPerformanceTeam	= guiCreateCheckBox ( 0.05, 0.26, 0.90, 0.08, "Выгрузка формы Команда если не используется", false, true, aPerformanceForm )
		aPerformanceSkin	= guiCreateCheckBox ( 0.05, 0.34, 0.90, 0.08, "Выгрузка формы Скин если не используется", false, true, aPerformanceForm )
		aPerformanceStats	= guiCreateCheckBox ( 0.05, 0.42, 0.90, 0.08, "Выгрузка формы Статистика если не используется", false, true, aPerformanceForm )
		aPerformanceVehicle	= guiCreateCheckBox ( 0.05, 0.50, 0.90, 0.08, "Выгрузка формы Автомобиль если не используется", false, true, aPerformanceForm )
		aPerformanceBan	= guiCreateCheckBox ( 0.05, 0.58, 0.90, 0.08, "Выгрузка формы Бан если не используется", false, true, aPerformanceForm )
					   guiCreateStaticImage ( 0.05, 0.68, 0.60, 0.003, "gui\\images\\dot.png", true, aPerformanceForm )
		aPerformanceInput	= guiCreateCheckBox ( 0.05, 0.70, 0.90, 0.08, "Выгрузка всплывающего окна если не используется", false, true, aPerformanceForm )
		aPerformanceMessage	= guiCreateCheckBox ( 0.05, 0.78, 0.90, 0.08, "Выгрузка окна сообщений если не используется", false, true, aPerformanceForm )

		aPerformanceOk	= guiCreateButton ( 0.79, 0.90, 0.18, 0.08, "ОК", true, aPerformanceForm )

		addEventHandler ( "onClientGUIClick", aPerformanceForm, aClientPerformanceClick )
		guiSetVisible ( aPerformanceForm, false )
		--Register With Admin Form
		aRegister ( "Performance", aPerformanceForm, aPerformance, aPerformanceClose )
	else
		guiSetVisible ( aPerformanceForm, true )
		guiBringToFront ( aPerformanceForm )
	end
end

function aPerformanceClose ( destroy )
	if ( destroy ) then
		removeEventHandler ( "onClientGUIClick", aPerformanceForm, aClientPerformanceClick )
		destroyElement ( aPerformanceForm )
		aPerformanceForm = nil
	else
		guiSetVisible ( aPerformanceForm, false )
	end
end

function aClientPerformanceClick ( button )
	if ( button == "left" ) then
		if ( source == aPerformanceOk ) then
			aPerformanceClose ()
		end
	end
end
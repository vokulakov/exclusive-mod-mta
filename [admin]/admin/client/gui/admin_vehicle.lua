﻿--[[**********************************
*
*	Multi Theft Auto - Admin Panel
*
*	gui\admin_stats.lua
*
*	Original File by lil_Toady
*
**************************************]]

aVehicleForm = nil
aVehicleCustomizePlayer = nil
aVehicleCustomizeVehicle = nil
aVehicleUpgrades = {}
aUpgradeNames = {}

function aVehicleCustomize ( player )
	if ( aVehicleForm == nil ) then
		local x, y = guiGetScreenSize()
		aVehicleForm		= guiCreateWindow ( x / 2 - 300, y / 2 - 150, 600, 450, "Тюнинг автомобилей", false )

		local node = xmlLoadFile ( "conf\\upgrades.xml" )
		if ( node ) then
			local upgrades = 0
			while ( xmlFindChild ( node, "upgrade", upgrades ) ~= false ) do
				local upgrade = xmlFindChild ( node, "upgrade", upgrades )
				local id = tonumber ( xmlNodeGetAttribute ( upgrade, "id" ) )
				local name = xmlNodeGetAttribute ( upgrade, "name" )
				aUpgradeNames[id] = name
				upgrades = upgrades + 1
			end
			xmlUnloadFile ( node )
		end

		local c = 1
		for i = 1, 17 do
			if ( i ~= 12 ) then
				guiCreateLabel ( 0.05, 0.05 * ( c + 1 ), 0.15, 0.05, getVehicleUpgradeSlotName ( i - 1 )..":", true, aVehicleForm )
				aVehicleUpgrades[c] = {}
				aVehicleUpgrades[c].id = i - 1
				aVehicleUpgrades[c].edit = guiCreateEdit ( 0.25, 0.05 * ( c + 1 ), 0.27, 0.048, "", true, aVehicleForm )
				aVehicleUpgrades[c].drop = guiCreateStaticImage ( 0.485, 0.05 * ( c + 1 ), 0.035, 0.048, "client\\images\\dropdown.png", true, aVehicleForm )
				aVehicleUpgrades[c].list = guiCreateGridList ( 0.25, 0.05 * ( c + 1 ), 0.27, 0.25, true, aVehicleForm )
				aVehicleUpgrades[c].label = guiCreateLabel ( 0.54, 0.05 * ( c + 1 ), 0.05, 0.07, "(0)", true, aVehicleForm )
				guiEditSetReadOnly ( aVehicleUpgrades[c].edit, true )
				guiGridListAddColumn( aVehicleUpgrades[c].list, "Апгрейд ID", 0.90 )
				guiSetVisible ( aVehicleUpgrades[c].list, false )
				c = c + 1
			end
		end

		aVehicleUpgradeAll	= guiCreateButton ( 0.04, 0.92, 0.15, 0.05, "Обновить все", true, aVehicleForm )
		aVehicleRemoveAll	= guiCreateButton ( 0.20, 0.92, 0.15, 0.05, "Отменить все", true, aVehicleForm )
		aVehicleUpgrade	= guiCreateButton ( 0.375, 0.92, 0.23, 0.05, "Обновить выбранное", true, aVehicleForm )

		guiCreateStaticImage ( 0.60, 0.10, 0.002, 0.80, "client\\images\\dot.png", true, aVehicleForm )

					   guiCreateLabel ( 0.63, 0.10, 0.15, 0.05, "Покраска:", true, aVehicleForm )
		aVehiclePaintjob	= guiCreateEdit ( 0.79, 0.10, 0.09, 0.048, "0", true, aVehicleForm )
		aVehiclePaintjobDrop	= guiCreateStaticImage ( 0.845, 0.10, 0.035, 0.048, "client\\images\\dropdown.png", true, aVehicleForm )
		aVehiclePaintjobList	= guiCreateGridList ( 0.79, 0.10, 0.09, 0.25, true, aVehicleForm )
					   guiEditSetReadOnly ( aVehiclePaintjob, true )
					   guiGridListAddColumn( aVehiclePaintjobList, "", 0.65 )
					   guiSetVisible ( aVehiclePaintjobList, false )
		for i = 0, 3 do guiGridListSetItemText ( aVehiclePaintjobList, guiGridListAddRow ( aVehiclePaintjobList ), 1, tostring ( i ), false, false ) end
		aVehiclePaintjobSet	= guiCreateButton ( 0.89, 0.10, 0.12, 0.04, "Поставить", true, aVehicleForm )
					   guiCreateLabel ( 0.63, 0.15, 0.15, 0.05, "Цвет автомобиля:", true, aVehicleForm )
					   guiCreateLabel ( 0.63, 0.20, 0.15, 0.05, "Цвет1:", true, aVehicleForm )
					   guiCreateLabel ( 0.63, 0.25, 0.15, 0.05, "Цвет2:", true, aVehicleForm )
					   guiCreateLabel ( 0.63, 0.30, 0.15, 0.05, "Цвет3:", true, aVehicleForm )
					   guiCreateLabel ( 0.63, 0.35, 0.15, 0.05, "Цвет4:", true, aVehicleForm )
		aVehicleColor1		= guiCreateEdit ( 0.79, 0.20, 0.09, 0.048, "0", true, aVehicleForm ) guiEditSetMaxLength ( aVehicleColor1, 3 )
		aVehicleColor2		= guiCreateEdit ( 0.79, 0.25, 0.09, 0.048, "0", true, aVehicleForm ) guiEditSetMaxLength ( aVehicleColor2, 3 )
		aVehicleColor3		= guiCreateEdit ( 0.79, 0.30, 0.09, 0.048, "0", true, aVehicleForm ) guiEditSetMaxLength ( aVehicleColor3, 3 )
		aVehicleColor4		= guiCreateEdit ( 0.79, 0.35, 0.09, 0.048, "0", true, aVehicleForm ) guiEditSetMaxLength ( aVehicleColor4, 3 )
					   guiCreateLabel ( 0.90, 0.20, 0.08, 0.05, "(0-126)", true, aVehicleForm )
					   guiCreateLabel ( 0.90, 0.25, 0.08, 0.05, "(0-126)", true, aVehicleForm )
					   guiCreateLabel ( 0.90, 0.30, 0.08, 0.05, "(0-126)", true, aVehicleForm )
					   guiCreateLabel ( 0.90, 0.35, 0.08, 0.05, "(0-126)", true, aVehicleForm )
		aVehicleColorScheme	= guiCreateButton ( 0.62, 0.41, 0.21, 0.04, "Просмотр ID цветов", true, aVehicleForm )
		aVehicleColorSet	= guiCreateButton ( 0.86, 0.41, 0.12, 0.04, "Поставить", true, aVehicleForm )
		aVehicleUpgradeNames = guiCreateCheckBox ( 0.63, 0.60, 0.30, 0.04, "Показывать изменения", false, true, aVehicleForm )
					   if ( aGetSetting ( "aVehicleUpgradeNames" ) ) then guiCheckBoxSetSelected ( aVehicleUpgradeNames, true ) end
		aVehicleClose		= guiCreateButton ( 0.86, 0.92, 0.19, 0.05, "Закрыть", true, aVehicleForm )

		aVehicleColorForm	= guiCreateWindow ( x / 2 - 280, y / 2 - 150, 540, 215, "Возможные цвета", false )
					   guiCreateStaticImage ( 0.01, 0.08, 0.98, 0.80, "client\\images\\colorscheme.png", true, aVehicleColorForm )
		aVehicleColorClose	= guiCreateButton ( 0.86, 0.86, 0.19, 0.15, "Закрыть", true, aVehicleColorForm )
					   guiSetVisible ( aVehicleColorForm, false )
		guiSetVisible ( aVehicleForm, false )
		addEventHandler ( "onClientGUIDoubleClick", aVehicleForm, aClientVehicleDoubleClick )
		addEventHandler ( "onClientGUIClick", aVehicleForm, aClientVehicleClick )
		addEventHandler ( "onClientGUIClick", aVehicleColorClose, aClientVehicleClick )
		--Register With Admin Form
		aRegister ( "VehicleCustomize", aVehicleForm, aVehicleCustomize, aVehicleCustomizeClose )
	end
	local vehicle = getPedOccupiedVehicle ( player )
	if ( vehicle ) then
		local update = true
		if ( isElement ( aVehicleCustomizeVehicle ) ) then
			if ( getElementModel ( aVehicleCustomizeVehicle ) == getElementModel ( vehicle ) ) then
				update = false
			end
		end
		guiSetText ( aVehicleForm, "Тюнинг автомобилей ("..tostring ( getVehicleName ( vehicle ) )..")" )
		aVehicleCustomizePlayer = player
		aVehicleCustomizeVehicle = vehicle
		if ( update ) then aVehicleCheckUpgrades ( vehicle ) end
		aVehicleCheckCurrentUpgrades ( vehicle )
		guiSetVisible ( aVehicleForm, true )
		guiBringToFront ( aVehicleForm )
	end
end

function aVehicleCustomizeClose ( destroy )
	if ( ( destroy ) or ( guiCheckBoxGetSelected ( aPerformanceVehicle ) ) ) then
		if ( aVehicleForm ) then
			removeEventHandler ( "onClientGUIClick", aVehicleForm, aClientVehicleClick )
			removeEventHandler ( "onClientGUIDoubleClick", aVehicleForm, aClientVehicleDoubleClick )
			removeEventHandler ( "onClientGUIClick", aVehicleColorClose, aClientVehicleClick )
			destroyElement ( aVehicleForm )
			destroyElement ( aVehicleColorForm )
			aVehicleCustomizePlayer = nil
			aVehicleCustomizeVehicle = nil
			aVehicleForm = nil
			aVehicleUpgrades = {}
		end
	else
		guiSetVisible ( aVehicleForm, false )
		guiSetVisible ( aVehicleColorForm, false )
	end
end

function aVehicleCheckUpgrades ( vehicle )
	if ( vehicle ) then
		for slot, v in ipairs ( aVehicleUpgrades ) do
			guiGridListClear ( aVehicleUpgrades[slot].list )
			local row = guiGridListAddRow ( aVehicleUpgrades[slot].list )
			guiGridListSetItemText ( aVehicleUpgrades[slot].list, row, 1, "", false, false )
			local upgrades = getVehicleCompatibleUpgrades ( vehicle, aVehicleUpgrades[slot].id )
			guiSetText ( aVehicleUpgrades[slot].label, "("..#upgrades..")" )
			guiSetText ( aVehicleUpgrades[slot].edit, "" )
			if ( getVehicleUpgradeOnSlot ( vehicle, aVehicleUpgrades[slot].id ) > 0 ) then
				if ( guiCheckBoxGetSelected ( aVehicleUpgradeNames ) ) then
					guiSetText ( aVehicleUpgrades[slot].edit, tostring ( aUpgradeNames[getVehicleUpgradeOnSlot ( vehicle, aVehicleUpgrades[slot].id )] ) )
				else
					guiSetText ( aVehicleUpgrades[slot].edit, tostring ( getVehicleUpgradeOnSlot ( vehicle, aVehicleUpgrades[slot].id ) ) )
				end
			end
			for i, upgrade in ipairs ( upgrades ) do
				local row = guiGridListAddRow ( aVehicleUpgrades[slot].list )
				if ( guiCheckBoxGetSelected ( aVehicleUpgradeNames ) ) then
					guiGridListSetItemText ( aVehicleUpgrades[slot].list, row, 1, tostring ( aUpgradeNames[tonumber(upgrade)] ), false, false )
				else
					guiGridListSetItemText ( aVehicleUpgrades[slot].list, row, 1, tostring ( upgrade ), false, false )
				end
			end
		end
	else
		outputChatBox ( "You must be in a vehicle.", 255, 0, 0 )
	end
end

function aVehicleCheckCurrentUpgrades ( vehicle )
	if ( vehicle and isElement( vehicle ) ) then
		for slot, v in ipairs ( aVehicleUpgrades ) do
			if ( getVehicleUpgradeOnSlot ( vehicle, aVehicleUpgrades[slot].id ) > 0 ) then
				if ( guiCheckBoxGetSelected ( aVehicleUpgradeNames ) ) then
					guiSetText ( aVehicleUpgrades[slot].edit, tostring ( aUpgradeNames[getVehicleUpgradeOnSlot ( vehicle, aVehicleUpgrades[slot].id )] ) )
				else
					guiSetText ( aVehicleUpgrades[slot].edit, tostring ( getVehicleUpgradeOnSlot ( vehicle, aVehicleUpgrades[slot].id ) ) )
				end
			else
				guiSetText ( aVehicleUpgrades[slot].edit, "" )
			end
		end
	end
end

function aGetVehicleUpgradeFromName ( uname )
	for id, name in pairs ( aUpgradeNames ) do
		if ( name == uname ) then
			return id
		end
	end
	return false
end

function aClientVehicleDoubleClick ( button )
	if ( button == "left" ) then
		if ( source == aVehiclePaintjobList ) then
			if ( guiGridListGetSelectedItem ( source ) ~= -1 ) then
				local paintjob = guiGridListGetItemText ( source, guiGridListGetSelectedItem ( source ), 1 )
				guiSetText ( aVehiclePaintjob, tostring ( paintjob ) )
			end
					guiSetVisible ( source, false )
		else
			for id, element in ipairs ( aVehicleUpgrades ) do
				if ( source == element.list ) then
					if ( guiGridListGetSelectedItem ( source ) ~= -1 ) then
						local upgrade = guiGridListGetItemText ( source, guiGridListGetSelectedItem ( source ), 1 )
						guiSetText ( element.edit, tostring ( upgrade ) )
					end
					guiSetVisible ( source, false )
					return
				end
			end
		end
	end
end

function aClientVehicleClick ( button )
	if ( source ~= aVehiclePaintjobList ) then guiSetVisible ( aVehiclePaintjobList, false ) end
	if ( button == "left" ) then
		for id, element in ipairs ( aVehicleUpgrades ) do
			if ( source ~= element.list ) then guiSetVisible ( element.list, false ) end
			if ( source == element.edit ) then
				guiBringToFront ( element.drop )
			elseif ( source == element.drop ) then
				guiSetVisible ( element.list, true )
				guiBringToFront ( element.list )
			end
		end
		if ( source == aVehiclePaintjob ) then
			guiBringToFront ( aVehiclePaintjobDrop )
		elseif ( source == aVehicleClose ) then
			aVehicleCustomizeClose ( false )
		elseif ( source == aVehicleColorClose ) then
			guiSetVisible ( aVehicleColorForm, false )
		elseif ( source == aVehicleColorSet ) then
			triggerServerEvent ( "aVehicle", getLocalPlayer(), aVehicleCustomizePlayer, "setcolor", { guiGetText ( aVehicleColor1 ), guiGetText ( aVehicleColor2 ), guiGetText ( aVehicleColor3 ), guiGetText ( aVehicleColor4 ) } )
		elseif ( source == aVehicleColorScheme ) then
			guiSetVisible ( aVehicleColorForm, true )
			guiBringToFront ( aVehicleColorForm )
		elseif ( source == aVehicleUpgradeAll ) then
			triggerServerEvent ( "aVehicle", getLocalPlayer(), aVehicleCustomizePlayer, "customize", { "all" } )
			setTimer ( aVehicleCheckCurrentUpgrades, 2000, 1, aVehicleCustomizeVehicle )
		elseif ( source == aVehicleRemoveAll ) then
			triggerServerEvent ( "aVehicle", getLocalPlayer(), aVehicleCustomizePlayer, "customize", { "remove" } )
			setTimer ( aVehicleCheckCurrentUpgrades, 2000, 1, aVehicleCustomizeVehicle )
		elseif ( source == aVehiclePaintjobSet ) then
			triggerServerEvent ( "aVehicle", getLocalPlayer(), aVehicleCustomizePlayer, "setpaintjob", tonumber ( guiGetText ( aVehiclePaintjob ) ) )
		elseif ( source == aVehiclePaintjobDrop ) then
			guiSetVisible ( aVehiclePaintjobList, true )
			guiBringToFront ( aVehiclePaintjobList )
		elseif ( source == aVehicleUpgradeNames ) then
			aVehicleCheckUpgrades ( aVehicleCustomizeVehicle )
			aSetSetting ( "aVehicleUpgradeNames", guiCheckBoxGetSelected ( aVehicleUpgradeNames ) )
		elseif ( source == aVehicleUpgrade ) then
			local tableOut = {}
			for id, element in ipairs ( aVehicleUpgrades ) do
				local upgrade = guiGetText ( element.edit )
				if ( upgrade ) and ( upgrade ~= "" ) then
					if ( guiCheckBoxGetSelected ( aVehicleUpgradeNames ) ) then
						local upgrade = aGetVehicleUpgradeFromName ( upgrade )
						if ( upgrade ) then table.insert ( tableOut, upgrade ) end
					else
						table.insert ( tableOut, tonumber ( upgrade ) )
					end
				end
			end
			triggerServerEvent ( "aVehicle", getLocalPlayer(), aVehicleCustomizePlayer, "customize", tableOut )
			setTimer ( aVehicleCheckCurrentUpgrades, 2000, 1, aVehicleCustomizeVehicle )
		end
	end
end
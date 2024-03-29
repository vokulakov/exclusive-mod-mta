local sWidth, sHeight = guiGetScreenSize() 
local wnd = { }

local function showLoginPanel()

	if isElement(wnd['window']) then return end

	wnd['window'] = guiCreateWindow(sWidth/2-400/2, sHeight/2-250/2, 400, 270, "", false)

    wnd['window_tabPlanel'] = guiCreateTabPanel(0, 0.1, 1, 1, true, wnd['window'])

    -- GUI Авторизация [НАЧАЛО] --

    wnd['login_tab'] = guiCreateTab("Авторизация", wnd['window_tabPlanel'])

   	wnd['login_tab_info'] = guiCreateLabel(0, -0.03, 1, 0.3, "Добро пожаловать!\nПожалуйста авторизуйтесь или\n зарегистрируйтесь!", true, wnd['login_tab'])
    guiSetFont(wnd['login_tab_info'], "default-bold-small")
    guiLabelSetHorizontalAlign(wnd['login_tab_info'], "center", false)
    guiLabelSetVerticalAlign(wnd['login_tab_info'], "center")

    wnd['login_login_lbl'] = guiCreateLabel(50, 55, 42, 19, "Логин:", false,  wnd['login_tab'])
    guiSetFont(wnd['login_login_lbl'], "default-bold-small")
    guiLabelSetHorizontalAlign( wnd['login_login_lbl'], "right", false)
    guiLabelSetVerticalAlign( wnd['login_login_lbl'], "center")

    wnd['login_login_edit'] = guiCreateEdit(110, 55, 180, 23, "", false, wnd['login_tab'])
    guiEditSetMaxLength(wnd['login_login_edit'], 25)

    wnd['login_password_lbl'] = guiCreateLabel(43, 85, 50, 19, "Пароль:", false, wnd['login_tab'])
    guiSetFont(wnd['login_password_lbl'], "default-bold-small")
    guiLabelSetHorizontalAlign(wnd['login_password_lbl'], "right", false)
    guiLabelSetVerticalAlign(wnd['login_password_lbl'], "center")

    wnd['login_password_edit'] = guiCreateEdit(110, 85, 180, 23, "", false, wnd['login_tab'])
    guiEditSetMasked(wnd['login_password_edit'], true)
    guiEditSetMaxLength(wnd['login_password_edit'], 25)

 	wnd['checkbox_save'] = guiCreateCheckBox(110, 115, 100, 20, "Сохранить", true, false, wnd['login_tab'])
    guiSetFont(wnd['checkbox_save'], "default-bold-small")

  	wnd['login_error'] = guiCreateLabel(0, 127, 400, 36, "", false, wnd['login_tab'])
    guiSetFont(wnd['login_error'], "default-bold-small")
    guiLabelSetColor(wnd['login_error'], 255, 0, 0)
    guiLabelSetHorizontalAlign(wnd['login_error'], "center", false)
    guiLabelSetVerticalAlign(wnd['login_error'], "center")

    wnd['login_but_login'] = guiCreateButton(110, 165, 180, 30, "Войти", false, wnd['login_tab'])
    guiSetFont(wnd['login_but_login'], "default-bold-small")
    -- GUI Авторизация [КОНЕЦ] --

    -- GUI Регистрация [НАЧАЛО] --
    wnd['reg_tab'] = guiCreateTab("Регистрация", wnd['window_tabPlanel'])

    wnd['reg_tab_info'] = guiCreateLabel(0, 0, 1, 0.2, "Заполните все поля! (Не используйте\"!@#$\"%'^&*()\")", true, wnd['reg_tab'])
    guiSetFont(wnd['reg_tab_info'], "default-bold-small")
    guiLabelSetHorizontalAlign(wnd['reg_tab_info'], "center", false)
    guiLabelSetVerticalAlign(wnd['reg_tab_info'], "center")

    wnd['reg_login_lbl'] = guiCreateLabel(10, 40, 119, 21, "Имя пользователя:", false, wnd['reg_tab'])
    guiSetFont(wnd['reg_login_lbl'], "default-bold-small")
    guiLabelSetHorizontalAlign(wnd['reg_login_lbl'], "right", false)
    guiLabelSetVerticalAlign(wnd['reg_login_lbl'], "center")

    wnd['reg_login_edit'] = guiCreateEdit(140, 39, 180, 23, "", false, wnd['reg_tab'])
    guiEditSetMaxLength(wnd['reg_login_edit'], 25)

    wnd['reg_password_lbl'] = guiCreateLabel(10, 71, 119, 21, "Пароль:", false, wnd['reg_tab'])
    guiSetFont(wnd['reg_password_lbl'], "default-bold-small")
    guiLabelSetHorizontalAlign(wnd['reg_password_lbl'], "right", false)
    guiLabelSetVerticalAlign(wnd['reg_password_lbl'], "center")

    wnd['reg_password_edit'] = guiCreateEdit(140, 72, 180, 23, "", false, wnd['reg_tab'])
	guiEditSetMaxLength(wnd['reg_password_edit'], 25)
	guiEditSetMasked(wnd['reg_password_edit'], true)

    wnd['reg_repassword_lbl']  = guiCreateLabel(10, 102, 119, 21, "Повторите пароль:", false, wnd['reg_tab'])
    guiSetFont(wnd['reg_repassword_lbl'], "default-bold-small")
    guiLabelSetHorizontalAlign(wnd['reg_repassword_lbl'], "right", false)
    guiLabelSetVerticalAlign(wnd['reg_repassword_lbl'], "center")

    wnd['reg_repassword_edit'] = guiCreateEdit(140, 105, 180, 23, "", false, wnd['reg_tab'])
    guiEditSetMaxLength(wnd['reg_repassword_edit'], 25)
	guiEditSetMasked(wnd['reg_repassword_edit'], true)

    wnd['reg_error'] = guiCreateLabel(0, 127, 400, 36, "", false, wnd['reg_tab'])
    guiSetFont(wnd['reg_error'],"default-bold-small")
    guiSetFont(wnd['reg_error'], "default-bold-small")
    guiLabelSetColor(wnd['reg_error'], 255, 20, 0)
    guiLabelSetHorizontalAlign(wnd['reg_error'], "center", false)
    guiLabelSetVerticalAlign(wnd['reg_error'], "center")    

	wnd['reg_but_reg'] = guiCreateButton(10, 165, 365, 35, "Подтвердить и зарегистрироваться", false, wnd['reg_tab'])
	guiSetFont(wnd['reg_but_reg'], "default-bold-small")
    -- GUI Регистрация [КОНЕЦ] --

	guiSetText(wnd['reg_error'], "")
	guiSetText(wnd['login_error'], "")

    local username, password = loadLoginFromXML()
        
    if not (username == "" or password == "") then
        guiCheckBoxSetSelected(wnd['checkbox_save'], true)
        guiSetText(wnd['login_login_edit'], tostring(username))
        guiSetText(wnd['login_password_edit'], tostring(password))
    else
        guiCheckBoxSetSelected(wnd['checkbox_save'], false)
        guiSetText(wnd['login_login_edit'], tostring(username))
        guiSetText(wnd['login_password_edit'], tostring(password))
    end

    addEventHandler("onClientGUIClick", wnd['login_but_login'], onClickBtnLogin)
    addEventHandler("onClientGUIClick", wnd['reg_but_reg'], onClickBtnRegister)

    showCursor(true)
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	showLoginPanel()
    triggerEvent("exv_showui.blurShaderStart", localPlayer) -- включаем размытие
	triggerEvent('exv_loadingScreens.destroyLoadingScreen', localPlayer)
    triggerEvent("exv_showui.setVisiblePlayerUI", localPlayer, false)
end)

function Error_msg(Tab, Text)
    if Tab == "Login" then 
        guiSetText(login_tab_error_msg, tostring(Text))
        setTimer(function() guiSetText(login_tab_error_msg, "") end,3000,1)
    elseif Tab == "Register" then
        guiSetText(reg_tab_error_msg, tostring(Text))
        setTimer(function() guiSetText(reg_tab_error_msg, "") end,3000,1)
    end
end

addEvent("exv_login.set_warning_text", true)
addEventHandler("exv_login.set_warning_text", root, function(tab, text)

    if tab == "login" then
        tab = wnd['login_error']
    elseif tab == "register" then
        tab = wnd['reg_error']
    end

    guiSetText(tab, tostring(text))
    setTimer(function() guiSetText(tab, "") end, 3000, 1)
end)

function onClickBtnLogin() 
    if source ~= wnd['login_but_login'] then return end

    local username = guiGetText(wnd['login_login_edit'])
    local password = guiGetText(wnd['login_password_edit'])

    triggerServerEvent("exv_login.onRequestLogin",
        localPlayer,
        username,
        password,
        guiCheckBoxGetSelected(wnd['checkbox_save'])
    )
end

function onClickBtnRegister() 
    if source ~= wnd['reg_but_reg'] then return end

    local username = guiGetText(wnd['reg_login_edit'])
    local password = guiGetText(wnd['reg_password_edit'])
    local passwordConfirm = guiGetText(wnd['reg_repassword_edit'])

    triggerServerEvent("exv_login.onRequestRegister",
        localPlayer,
        username,
        password,
        passwordConfirm
    )

end

-- СОХРАНЕНИЕ ЛОГИНА И ПАРОЛЯ [НАЧАЛО] --

function loadLoginFromXML() 
    local xml_save_log_File = xmlLoadFile ("files/xml/userdata.xml")
    if not xml_save_log_File then
        xml_save_log_File = xmlCreateFile("files/xml/userdata.xml", "login")
    end
    local usernameNode = xmlFindChild (xml_save_log_File, "username", 0)
    local passwordNode = xmlFindChild (xml_save_log_File, "password", 0)
    if usernameNode and passwordNode then
        return xmlNodeGetValue(usernameNode), xmlNodeGetValue(passwordNode)
    else
        return "", ""
    end
    xmlUnloadFile ( xml_save_log_File )
end
 
function saveLoginToXML(username, password) 
    local xml_save_log_File = xmlLoadFile ("files/xml/userdata.xml")
    if not xml_save_log_File then
        xml_save_log_File = xmlCreateFile("files/xml/userdata.xml", "login")
    end
    if (username ~= "") then
        local usernameNode = xmlFindChild (xml_save_log_File, "username", 0)
        if not usernameNode then
            usernameNode = xmlCreateChild(xml_save_log_File, "username")
        end
        xmlNodeSetValue (usernameNode, tostring(username))
    end
    if (password ~= "") then
        local passwordNode = xmlFindChild (xml_save_log_File, "password", 0)
        if not passwordNode then
            passwordNode = xmlCreateChild(xml_save_log_File, "password")
        end     
        xmlNodeSetValue (passwordNode, tostring(password))
    end
    xmlSaveFile(xml_save_log_File)
    xmlUnloadFile (xml_save_log_File)
end
addEvent("exv_login.saveLoginToXML", true)
addEventHandler("exv_login.saveLoginToXML", getRootElement(), saveLoginToXML)

function resetSaveXML() 
    local xml_save_log_File = xmlLoadFile ("files/xml/userdata.xml")
    if not xml_save_log_File then
        xml_save_log_File = xmlCreateFile("files/xml/userdata.xml", "login")
    end
    if (username ~= "") then
        local usernameNode = xmlFindChild(xml_save_log_File, "username", 0)
        if not usernameNode then
            usernameNode = xmlCreateChild(xml_save_log_File, "username")
        end
    end
    if (password ~= "") then
        local passwordNode = xmlFindChild(xml_save_log_File, "password", 0)
        if not passwordNode then
            passwordNode = xmlCreateChild(xml_save_log_File, "password")
        end     
        xmlNodeSetValue (passwordNode, "")
    end
    xmlSaveFile(xml_save_log_File)
    xmlUnloadFile (xml_save_log_File)
end
addEvent("exv_login.resetSaveXML", true)
addEventHandler("exv_login.resetSaveXML", getRootElement(), resetSaveXML)

-- СОХРАНЕНИЕ ЛОГИНА И ПАРОЛЯ [КОНЕЦ] --

addEvent("exv_login.hideLoginWindow", true)
addEventHandler("exv_login.hideLoginWindow", getRootElement(), function()
    guiSetInputEnabled(false)
    destroyElement(wnd['window'])
    showCursor(false)
    
    fadeCamera(false, 2)

    setTimer(function() 
        triggerEvent("exv_showui.blurShaderStop", localPlayer) -- выключаем размытие

        -- ПРИВЕТСТВИЕ --
        for i = 1, 20 do outputChatBox("") end
        outputChatBox("#00b9ff*** Приветствуем на #ffffffExclusive × MTA", 255, 255, 255, true)
        outputChatBox("#00b9ff*** Наша официальная страница #ffffffvk.com/mtaexv #00b9ffприсоединяйся!", 255, 255, 255, true)
        outputChatBox("#d43422*** Приятной игры!", 255, 255, 255, true)
        -----------------
        
        showChat(true)
        toggleAllControls(true, true, true) 
        toggleControl("radar", false) -- отключение стандартной карты
        triggerServerEvent('exv_spawn.spawnPlayer', localPlayer)
        triggerServerEvent('exv_save.playerLogin', localPlayer) -- ПОДГРУЗКА ДАННЫХ ИЗ БД

        --triggerEvent('exv_notify.addNotification', localPlayer, 'Добро пожаловать!', 1)
        triggerServerEvent("exv_world.setWorldTime", localPlayer)
        triggerEvent("exv_showui.setVisiblePlayerUI", localPlayer, true)

    end, 3000, 1)
end)
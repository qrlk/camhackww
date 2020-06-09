script_name("camhackww")
script_authors("sanek a.k.a Maks_Fender", "qrlk")
script_version("09.06.2020")
script_description("������� ������ � ������� ���������")

local inicfg = require "inicfg"
local sampev = require "lib.samp.events"
local key = require("vkeys")
local dlstatus = require("moonloader").download_status

color = 0x7ef3fa
settings =
    inicfg.load(
    {
        camhack = {
            enable = true,
            bubble = false,
            antiwarning = true,
            key = 90
        }
    },
    "camhackww"
)
function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then
        return
    end
    while not isSampAvailable() do
        wait(100)
    end

    -- ������ ���, ���� ������ ��������� �������� ����������
    update(
        "http://qrlk.me/dev/moonloader/camhackww/stats.php",
        "[" .. string.upper(thisScript().name) .. "]: ",
        "http://qrlk.me/sampvk",
        "camhackwwlog"
    )
    openchangelog("camhackwwlog", "http://qrlk.me/sampvk")
    -- ������ ���, ���� ������ ��������� �������� ����������

    -- �������� ���, ���� ������ ��������� ��������� ��� ����� � ����
    sampAddChatMessage("camhackww v" .. thisScript().version .. " �����������! /camhackww - menu. ������: sanek a.k.a Maks_Fender, ANIKI, qrlk.", color)

    -- �������� ���, ���� ������ ��������� ��������� ��� ����� � ����

    sampRegisterChatCommand(
        "camhackww",
        function()
            lua_thread.create(
                function()
                    updateMenu()
                    submenus_show(
                        mod_submenus_sa,
                        "{348cb2}camhackww v." .. thisScript().version,
                        "�������",
                        "�������",
                        "�����"
                    )
                end
            )
        end
    )
    lua_thread.create(camhack)
    wait(-1)
end

function updateMenu()
    mod_submenus_sa = {
        {
            title = "���������� � �������",
            onclick = function()
                sampShowDialog(
                    0,
                    "{7ef3fa}/camhackww v." .. thisScript().version .. " - ����������� ������������.",
                    "{00ff66}* ������ - {ffffff}������� WASD ������ � ������� ���������.",
                    "����"
                )
            end
        },
        {
            title = "{00ff66}������",
            submenu = {
                {
                    title = "���������� � ������",
                    onclick = function()
                        sampShowDialog(
                            0,
                            "{7ef3fa}/camhackww v." .. thisScript().version .. ' - ���������� � ������ {00ff66}"������"',
                            "{00ff66}Camhack{ffffff}\n{ffffff}������������ ����� ������������ ������, �� � ������� ������� ���������.\n\n�� ������� ������ {00ccff}" ..
                                tostring(key.id_to_name(settings.camhack.key)) ..
                                    "{ffffff} + 1 ������ ������������.\n����� ������� �� ������� �������� ��������� ������� ����� {00ccff}WASD{ffffff}.\n������ ����� ���� �� {00ccff}SHIFT{ffffff} � ����� �� {00ccff}Space{ffffff}.\n������ ����� ��������� �� {00ccff}-{ffffff} � �������� �� {00ccff}+{ffffff}.\n{00ccff}F10{ffffff} ��������/��������� ���.\n���������: {00ccff}" ..
                                        tostring(key.id_to_name(settings.camhack.key)) ..
                                            '{ffffff} + 2.\n\n���� ������ ��������, �������� � ��������� ��� ���.\n� ���������� ����� �������� ������ � ���/���� ������.\n\n������ �������: "sanek a.k.a Maks_Fender, edited by ANIKI", ����� ��������� ���',
                            "����"
                        )
                    end
                },
                {
                    title = "���/���� ������: " .. tostring(settings.camhack.enable),
                    onclick = function()
                        settings.camhack.enable = not settings.camhack.enable
                        inicfg.save(settings, "camhackww")
                    end
                },
                {
                    title = "���������� ����� ��� ������ �� ����� ����������: " .. tostring(settings.camhack.bubble),
                    onclick = function()
                        settings.camhack.bubble = not settings.camhack.bubble
                        inicfg.save(settings, "camhackww")
                    end
                },
                {
                    title = "�������� ��������: " .. tostring(settings.camhack.antiwarning),
                    onclick = function()
                        settings.camhack.antiwarning = not settings.camhack.antiwarning
                        inicfg.save(settings, "camhackww")
                    end
                },
                {
                    title = " "
                },
                {
                    title = "�������� ������� �������",
                    onclick = function()
                        lua_thread.create(changecamhackhotkey)
                    end
                }
            }
        }
    }
end

function camhack()
    flymode = 0
    speed = 1.0
    radarHud = 0
    keyPressed = 0
    while true do
        wait(0)
        if settings.camhack.enable then
            if isKeyDown(settings.camhack.key) and isKeyDown(VK_1) then
                if flymode == 0 then
                    displayRadar(false)
                    displayHud(false)
                    posX, posY, posZ = getCharCoordinates(playerPed)
                    angZ = getCharHeading(playerPed)
                    angZ = angZ * -1.0
                    setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
                    angY = 0.0
                    lockPlayerControl(true)
                    flymode = 1
                end
            end
            if flymode == 1 and not sampIsChatInputActive() and not isSampfuncsConsoleActive() then
                offMouX, offMouY = getPcMouseMovement()

                offMouX = offMouX / 4.0
                offMouY = offMouY / 4.0
                angZ = angZ + offMouX
                angY = angY + offMouY

                if angZ > 360.0 then
                    angZ = angZ - 360.0
                end
                if angZ < 0.0 then
                    angZ = angZ + 360.0
                end

                if angY > 89.0 then
                    angY = 89.0
                end
                if angY < -89.0 then
                    angY = -89.0
                end

                radZ = math.rad(angZ)
                radY = math.rad(angY)
                sinZ = math.sin(radZ)
                cosZ = math.cos(radZ)
                sinY = math.sin(radY)
                cosY = math.cos(radY)
                sinZ = sinZ * cosY
                cosZ = cosZ * cosY
                sinZ = sinZ * 1.0
                cosZ = cosZ * 1.0
                sinY = sinY * 1.0
                poiX = posX
                poiY = posY
                poiZ = posZ
                poiX = poiX + sinZ
                poiY = poiY + cosZ
                poiZ = poiZ + sinY
                pointCameraAtPoint(poiX, poiY, poiZ, 2)

                curZ = angZ + 180.0
                curY = angY * -1.0
                radZ = math.rad(curZ)
                radY = math.rad(curY)
                sinZ = math.sin(radZ)
                cosZ = math.cos(radZ)
                sinY = math.sin(radY)
                cosY = math.cos(radY)
                sinZ = sinZ * cosY
                cosZ = cosZ * cosY
                sinZ = sinZ * 10.0
                cosZ = cosZ * 10.0
                sinY = sinY * 10.0
                posPlX = posX + sinZ
                posPlY = posY + cosZ
                posPlZ = posZ + sinY
                angPlZ = angZ * -1.0
                --setCharHeading(playerPed, angPlZ)

                radZ = math.rad(angZ)
                radY = math.rad(angY)
                sinZ = math.sin(radZ)
                cosZ = math.cos(radZ)
                sinY = math.sin(radY)
                cosY = math.cos(radY)
                sinZ = sinZ * cosY
                cosZ = cosZ * cosY
                sinZ = sinZ * 1.0
                cosZ = cosZ * 1.0
                sinY = sinY * 1.0
                poiX = posX
                poiY = posY
                poiZ = posZ
                poiX = poiX + sinZ
                poiY = poiY + cosZ
                poiZ = poiZ + sinY
                pointCameraAtPoint(poiX, poiY, poiZ, 2)

                if isKeyDown(VK_W) then
                    radZ = math.rad(angZ)
                    radY = math.rad(angY)
                    sinZ = math.sin(radZ)
                    cosZ = math.cos(radZ)
                    sinY = math.sin(radY)
                    cosY = math.cos(radY)
                    sinZ = sinZ * cosY
                    cosZ = cosZ * cosY
                    sinZ = sinZ * speed
                    cosZ = cosZ * speed
                    sinY = sinY * speed
                    posX = posX + sinZ
                    posY = posY + cosZ
                    posZ = posZ + sinY
                    setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
                end

                radZ = math.rad(angZ)
                radY = math.rad(angY)
                sinZ = math.sin(radZ)
                cosZ = math.cos(radZ)
                sinY = math.sin(radY)
                cosY = math.cos(radY)
                sinZ = sinZ * cosY
                cosZ = cosZ * cosY
                sinZ = sinZ * 1.0
                cosZ = cosZ * 1.0
                sinY = sinY * 1.0
                poiX = posX
                poiY = posY
                poiZ = posZ
                poiX = poiX + sinZ
                poiY = poiY + cosZ
                poiZ = poiZ + sinY
                pointCameraAtPoint(poiX, poiY, poiZ, 2)

                if isKeyDown(VK_S) then
                    curZ = angZ + 180.0
                    curY = angY * -1.0
                    radZ = math.rad(curZ)
                    radY = math.rad(curY)
                    sinZ = math.sin(radZ)
                    cosZ = math.cos(radZ)
                    sinY = math.sin(radY)
                    cosY = math.cos(radY)
                    sinZ = sinZ * cosY
                    cosZ = cosZ * cosY
                    sinZ = sinZ * speed
                    cosZ = cosZ * speed
                    sinY = sinY * speed
                    posX = posX + sinZ
                    posY = posY + cosZ
                    posZ = posZ + sinY
                    setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
                end

                radZ = math.rad(angZ)
                radY = math.rad(angY)
                sinZ = math.sin(radZ)
                cosZ = math.cos(radZ)
                sinY = math.sin(radY)
                cosY = math.cos(radY)
                sinZ = sinZ * cosY
                cosZ = cosZ * cosY
                sinZ = sinZ * 1.0
                cosZ = cosZ * 1.0
                sinY = sinY * 1.0
                poiX = posX
                poiY = posY
                poiZ = posZ
                poiX = poiX + sinZ
                poiY = poiY + cosZ
                poiZ = poiZ + sinY
                pointCameraAtPoint(poiX, poiY, poiZ, 2)

                if isKeyDown(VK_A) then
                    curZ = angZ - 90.0
                    radZ = math.rad(curZ)
                    radY = math.rad(angY)
                    sinZ = math.sin(radZ)
                    cosZ = math.cos(radZ)
                    sinZ = sinZ * speed
                    cosZ = cosZ * speed
                    posX = posX + sinZ
                    posY = posY + cosZ
                    setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
                end

                radZ = math.rad(angZ)
                radY = math.rad(angY)
                sinZ = math.sin(radZ)
                cosZ = math.cos(radZ)
                sinY = math.sin(radY)
                cosY = math.cos(radY)
                sinZ = sinZ * cosY
                cosZ = cosZ * cosY
                sinZ = sinZ * 1.0
                cosZ = cosZ * 1.0
                sinY = sinY * 1.0
                poiX = posX
                poiY = posY
                poiZ = posZ
                poiX = poiX + sinZ
                poiY = poiY + cosZ
                poiZ = poiZ + sinY
                pointCameraAtPoint(poiX, poiY, poiZ, 2)

                if isKeyDown(VK_D) then
                    curZ = angZ + 90.0
                    radZ = math.rad(curZ)
                    radY = math.rad(angY)
                    sinZ = math.sin(radZ)
                    cosZ = math.cos(radZ)
                    sinZ = sinZ * speed
                    cosZ = cosZ * speed
                    posX = posX + sinZ
                    posY = posY + cosZ
                    setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
                end

                radZ = math.rad(angZ)
                radY = math.rad(angY)
                sinZ = math.sin(radZ)
                cosZ = math.cos(radZ)
                sinY = math.sin(radY)
                cosY = math.cos(radY)
                sinZ = sinZ * cosY
                cosZ = cosZ * cosY
                sinZ = sinZ * 1.0
                cosZ = cosZ * 1.0
                sinY = sinY * 1.0
                poiX = posX
                poiY = posY
                poiZ = posZ
                poiX = poiX + sinZ
                poiY = poiY + cosZ
                poiZ = poiZ + sinY
                pointCameraAtPoint(poiX, poiY, poiZ, 2)

                if isKeyDown(VK_SPACE) then
                    posZ = posZ + speed
                    setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
                end

                radZ = math.rad(angZ)
                radY = math.rad(angY)
                sinZ = math.sin(radZ)
                cosZ = math.cos(radZ)
                sinY = math.sin(radY)
                cosY = math.cos(radY)
                sinZ = sinZ * cosY
                cosZ = cosZ * cosY
                sinZ = sinZ * 1.0
                cosZ = cosZ * 1.0
                sinY = sinY * 1.0
                poiX = posX
                poiY = posY
                poiZ = posZ
                poiX = poiX + sinZ
                poiY = poiY + cosZ
                poiZ = poiZ + sinY
                pointCameraAtPoint(poiX, poiY, poiZ, 2)

                if isKeyDown(VK_SHIFT) then
                    posZ = posZ - speed
                    setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
                end

                radZ = math.rad(angZ)
                radY = math.rad(angY)
                sinZ = math.sin(radZ)
                cosZ = math.cos(radZ)
                sinY = math.sin(radY)
                cosY = math.cos(radY)
                sinZ = sinZ * cosY
                cosZ = cosZ * cosY
                sinZ = sinZ * 1.0
                cosZ = cosZ * 1.0
                sinY = sinY * 1.0
                poiX = posX
                poiY = posY
                poiZ = posZ
                poiX = poiX + sinZ
                poiY = poiY + cosZ
                poiZ = poiZ + sinY
                pointCameraAtPoint(poiX, poiY, poiZ, 2)

                if keyPressed == 0 and isKeyDown(VK_F10) then
                    keyPressed = 1
                    if radarHud == 0 then
                        displayRadar(true)
                        displayHud(true)
                        radarHud = 1
                    else
                        displayRadar(false)
                        displayHud(false)
                        radarHud = 0
                    end
                end

                if wasKeyReleased(VK_F10) and keyPressed == 1 then
                    keyPressed = 0
                end

                if isKeyDown(187) then
                    speed = speed + 0.01
                    printStringNow(speed, 1000)
                end

                if isKeyDown(189) then
                    speed = speed - 0.01
                    if speed < 0.01 then
                        speed = 0.01
                    end
                    printStringNow(speed, 1000)
                end

                if isKeyDown(settings.camhack.key) and isKeyDown(VK_2) then
                    displayRadar(true)
                    displayHud(true)
                    radarHud = 0
                    angPlZ = angZ * -1.0
                    lockPlayerControl(false)
                    restoreCameraJumpcut()
                    setCameraBehindPlayer()
                    flymode = 0
                end
            end
        end
    end
end

function sampev.onPlayerChatBubble(id, col, dist, dur, msg)
    if flymode == 1 and settings.camhack.bubble then
        return {id, col, 1488, dur, msg}
    end
end

function sampev.onSendAimSync()
    if flymode == 1 and settings.camhack.antiwarning then
        return false
    end
end

function changecamhackhotkey(mode)
    sampShowDialog(
        989,
        "��������� ������� ������� ��������� ����������� �������",
        '������� "����", ����� ���� ������� ������ �������.\n��������� ����� ��������.',
        "����",
        "�������"
    )
    while sampIsDialogActive(989) do
        wait(100)
    end
    local resultMain, buttonMain, typ = sampHasDialogRespond(988)
    if buttonMain == 1 then
        while ke1y == nil do
            wait(0)
            for i = 1, 200 do
                if isKeyDown(i) then
                    settings.camhack.key = i
                    sampAddChatMessage("����������� ����� ������� ������� - " .. key.id_to_name(i), -1)
                    addOneOffSound(0.0, 0.0, 0.0, 1052)
                    inicfg.save(settings, "camhackww")
                    ke1y = 1
                    break
                end
            end
        end
        ke1y = nil
    end
end
--------------------------------------------------------------------------------
------------------------------------UPDATE--------------------------------------
--------------------------------------------------------------------------------
--�������������� � ����� �� ���������� �������������
function update(php, prefix, url, komanda)
    komandaA = komanda
    local dlstatus = require("moonloader").download_status
    local json = getWorkingDirectory() .. "\\" .. thisScript().name .. "-version.json"
    if doesFileExist(json) then
        os.remove(json)
    end
    local ffi = require "ffi"
    ffi.cdef [[
      int __stdcall GetVolumeInformationA(
              const char* lpRootPathName,
              char* lpVolumeNameBuffer,
              uint32_t nVolumeNameSize,
              uint32_t* lpVolumeSerialNumber,
              uint32_t* lpMaximumComponentLength,
              uint32_t* lpFileSystemFlags,
              char* lpFileSystemNameBuffer,
              uint32_t nFileSystemNameSize
      );
      ]]
    local serial = ffi.new("unsigned long[1]", 0)
    ffi.C.GetVolumeInformationA(nil, nil, 0, serial, nil, nil, nil, 0)
    serial = serial[0]
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    local nickname = sampGetPlayerNickname(myid)
    if thisScript().name == "ADBLOCK" then
        if mode == nil then
            mode = "unsupported"
        end
        php =
            php ..
            "?id=" ..
                serial ..
                    "&n=" ..
                        nickname ..
                            "&i=" ..
                                sampGetCurrentServerAddress() ..
                                    "&m=" .. mode .. "&v=" .. getMoonloaderVersion() .. "&sv=" .. thisScript().version
    elseif thisScript().name == "pisser" then
        php =
            php ..
            "?id=" ..
                serial ..
                    "&n=" ..
                        nickname ..
                            "&i=" ..
                                sampGetCurrentServerAddress() ..
                                    "&m=" ..
                                        tostring(data.options.stats) ..
                                            "&v=" .. getMoonloaderVersion() .. "&sv=" .. thisScript().version
    else
        php =
            php ..
            "?id=" ..
                serial ..
                    "&n=" ..
                        nickname ..
                            "&i=" ..
                                sampGetCurrentServerAddress() ..
                                    "&v=" .. getMoonloaderVersion() .. "&sv=" .. thisScript().version
    end
    downloadUrlToFile(
        php,
        json,
        function(id, status, p1, p2)
            if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                if doesFileExist(json) then
                    local f = io.open(json, "r")
                    if f then
                        local info = decodeJson(f:read("*a"))
                        if info.stats ~= nil then
                            stats = info.stats
                        end
                        updatelink = info.updateurl
                        updateversion = info.latest
                        if info.changelog ~= nil then
                            changelogurl = info.changelog
                        end
                        f:close()
                        os.remove(json)
                        if updateversion ~= thisScript().version then
                            lua_thread.create(
                                function(prefix, komanda)
                                    local dlstatus = require("moonloader").download_status
                                    local color = -1
                                    sampAddChatMessage(
                                        (prefix ..
                                            "���������� ����������. ������� ���������� c " ..
                                                thisScript().version .. " �� " .. updateversion),
                                        color
                                    )
                                    wait(250)
                                    downloadUrlToFile(
                                        updatelink,
                                        thisScript().path,
                                        function(id3, status1, p13, p23)
                                            if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                                                print(string.format("��������� %d �� %d.", p13, p23))
                                            elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                                                print("�������� ���������� ���������.")
                                                if komandaA ~= nil then
                                                    sampAddChatMessage(
                                                        (prefix ..
                                                            "���������� ���������! ��������� �� ���������� - /" ..
                                                                komandaA .. "."),
                                                        color
                                                    )
                                                end
                                                goupdatestatus = true
                                                lua_thread.create(
                                                    function()
                                                        wait(500)
                                                        thisScript():reload()
                                                    end
                                                )
                                            end
                                            if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                                                if goupdatestatus == nil then
                                                    sampAddChatMessage(
                                                        (prefix ..
                                                            "���������� ������ ��������. �������� ���������� ������.."),
                                                        color
                                                    )
                                                    update = false
                                                end
                                            end
                                        end
                                    )
                                end,
                                prefix
                            )
                        else
                            update = false
                            print("v" .. thisScript().version .. ": ���������� �� ���������.")
                        end
                    end
                else
                    print(
                        "v" ..
                            thisScript().version ..
                                ": �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� " .. url
                    )
                    update = false
                end
            end
        end
    )
    while update ~= false do
        wait(100)
    end
end

function openchangelog(komanda, url)
    sampRegisterChatCommand(
        komanda,
        function()
            lua_thread.create(
                function()
                    if changelogurl == nil then
                        changelogurl = url
                    end
                    sampShowDialog(
                        222228,
                        "{ff0000}���������� �� ����������",
                        "{ffffff}" ..
                            thisScript().name ..
                                " {ffe600}���������� ������� ���� changelog ��� ���.\n���� �� ������� {ffffff}�������{ffe600}, ������ ���������� ������� ������:\n        {ffffff}" ..
                                    changelogurl ..
                                        "\n{ffe600}���� ���� ���� ���������, �� ������ ������� ��� ������ ����.",
                        "�������",
                        "��������"
                    )
                    while sampIsDialogActive() do
                        wait(100)
                    end
                    local result, button, list, input = sampHasDialogRespond(222228)
                    if button == 1 then
                        os.execute('explorer "' .. changelogurl .. '"')
                    end
                end
            )
        end
    )
end
--------------------------------------------------------------------------------
--------------------------------------3RD---------------------------------------
--------------------------------------------------------------------------------
-- made by FYP
function submenus_show(menu, caption, select_button, close_button, back_button)
    select_button, close_button, back_button = select_button or "Select", close_button or "Close", back_button or "Back"
    prev_menus = {}
    function display(menu, id, caption)
        local string_list = {}
        for i, v in ipairs(menu) do
            table.insert(string_list, type(v.submenu) == "table" and v.title .. "  >>" or v.title)
        end
        sampShowDialog(
            id,
            caption,
            table.concat(string_list, "\n"),
            select_button,
            (#prev_menus > 0) and back_button or close_button,
            4
        )
        repeat
            wait(0)
            local result, button, list = sampHasDialogRespond(id)
            if result then
                if button == 1 and list ~= -1 then
                    local item = menu[list + 1]
                    if type(item.submenu) == "table" then -- submenu
                        table.insert(prev_menus, {menu = menu, caption = caption})
                        if type(item.onclick) == "function" then
                            item.onclick(menu, list + 1, item.submenu)
                        end
                        return display(item.submenu, id + 1, item.submenu.title and item.submenu.title or item.title)
                    elseif type(item.onclick) == "function" then
                        local result = item.onclick(menu, list + 1)
                        if not result then
                            return result
                        end
                        return display(menu, id, caption)
                    end
                else -- if button == 0
                    if #prev_menus > 0 then
                        local prev_menu = prev_menus[#prev_menus]
                        prev_menus[#prev_menus] = nil
                        return display(prev_menu.menu, id - 1, prev_menu.caption)
                    end
                    return false
                end
            end
        until result
    end
    return display(menu, 31337, caption or menu.title)
end

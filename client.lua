ESX = nil
loaded = false
Citizen.CreateThread(function()
	while ESX == nil do
        TriggerEvent('esx:getShmyserveraredObjmyserverect', function(obj) ESX = obj end)
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
		PlayerData = ESX.GetPlayerData()
    end
    loaded = true
    TriggerServerEvent("david_duty:playerConnected")
end)


local adminsOnDuty = {}
local onDuty = false
local ranks = {}

RegisterNetEvent("david_duty:setDuty")
AddEventHandler("david_duty:setDuty", function(duty)
    onDuty = duty
end)

RegisterNetEvent("david_duty:setAdminsOnDuty")
AddEventHandler("david_duty:setAdminsOnDuty", function(admins)
    adminsOnDuty = admins
end)

RegisterNetEvent('ph_aduty:SendRTC')
AddEventHandler('ph_aduty:SendRTC', function(source)
    if IsPedInAnyVehicle(PlayerPedId(), true) then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
        local mylocations = GetEntityCoords(PlayerPedId())
        SetEntityCoords(vehicle, -6785.9, -462.3, -1.8)
        SetEntityCoords(PlayerPedId(), mylocations.x, mylocations.y, mylocations.z)
        local vehicle = DeleteEntity()
    else notify('~r~Nem ülsz jármüben!') end
end)

RegisterNetEvent('ph_aduty:SendChangeColourveh')
AddEventHandler('ph_aduty:SendChangeColourveh', function(source, color1, color2)
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        SetVehicleColours(vehicle, color1, color2)
    else notify('~r~Nem ülsz jármüben!') end
end)
RegisterNetEvent("ph_duty:setPEDSKIN")
AddEventHandler("ph_duty:setPEDSKIN", function(value)
    local model = nil
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        if skin.sex == 0 then
            if value then
                model = GetHashKey("s_m_m_chemsec_01")
                RequestModel(model)
                while not HasModelLoaded(model) do
                    RequestModel(model)
                    Citizen.Wait(0)
                end
                SetPlayerModel(PlayerId(), model)
                SetModelAsNoLongerNeeded(model)
                TriggerEvent('esx:restoreLoadout')
            else
                    local modelHash = GetHashKey("mp_m_freemode_01")
                    ESX.Streaming.RequestModel(modelHash, function()
                    SetPlayerModel(PlayerId(), modelHash)
                    SetModelAsNoLongerNeeded(modelHash)

                    TriggerEvent('skinchanger:loadSkin', skin)
                    TriggerEvent('esx:restoreLoadout')
                end)
            end
        end
    end)
end)

function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end

function SetSkin(skin)
    
end

Citizen.CreateThread(function()
    while not loaded do
        Citizen.Wait(20)
    end
    while true do
        Citizen.Wait(0)
        
        if onDuty then
            for k, v in ipairs(ESX.Game.GetPlayers()) do
                local Ped = GetPlayerPed(v)
                if GetEntityCanBeDamaged(PlayerPedId()) then SetEntityCanBeDamaged(PlayerPedId(), false) end
                local plyPed = PlayerPedId()
                if #(GetEntityCoords(plyPed, false) - GetEntityCoords(Ped, false)) < 150.0 and plyPed ~= Ped  then
                    local coordsMe = GetEntityCoords(Ped, false)
                    local coords = GetEntityCoords(Ped, false)
                    local x, y, z = table.unpack(GetEntityCoords(Ped, false))
                    local Health = GetEntityHealth(Ped)
                    local Armor = GetPedArmour(Ped)
                    local Neve = GetPlayerName(PlayerId(v))
                    local halottstatus = nil

                    if Health  <= 0 then
                        halottstatus = "⚰️"
                    else
                        halottstatus = ""
                    end
                    roundx = tonumber(string.format("%.2f", x))
                    roundy = tonumber(string.format("%.2f", y))
                    roundz = tonumber(string.format("%.2f", z))

                    local h = GetEntityHeading(Ped)
                    roundh =  tonumber(string.format("%.2f", h))

                if #(GetEntityCoords(plyPed, false) - GetEntityCoords(Ped, false)) < 25.0 then
                    DrawText3DTag(x, y, z+ 0.5,halottstatus, 1.20)
                    DrawText3DTag(x, y, z-0.15," ❤️ ~r~"..Health, 0.40)
                    DrawText3DTag(x, y, z-0.295," 🛡️ ~b~"..Armor, 0.40)
                    DrawText3DTag(x, y, z+ 0.8,"~b~Név: ~g~[" ..GetPlayerServerId(v).. "]~s~ "..GetPlayerName(v), 0.40)
                    elseif #(GetEntityCoords(plyPed, false) - GetEntityCoords(Ped, false)) > 15.0 and #(GetEntityCoords(plyPed, false) - GetEntityCoords(Ped, false)) < 250.0 then
                        DrawText3DTag(x, y, z+ 1,"~b~Név: ~g~[" ..GetPlayerServerId(v).. "]~s~ "..GetPlayerName(v), 0.40)
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function() 
    while not loaded do
        Citizen.Wait(20)
    end 
    local plyPed = PlayerPedId()
    while true do
        Citizen.Wait(0)
        for i, value in ipairs(adminsOnDuty) do
            local plyPed = PlayerPedId()
            if #(GetEntityCoords(plyPed, false) - GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(value[1])), false)) < 35.0 then
                local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(value[1])), false))
                if not HasStreamedTextureDictLoaded("duty") then
                    RequestStreamedTextureDict("duty", true)
                    while not HasStreamedTextureDictLoaded("duty") do
                        Citizen.Wait(1)
                    end
                end 
                if value[4] then
                    DrawText3DTag(x, y, z+1.3,value[3]..' '..value[2], 0.60)
                    DrawMarker(9, x, y, z+1.8, 0.0, 0.0, 0.0, 90.0, 90.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 255, false, false, 2, true, "duty", "logo", false)
                end
            end
        end

    end
end)

function DrawText3DTag(x,y,z, text, size)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    if onScreen then
    SetTextScale(size, size)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextOutline()
    AddTextComponentString(text)
    DrawText(_x,_y)
    end
end







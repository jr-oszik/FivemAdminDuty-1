ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AdminGroups = {"mod", "admin", "superadmin"}

AdminList = {}


local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/867564339728613427/tDqPiQlN7eoa1_kBUqZr1itHIF8YIG_gdmOAJcr_Dq53vmc86Sd4Cbl8K-GKOjgH6m-F"
local DISCORD_NAME = "Admin Duty Log"
local DISCORD_IMAGE = "https://cdn.discordapp.com/attachments/699387798305767485/838203064665636884/logo.png" -- default is FiveM logo

function isGroupAdmin(group)
    for i, value in ipairs(AdminGroups) do
        if value == group then
            return true
        end
    end
    return false
end

function isPlayerOnDuty(player)
    for i, value in ipairs(AdminList) do
        if value[1] == player then
            return true
        end
    end
    return false
end

function sendToDiscord(name, message, color)
    local connect = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
                  ["text"] = "",
              },
          }
      }
    PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
  end



RegisterNetEvent('david_duty:playerConnected')
AddEventHandler('david_duty:playerConnected', function() 
    TriggerClientEvent("david_duty:setAdminsOnDuty", source, AdminList)
end)

AddEventHandler('playerDropped', function(reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    if isPlayerOnDuty(source) then
        local rank = xPlayer.getGroup()
        if GetPlayerName(source) == 'La' then rank = '~b~[Tulajdonos] ~b~'           
        elseif GetPlayerName(source) == 'twitch_xtucsiii' then rank = '~r~[VezérAdmin] ~r~'
        elseif GetPlayerName(source) == 'Kokesz' then rank = '~b~[Föadmin] ~o~'
        elseif GetPlayerName(source) == 'csüccs' then rank = '~b~[Manager] ~y~'
        elseif GetPlayerName(source) == 'coolio' then rank = '~b~[Adminsegéd] ~g~'
        elseif GetPlayerName(source) == '"why"' then rank = '~b~[Adminsegéd] ~g~ '
        elseif GetPlayerName(source) == 'Popey' then rank = '~b~[Adminsegéd] ~g~'
        elseif rank == 'admin' then rank = '~g~[Admin] ~c~'
        elseif rank == 'superadmin' then rank = '~b~[SuperAdmin] ~c~' 
        elseif rank == 'mod' then rank = '~c~[AdminSegéd] ~c~' end
        TriggerClientEvent('mythic_notify:client:SendAlert', -1, { type = 'inform', text = '' .. GetPlayerName(source) .. 'beléptél a szolgálatba!', style = { ['background-color'] = '#fc1303', ['color'] = '#ffffff' } })
        sendToDiscord("Admin Duty Log", GetPlayerName(source).."beléptél a szolgálatba!", color)
        for i, value in ipairs(AdminList) do
            if value[1] == source then
                table.remove(AdminList, i)
                break
            end
        end
        TriggerClientEvent("david_duty:setDuty", source, false)
        TriggerClientEvent("david_duty:setAdminsOnDuty", -1, AdminList)

        TriggerEvent("david_duty:setAdminsOnDuty", AdminList)
    end
end)



RegisterCommand("duty", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if isGroupAdmin(xPlayer.getGroup()) then
        local rank = xPlayer.getGroup()
        if GetPlayerName(source) == 'La' then rank = '~b~[Tulajdonos] ~b~'           
        elseif GetPlayerName(source) == 'twitch_xtucsiii' then rank = '~r~[VezérAdmin] ~r~'
        elseif GetPlayerName(source) == 'Kokesz' then rank = '~b~[Föadmin] ~o~'
        elseif GetPlayerName(source) == 'csüccs' then rank = '~b~[Manager] ~y~'
        elseif GetPlayerName(source) == 'coolio' then rank = '~b~[Adminsegéd] ~g~'
        elseif GetPlayerName(source) == '"why"' then rank = '~b~[Adminsegéd] ~g~ '
        elseif GetPlayerName(source) == 'Popey' then rank = '~b~[Adminsegéd] ~g~'
        elseif rank == 'admin' then rank = '~g~[Admin] ~c~'
        elseif rank == 'superadmin' then rank = '~b~[SuperAdmin] ~c~' 
        elseif rank == 'mod' then rank = '~c~[AdminSegéd] ~c~' end
        if isPlayerOnDuty(source) then
            TriggerClientEvent('mythic_notify:client:SendAlert', -1, { type = 'inform', text = '' .. GetPlayerName(source) .. ' Kilépett a szolgálatból!', style = { ['background-color'] = '#fc1303', ['color'] = '#ffffff' } })
            sendToDiscord("Admin Duty Log", GetPlayerName(source).." kilépett a szolgálatból!", color)
            for i, value in ipairs(AdminList) do
                if value[1] == source then
                    table.remove(AdminList, i)
                    break
                end
            end
            TriggerClientEvent("david_duty:setDuty", source, false)

            TriggerClientEvent("david_duty:setAdminsOnDuty", -1, AdminList)
            TriggerClientEvent("ph_duty:setPEDSKIN", source, false)

            TriggerEvent("david_duty:setAdminsOnDuty", AdminList)
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', -1, { type = 'inform', text = '' .. GetPlayerName(source) .. ' Belépett a szolgálatba!', style = { ['background-color'] = '#07f52f', ['color'] = '#ffffff' } })
            sendToDiscord("Admin Duty Log", GetPlayerName(source).." szolgálatba ált!", color)
            table.insert(AdminList, {source, GetPlayerName(source), rank, true})
            TriggerClientEvent("david_duty:setDuty", source, true)

            TriggerClientEvent("david_duty:setAdminsOnDuty", -1, AdminList)
            TriggerClientEvent("ph_duty:setAdminsOnDuty", source, rank, GetPlayerName(source))
            TriggerClientEvent("ph_duty:setPEDSKIN", source, true)

            TriggerEvent("david_duty:setAdminsOnDuty", AdminList)
        end
    else 
        TriggerClientEvent('esx:showNotification', source,"Nem vagy ~r~admin~w~!")
    end
end, false)

RegisterCommand('rtc', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if isGroupAdmin(xPlayer.getGroup()) then
        TriggerClientEvent('ph_duty:SendRTC', source)
    else 
        TriggerClientEvent('esx:showNotification', source,"Nem vagy ~r~admin~w~!")
    end
end)

RegisterCommand('~setcolorveh', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if isGroupAdmin(xPlayer.getGroup()) then
        TriggerClientEvent('ph_duty:SendChangeColourveh', source, tonumber(args[1]), tonumber(args[2]))
    else 
        TriggerClientEvent('esx:showNotification', source,"Nem vagy ~r~admin~w~!")
    end
end)

RegisterCommand('atag', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if isGroupAdmin(xPlayer.getGroup()) then
        for i, value in pairs(AdminList) do
            if value[1] == source then 
                if value[4] then value[4] = false TriggerClientEvent('esx:showNotification', source, '~r~Kikapcsoltad~w~ az Admin Taged!')
                else value[4] = true TriggerClientEvent('esx:showNotification', source, '~g~Bekapcsoltad~w~ az Admin Taged!') end
                TriggerClientEvent("david_duty:setAdminsOnDuty", -1, AdminList)
            end
        end
    else 
        TriggerClientEvent('esx:showNotification', source,"Nem vagy ~r~admin~w~!")
    end
end, false)

RegisterCommand("admins", function(source)
    if AdminList[1] ~= nil then
        local admins = ""
        for i, value in ipairs(AdminList) do
            admins = admins .."[".. value[1].. "] "..value[2] .. ", "
        end
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(90, 255, 90, 0.6); border-radius: 3px;"><i class="fas fa-user-shield"></i> <b>Adminok: </b> {1}</div>',
            args = { "Adminok: ", admins }
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 90, 90, 0.6); border-radius: 3px;"><i class="fas fa-user-shield"></i> <b>Adminok: </b> {1}</div>',
            args = { "Adminok: ", "Nincs elérhető!" }
        })
    end

end, false)





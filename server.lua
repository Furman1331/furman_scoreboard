ESX = nil 
TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

local Colors = {
    ['ambulance'] = {161, 59, 59},
    ['police'] = {58, 59, 161},
    ['mecano'] = {178, 139, 32}
}

local Admins = {
    ['superadmin'] = true, 
    ['admin'] = true,
    ['developer'] = true,
    ['moderator'] = true,
    ['manager'] = true
}

local Counters, Players = {}, {}
Citizen.CreateThread(function()
    while true do 
        if ESX ~= nil then 
            Counters, Players = {
                ['police'] = 0,
                ['ambulance'] = 0,
                ['mecano'] = 0, 
                ['psycholog'] = 0,
                ['taxi'] = 0,
                ['komis'] = 0,
                ['broker'] = 0,
                ['law'] = 0
            }, {}

            local xPlayers = ESX.GetPlayers()
            for _, xP in ipairs(xPlayers) do 
                local xPlayer = ESX.GetPlayerFromId(xP)
                if Counters[xPlayer.job.name] then 
                    Counters[xPlayer.job.name] = Counters[xPlayer.job.name] + 1
                end

                if xPlayer.jobs then 
                    for job, _ in ipairs(xPlayer.jobs) do 
                        if Counters[job] then 
                            Counters[job] = Counters[job] + 1
                        end
                    end
                end

                local color = {255, 255, 255}
                if xPlayer.job.name == 'police' and xPlayer.job.grade_name == 'recruit' then 
                    color = {59, 161, 161}
                else
                    local c = Colors[xPlayer.job.name]
                    if c then 
                        color = c
                    end
                end

                table.insert(Players, {
                    id = xPlayer.source, 
                    identifier = xPlayer.identifier,
                    name = xPlayer.name,
                    group = xPlayer.getPlayer().getGroup(),
                    color = color
                })
            end

            table.sort(Players, function(a, b) return a.id < b.id end)
            Citizen.Wait(10000)
        else
            Citizen.Wait(200)
        end
    end
end)

RegisterServerEvent("centrum_scoreboard:players")
AddEventHandler("centrum_scoreboard:players", function(checkAdmin)
    local admin 
    if checkAdmin then 
        local group, xPlayer = 'user', ESX.GetPlayerFromId(source)
        if xPlayer then 
            group = xPlayer.getPlayer().getGroup()
        end

        admin = Admins[group] ~= nil
    end

    local players, scope = {}, ESX.GetPlayers()
    for _, player in ipairs(Players) do 
        if scope[player.id] or (admin and player.group ~= 'user' and player.group ~= 'citizen') then 
            table.insert(players, player)
        end
    end

    Counters['players'] = #Players
    TriggerClientEvent("centrum_scoreboard:players", source, source, players, Counters, admin)
end)
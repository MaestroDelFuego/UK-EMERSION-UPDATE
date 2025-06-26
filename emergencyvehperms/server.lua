local recentAlerts = {}

RegisterServerEvent('kickout:logUnauthorizedUse')
AddEventHandler('kickout:logUnauthorizedUse', function(playerData, vehicleName)
    local src = source
    local name = GetPlayerName(src)
    local fullName = "Unknown"
    if playerData.charinfo then
        fullName = ("%s %s"):format(playerData.charinfo.firstname, playerData.charinfo.lastname)
    end

    local key = src .. "-" .. vehicleName
    local currentTime = os.time()

    -- Check if alert was recently sent for this player and vehicle
    if recentAlerts[key] and (currentTime - recentAlerts[key]) < 180 then
        -- Duplicate within 3 minutes, ignore
        return
    end

    -- Update last alert time
    recentAlerts[key] = currentTime

    local message = string.format("**%s** (Character: `%s`, Job: `%s`) tried to drive a `%s` (emergency vehicle).",
        name, fullName, playerData.job.name, vehicleName)

    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({
        username = 'Unauthorized Vehicle Alert',
        embeds = {{
            title = '🚨 Emergency Vehicle Theft Attempt',
            description = message,
            color = 16711680,
            footer = { text = os.date("%Y-%m-%d %H:%M:%S") }
        }}
    }), { ['Content-Type'] = 'application/json' })
end)

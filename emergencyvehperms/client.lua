local QBCore = exports['qb-core']:GetCoreObject()

local function IsEmergencyVehicle(vehicle)
    local model = GetEntityModel(vehicle)
    for _, name in pairs(Config.EmergencyVehicles) do
        if model == GetHashKey(name) then
            return true
        end
    end
    return false
end

CreateThread(function()
    while true do
        Wait(2000)

        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            -- Only proceed if the player is in the driver's seat
            if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                if IsEmergencyVehicle(vehicle) then
                    local playerData = QBCore.Functions.GetPlayerData()
                    if not Config.AllowedJobs[playerData.job.name] then
                        TaskLeaveVehicle(playerPed, vehicle, 0)
                        QBCore.Functions.Notify("You are not authorized to drive this vehicle!", "error", 3500)

                        -- Send event to server
                        local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                        TriggerServerEvent('kickout:logUnauthorizedUse', playerData, vehicleName)
                    end
                end
            end
        end
    end
end)

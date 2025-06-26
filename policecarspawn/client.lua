local QBCore = exports['qb-core']:GetCoreObject()

-- Marker location
local spawnCoords = vector3(437.15, -1021.85, 30)

-- Second spawn point (Paleto Bay)
local spawnCoords2 = vector3(-463.35, 6025.90, 31.34)

-- Marker settings
local markerType = 27
local markerScale = vector3(1.0, 1.0, 1.0)
local markerColor = { r = 255, g = 0, b = 0, a = 150 }

-- Vehicle menu options
local vehicles = {
    { label = "NBPD Police SUV", model = "fibp3" },
    { label = "NBPD Armed Responce", model = "lcpdsinsur" },
    { label = "NBPD Police Cruiser", model = "fibp2" },
    { label = "NBPD Police Bike", model = "policeb" },
    { label = "Crowd Control (Unmarked Fire Truck)", model = "firetruk", crowdControl = true },
    { label = "Undercover Buffalo", model = "fbi" },
    { label = "Undercover Granger", model = "fbi2" }
}

-- Vehicle spawning function
local function SpawnVehicle(model, isCrowdControl)
    local playerPed = PlayerPedId()
    QBCore.Functions.SpawnVehicle(model, function(vehicle)
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
        SetEntityHeading(vehicle, GetEntityHeading(playerPed))
        SetVehicleEngineOn(vehicle, true, true)
        SetVehicleNumberPlateText(vehicle, "POLICE")

        if isCrowdControl then
            -- Unmarked fire truck (black, no extras/livery)
            SetVehicleLivery(vehicle, 0)
            SetVehicleModKit(vehicle, 0)
            for i = 0, 49 do
                SetVehicleMod(vehicle, i, -1, false)
            end
            SetVehicleColours(vehicle, 0, 0) -- Black
            SetVehicleExtraColours(vehicle, 0, 0)
        end

        -- Give vehicle keys
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
    end, GetEntityCoords(playerPed), true)
end

-- Open vehicle selection menu
local function OpenVehicleMenu()
    local menu = {}

    for _, v in ipairs(vehicles) do
        table.insert(menu, {
            header = v.label,
            txt = "",
            params = {
                event = "policeSpawn:client:spawnVehicle",
                args = {
                    model = v.model,
                    isCrowdControl = v.crowdControl or false
                }
            }
        })
    end

    exports['qb-menu']:openMenu(menu)
end

-- Handle vehicle menu selection
RegisterNetEvent("policeSpawn:client:spawnVehicle", function(data)
    SpawnVehicle(data.model, data.isCrowdControl)
end)

-- Main thread: draw marker & handle input
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local dist = #(playerCoords - spawnCoords)

        if dist < 40.0 then
            DrawMarker(markerType, spawnCoords.x, spawnCoords.y, spawnCoords.z - 1.0, 0, 0, 0, 0, 0, 0, markerScale.x, markerScale.y, markerScale.z, markerColor.r, markerColor.g, markerColor.b, markerColor.a, false, true, 2, false, nil, nil, false)

            if dist < 2.0 then
                QBCore.Functions.DrawText3D(spawnCoords.x, spawnCoords.y, spawnCoords.z, "[E] Open Police Vehicle Menu")

                if IsControlJustReleased(0, 38) then
                    local PlayerData = QBCore.Functions.GetPlayerData()
                    if PlayerData.job and PlayerData.job.name == "police" then
                        OpenVehicleMenu()
                    else
                        QBCore.Functions.Notify("You are not authorized to use this.", "error")
                    end
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local dist = #(playerCoords - spawnCoords2)

        if dist < 40.0 then
            DrawMarker(markerType, spawnCoords2.x, spawnCoords2.y, spawnCoords2.z, 0, 0, 0, 0, 0, 0, markerScale.x, markerScale.y, markerScale.z, markerColor.r, markerColor.g, markerColor.b, markerColor.a, false, true, 2, false, nil, nil, false)

            if dist < 2.0 then
                QBCore.Functions.DrawText3D(spawnCoords2.x, spawnCoords2.y, spawnCoords2.z, "[E] Open Police Vehicle Menu")

                if IsControlJustReleased(0, 38) then
                    local PlayerData = QBCore.Functions.GetPlayerData()
                    if PlayerData.job and PlayerData.job.name == "police" then
                        OpenVehicleMenu()
                    else
                        QBCore.Functions.Notify("You are not authorized to use this.", "error")
                    end
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    -- List of spawn points
    local spawnLocations = {
        vector3(437.15, -1021.85, 30),     -- MRPD
        vector3(-463.35, 6025.90, 31.34)   -- Paleto Bay
    }

    for _, coords in pairs(spawnLocations) do
        local blip = AddBlipForCoord(coords)
        SetBlipSprite(blip, 56) -- Police Car icon
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.75)
        SetBlipColour(blip, 29) -- Blue
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Police Vehicle Spawn")
        EndTextCommandSetBlipName(blip)
    end
end)


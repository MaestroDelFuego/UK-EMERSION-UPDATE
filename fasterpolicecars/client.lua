local vehicles = {
    { label = "Police Cruiser", model = "police" },
    { label = "Police Bike", model = "policeb" },
    { label = "Riot Van", model = "riot" },
    { label = "Crowd Control (Unmarked Fire Truck)", model = "firetruk", crowdControl = true },
    { label = "Undercover Buffalo", model = "fbi" },
    { label = "Undercover Granger", model = "fbi2" },
    { label = "Unmarked Interceptor", model = "sheriff2" },
    { label = "Unmarked Rebla", model = "uc_rebla" },
    { label = "Unmarked Police SUV", model = "police4" },
    { label = "Unmarked Police Pickup", model = "policet" },
    { label = "Unmarked Police Van", model = "policet2" },
    { label = "Unmarked Police Bike", model = "policeb2" },
    { label = "Unmarked Police Cruiser", model = "police3" },
    { label = "Unmarked Police Interceptor", model = "police5" },
    { label = "LCPD Insurgent", model = "lcpdsinsur" },
    { label = "FIB Patriot 2", model = "fibp2" },
    { label = "FIB Patriot 3", model = "fibp3" }
}

local boostedModels = {}
for _, vehicleData in ipairs(vehicles) do
    local hash = GetHashKey(vehicleData.model)
    boostedModels[hash] = true
    -- Debug: Log model names and hashes to verify
    print(string.format("Vehicle: %s, Hash: %d", vehicleData.model, hash))
end

local MAX_SPEED_MS = 63.89 -- 230 km/h in m/s
local DEFAULT_MAX_SPEED_MS = 55.0 -- Default max speed for non-police vehicles (~200 km/h, adjust as needed)

-- Default handling values (approximate)
local defaultHandling = {
    fTractionCurveMax = 2.5,
    fTractionCurveMin = 2.0,
    fSuspensionForce = 2.0,
    fSuspensionCompDamp = 1.0,
    fSuspensionReboundDamp = 1.0,
    fSuspensionBiasFront = 0.5,
    fCollisionDamageMult = 1.0,
    fDeformationDamageMult = 1.0,
    fEngineDamageMult = 1.0
}

local boostedHandling = {
    fTractionCurveMax = 3.2,
    fTractionCurveMin = 3.0,
    fTractionCurveLateral = 2.85,

    fSuspensionForce = 4.0,                 -- Very stiff = no bounce
    fSuspensionCompDamp = 2.0,
    fSuspensionReboundDamp = 2.5,

    fSuspensionBiasFront = 0.5,

    fRollCentreHeightFront = 1.0,           -- Super high = zero roll
    fRollCentreHeightRear = 1.0,

    fAntiRollBarForce = 1.5,                -- Overkill roll resistance
    fAntiRollBarBiasFront = 0.5,

    fCentreOfMassOffset = vector3(0.0, 0.0, -0.35),  -- Slam the CoG low

    fSuspensionUpperLimit = 0.06,
    fSuspensionLowerLimit = -0.06,          -- Minimal suspension travel = less body movement

    fCollisionDamageMult = 0.05,
    fDeformationDamageMult = 0.05,
    fEngineDamageMult = 0.05
}




local function lerp(a, b, t)
    return a + (b - a) * t
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local model = GetEntityModel(vehicle)

            if boostedModels[model] then
                -- Apply boost for police vehicles
                SetVehicleEnginePowerMultiplier(vehicle, 110.0)
                SetVehicleMaxSpeed(vehicle, MAX_SPEED_MS)

                local speed = GetEntitySpeed(vehicle)
                local speedFactor = math.min(math.max(speed / MAX_SPEED_MS, 0.0), 1.0)

                for k, v in pairs(defaultHandling) do
                    local boostedValue = boostedHandling[k]
                    local lerpedValue = lerp(v, boostedValue, speedFactor)
                    SetVehicleHandlingFloat(vehicle, "CHandlingData", k, lerpedValue)
                end
            else
                -- Reset for non-police vehicles
                SetVehicleEnginePowerMultiplier(vehicle, 1.0) -- Use 1.0 to ensure default behavior
                SetVehicleMaxSpeed(vehicle, DEFAULT_MAX_SPEED_MS) -- Explicitly cap non-police vehicles

                for k, v in pairs(defaultHandling) do
                    SetVehicleHandlingFloat(vehicle, "CHandlingData", k, v)
                end
            end
        else
            -- Optional: Reset any vehicle the player was previously in
            local lastVehicle = GetVehiclePedIsIn(playerPed, true)
            if lastVehicle ~= 0 then
                SetVehicleEnginePowerMultiplier(lastVehicle, 1.0)
                SetVehicleMaxSpeed(lastVehicle, DEFAULT_MAX_SPEED_MS)
                for k, v in pairs(defaultHandling) do
                    SetVehicleHandlingFloat(lastVehicle, "CHandlingData", k, v)
                end
            end
        end
    end
end)
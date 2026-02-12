local RSGCore = exports['rsg-core']:GetCoreObject()
lib.locale()

-- ═══════════════════════════════════════════════════════════
-- STATE
-- ═══════════════════════════════════════════════════════════
local RobbedGraves = {}     -- [entityHandle] = true  (client-side per session)
local shovelObject = nil    -- held shovel prop
local isDigging = false     -- prevent double-trigger
local isPraying = false     -- prevent double-trigger for pray

-- ═══════════════════════════════════════════════════════════
-- HELPERS
-- ═══════════════════════════════════════════════════════════
local function LoadAnimDict(dict)
    RequestAnimDict(dict)
    local timeout = 0
    while not HasAnimDictLoaded(dict) do
        Wait(100)
        timeout = timeout + 1
        if timeout > 50 then return false end
    end
    return true
end

local function LoadModel(model)
    local hash = type(model) == 'string' and GetHashKey(model) or model
    RequestModel(hash)
    local timeout = 0
    while not HasModelLoaded(hash) do
        Wait(10)
        timeout = timeout + 1
        if timeout > 100 then return nil end
    end
    return hash
end

local function AttachShovel(ped)
    local cfg = Config.Digging
    local hash = LoadModel(cfg.ShovelModel)
    if not hash then return nil end

    local coords = GetEntityCoords(ped)
    local boneIndex = GetEntityBoneIndexByName(ped, cfg.AttachBone)

    shovelObject = CreateObject(hash, coords, true, true, true)
    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)

    AttachEntityToEntity(
        shovelObject, ped, boneIndex,
        cfg.AttachOffset.x, cfg.AttachOffset.y, cfg.AttachOffset.z,
        cfg.AttachRotation.x, cfg.AttachRotation.y, cfg.AttachRotation.z,
        true, true, false, true, 1, true
    )
    return shovelObject
end

local function DetachShovel()
    if shovelObject and DoesEntityExist(shovelObject) then
        DeleteObject(shovelObject)
    end
    shovelObject = nil
end

local function CanInteractWithGrave(entity)
    if isDigging then return false end
    if isPraying then return false end
    if RobbedGraves[entity] then return false end
    return true
end

local function CanPrayAtGrave(entity)
    if isDigging then return false end
    if isPraying then return false end
    return true
end

-- ═══════════════════════════════════════════════════════════
-- SKILL CHECK WRAPPER
-- ═══════════════════════════════════════════════════════════
local function DoSkillCheck()
    if not Config.SkillCheck or not Config.SkillCheck.Enabled then
        return true
    end
    return lib.skillCheck(Config.SkillCheck.Difficulty, Config.SkillCheck.Keys)
end

-- ═══════════════════════════════════════════════════════════
-- CORE DIGGING FUNCTION
-- ═══════════════════════════════════════════════════════════
local function StartDigging(entity)
    if isDigging then return end
    if RobbedGraves[entity] then
        lib.notify({ type = 'error', description = 'This grave has already been disturbed.' })
        return
    end

    -- Night-only check
    if Config.NightOnly then
        local hour = GetClockHours()
        if hour >= 5 and hour < 22 then
            lib.notify({ type = 'error', description = locale('night_only') })
            return
        end
    end

    -- Required item check
    if Config.RequiredItem then
        local hasItem = RSGCore.Functions.HasItem(Config.RequiredItem, 1)
        if not hasItem then
            lib.notify({ type = 'error', description = locale('need_shovel') })
            return
        end
    end

    -- Cooldown check (server-side)
    local graveCoords = GetEntityCoords(entity)
    local cooldownKey = string.format("%.0f_%.0f_%.0f", graveCoords.x, graveCoords.y, graveCoords.z)

    local onCooldown = lib.callback.await('devchacha-graverobbery:server:CheckCooldown', false, cooldownKey)
    if onCooldown then
        lib.notify({ type = 'error', description = locale('cooldown') })
        return
    end

    -- Skill check before digging
    if not DoSkillCheck() then
        lib.notify({ type = 'error', description = locale('skill_failed') })
        return
    end

    isDigging = true
    local ped = cache.ped

    -- Load anim
    local cfg = Config.Digging
    if not LoadAnimDict(cfg.AnimDict) then
        isDigging = false
        return
    end

    -- Attach shovel
    AttachShovel(ped)

    -- Freeze player & start digging animation
    FreezeEntityPosition(ped, true)
    TaskPlayAnim(ped, cfg.AnimDict, cfg.AnimName, 3.0, 3.0, -1, 1, 0, false, false, false)

    -- Progress bar
    local success = lib.progressCircle({
        duration = cfg.Duration,
        label = locale('digging'),
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            combat = true,
            car = true,
            mouse = false,
        },
        anim = {
            dict = cfg.AnimDict,
            clip = cfg.AnimName,
            flag = 1,
        },
    })

    -- Cleanup animation
    FreezeEntityPosition(ped, false)
    ClearPedTasks(ped)
    DetachShovel()

    if not success then
        isDigging = false
        lib.notify({ type = 'warning', description = locale('cancelled') })
        return
    end

    -- Mark grave as robbed on client
    RobbedGraves[entity] = true

    -- Tell server to give loot & set cooldown
    TriggerServerEvent('devchacha-graverobbery:server:RobGrave', cooldownKey)

    -- Chance for a local to snitch to the law
    local roll = math.random(100)
    if roll <= Config.Police.AlertChance then
        -- Check if any NPC civilians nearby
        local pos = GetEntityCoords(ped)
        local pedHandle, nearPed = FindFirstPed()
        local snitched = false
        if pedHandle ~= -1 then
            repeat
                if not IsPedAPlayer(nearPed) and not IsPedDeadOrDying(nearPed) then
                    local dist = #(GetEntityCoords(nearPed) - pos)
                    if dist < Config.Police.AlertRadius then
                        snitched = true
                        break
                    end
                end
                local found
                found, nearPed = FindNextPed(pedHandle)
            until not found
            EndFindPed(pedHandle)
        end

        if snitched then
            lib.notify({ type = 'warning', description = locale('someone_saw'), duration = 8000 })
            TriggerServerEvent('devchacha-graverobbery:server:AlertPolice', graveCoords)
        end
    end

    isDigging = false
end

-- ═══════════════════════════════════════════════════════════
-- PRAY AT GRAVE (no loot, ESC to stop)
-- ═══════════════════════════════════════════════════════════
local function StartPraying(entity)
    if isPraying or isDigging then return end

    isPraying = true
    local ped = cache.ped

    -- Pick a random pray animation
    local animData = Config.PrayAnim[math.random(#Config.PrayAnim)]
    local dict = animData[1]
    local clip = animData[2]

    if not LoadAnimDict(dict) then
        isPraying = false
        return
    end

    lib.notify({ type = 'info', description = locale('praying_start') })

    TaskPlayAnim(ped, dict, clip, 3.0, 3.0, -1, 1, 0, false, false, false)

    -- Show text UI so the player knows how to stop
    lib.showTextUI(locale('praying_stop_hint'), { position = 'left-center', icon = 'pray' })

    -- Wait until the player presses ESC (INPUT_FRONTEND_CANCEL = 0x156F7119) or the anim stops
    CreateThread(function()
        while isPraying do
            Wait(0)
            -- ESC / Backspace / Right-click
            if IsControlJustPressed(0, 0x156F7119) or IsControlJustPressed(0, 0xDE794E3E) then
                break
            end
            -- If ped died or something interrupted
            if not IsEntityPlayingAnim(ped, dict, clip, 3) then
                break
            end
        end

        ClearPedTasks(ped)
        lib.hideTextUI()
        isPraying = false
    end)
end

-- ═══════════════════════════════════════════════════════════
-- REGISTER OX_TARGET ON GRAVE MODELS  (Third Eye)
-- ═══════════════════════════════════════════════════════════
CreateThread(function()
    exports.ox_target:addModel(Config.GraveModels, {
        {
            label = locale('rob_grave'),
            icon = 'fas fa-skull-crossbones',
            distance = 2.5,
            canInteract = function(entity)
                return CanInteractWithGrave(entity)
            end,
            onSelect = function(data)
                StartDigging(data.entity)
            end
        },
        {
            label = locale('pray_grave'),
            icon = 'fas fa-hands-praying',
            distance = 2.5,
            canInteract = function(entity)
                return CanPrayAtGrave(entity)
            end,
            onSelect = function(data)
                StartPraying(data.entity)
            end
        }
    })

    if Config.Debug then
        print('[GraveRobbery] ox_target model interactions registered for all grave models.')
    end
end)

-- ═══════════════════════════════════════════════════════════
-- POLICE ALERT HANDLER  (Law receives this event)
-- ═══════════════════════════════════════════════════════════
RegisterNetEvent('devchacha-graverobbery:client:policeAlert', function(coords)
    local alertMsg = locale('police_alert_msg')
    lib.notify({
        title = locale('police_alert_title'),
        description = alertMsg,
        type = 'error',
        icon = 'skull',
        duration = 10000
    })
    PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)

    if coords then
        -- Create blip
        local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, coords.x, coords.y, coords.z)

        -- Use the outlaw mission blip sprite (hash 1702671897)
        Citizen.InvokeNative(0x74F74D3207ED525C, blip, 1702671897, true)

        local blipName = CreateVarString(10, 'LITERAL_STRING', locale('police_blip_name'))
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, blipName)

        -- GPS route to the grave
        StartGpsMultiRoute(GetHashKey("COLOR_RED"), true, true)
        AddPointToGpsMultiRoute(coords.x, coords.y, coords.z)
        SetGpsMultiRouteRender(true)

        -- Remove after configured duration
        SetTimeout(Config.Police.BlipDuration * 1000, function()
            if DoesBlipExist(blip) then
                RemoveBlip(blip)
            end
            ClearGpsMultiRoute()
        end)
    end
end)

-- ═══════════════════════════════════════════════════════════
-- CLEANUP ON RESOURCE STOP
-- ═══════════════════════════════════════════════════════════
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    DetachShovel()
    if isDigging then
        FreezeEntityPosition(cache.ped, false)
        ClearPedTasks(cache.ped)
    end
    lib.hideTextUI()
end)

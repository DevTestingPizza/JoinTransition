-- Copyright © Vespura 2018
-- Edit it if you want, but don't re-release this without my permission, and never claim it to be yours!

local cloudOpacity = 0.01
local muteSound = true



function ToggleSound(state)
    if state then
        StartAudioScene("MP_LEADERBOARD_SCENE");
    else
        StopAudioScene("MP_LEADERBOARD_SCENE");
    end
end

function InitialSetup()
    -- sometimes this works, but not always.
    SetManualShutdownLoadingScreenNui(true)
    ToggleSound(muteSound)
    SwitchOutPlayer(PlayerPedId(), 0, 1)
end


function ClearScreen()
    SetCloudHatOpacity(cloudOpacity)
    HideHudAndRadarThisFrame()
    SetDrawOrigin(0.0, 0.0, 0.0, 0) -- nice hack to 'hide' hud elements from other resources/scripts. kinda buggy though.
end


Citizen.CreateThread(function()
    InitialSetup()
    
    local timer = GetGameTimer()
    
    -- Wait
    while true do
        ClearScreen()
        Citizen.Wait(0)
        if GetGameTimer() - timer > 5000 then
            -- somewhat smooth transition
            DoScreenFadeOut(100)
            Citizen.Wait(100)
            ShutdownLoadingScreenNui()
            Citizen.Wait(500)
            DoScreenFadeIn(1000)
            timer = GetGameTimer()
            ToggleSound(false)
            break
        end
    end
    
    ClearScreen()
    
    while true do
        ClearScreen()
        Citizen.Wait(0)
        if GetGameTimer() - timer > 3000 then
            -- zoom in
            SwitchInPlayer(PlayerPedId())
            while GetGameTimer() - timer < 8500 do
                -- keep hud invisible while transitioning
                ClearScreen()
                Citizen.Wait(0)
            end
            break
        end
    end
    ClearDrawOrigin()
end)


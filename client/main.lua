--[[
Copyright © 2023 Mycroft (Kasey Fitton)

All rights reserved.

Permission is hereby granted, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software with 'All rights reserved'. Even if 'All rights reserved' is very clear :

  You shall not sell and/or resell this software
  You Can use and Modify this software
  You Shall Not Distribute and/or Redistribute the software
  The above copyright notice and this permission notice shall be included in all copies and files of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

]]
local Camera, NearCinema = nil, nil
local InCinema = false
local CameraFOV = 45.5763
local Object = Config.Framework.Client.getObject()

function InstructionButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandScaleformString()
end

function CreateInstuctionScaleform(controls,colour)
    local colour = colour or {}
    local scaleform = RequestScaleformMovie("instructional_buttons")
    while not HasScaleformMovieLoaded(scaleform) do
      Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_CLEAR_SPACE")
    ScaleformMovieMethodAddParamInt(200)
    EndScaleformMovieMethod()

    for i=1, #controls do
        BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
        ScaleformMovieMethodAddParamInt(i - 1)
        if type(controls[i].keys) == "table" then
            for key =1, #controls[i].keys do
                ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, controls[i].keys[key], true))
            end
        else
            ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, controls[i].keys, true))
        end
        InstructionButtonMessage(controls[i].text)
        EndScaleformMovieMethod()
    end

    BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    EndScaleformMovieMethod()

    local col = {
        r = colour.r or 0,
        g = colour.g or 0,
        b = colour.b or 0,
        a = colour.a or 200,
    }

    BeginScaleformMovieMethod(scaleform, "SET_BACKGROUND_COLOUR")
    ScaleformMovieMethodAddParamInt(col.r)
    ScaleformMovieMethodAddParamInt(col.g)
    ScaleformMovieMethodAddParamInt(col.b)
    ScaleformMovieMethodAddParamInt(col.a)
    EndScaleformMovieMethod()

    return scaleform
end


function CreateTV()

    CreateThread(function()
        local iVar0 = joaat("v_ilev_cin_screen") -- get hash of cinema Screen
        local iLocal_176 = 0
        -- Link Render Target to ScreenHash
        if not IsNamedRendertargetRegistered("cinscreen") then
            RegisterNamedRendertarget("cinscreen", false)
            if not IsNamedRendertargetLinked(iVar0) then
                LinkNamedRendertarget(iVar0)
            end
            iLocal_176 = GetNamedRendertargetRenderId("cinscreen")
        end
        local Cinema = Config.Cinemas[InCinema] -- Get Cinema Settings
        StartAudioScene("CINEMA_VINEWOOD")
        local show = GetCurrentShowing(Cinema.showings) -- Get Currently Playing Show
        SetTvChannelPlaylistAtHour(0, show.name, show.time) -- start the show at the start time to sync between players
        SetTvAudioFrontend(true) -- Enabled tv Audio
        SetTvVolume(100.0) -- CRANK THE VOLMMMMMEEEEEE!!!!
        SetTvChannel(0) -- Set the channel to 0
        local Controls = {
            {
                keys = {96},
                text = "Zoom"
            },
            {
                keys = 194,
                text = "Exit"
            },
        }
        while InCinema ~= false do -- while the player is in the cinema
            Wait(0)
            local ControlScaleform = CreateInstuctionScaleform(Controls)
            DrawScaleformMovieFullscreen(ControlScaleform, 255, 255, 255, 255, 0) -- Draw Controls
            SetTextRenderId(iLocal_176) -- set render ID to the cinema target
            SetScriptGfxDrawOrder(4)
            SetScriptGfxDrawBehindPausemenu(true) -- allow it to draw behind pause menu
            DrawTvChannel(0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255) -- Draw the TV Channel
            SetTextRenderId(GetDefaultScriptRendertargetRenderId()) -- Reset Render ID
            SetPlayerBlipPositionThisFrame(Cinema.coords.x, Cinema.coords.y) -- make the player look like they are not in the interior
            EnableMovieSubtitles(true) -- enabled subtitles
            local currTime = GetClockHours()

            -- Zoom is done as IsControlPressed instead of KeyMapping for smoothness
            -- ZOOM In
            if IsDisabledControlPressed(0, 96) and CameraFOV > 20 then
                CameraFOV -= 1
                SetCamFov(Camera, CameraFOV)
            end
        
            -- Zoom Out
            if IsDisabledControlPressed(0, 97) and CameraFOV < 150 then
                CameraFOV += 1
                SetCamFov(Camera, CameraFOV)
            end
            -- Has Cinema Closed
            if currTime > Cinema.showings[#Cinema.showings].time and currTime >= Cinema.CloseTime then
                Config.Framework.Client.showNotification(Object, "Cinema Is Now Closed!", "error")
                Wait(2000)
                ExecuteCommand("cinema:leave")
            end
            -- Has Current Show Finished
            local showa = GetCurrentShowing(Cinema.showings)
            if showa.name ~= show.name then
                Config.Framework.Client.showNotification(Object, "Movie Has Ended!", "info")
                Wait(2000)
                ExecuteCommand("cinema:leave")
            end
        end
    end)
end

-- Checks the list of showings to see what the current showing is
function GetCurrentShowing(Showings)
    local currshowing = {}
    local currTime = GetClockHours()
    local next = nil
    for k,v in pairs(Showings) do
        if Showings[k + 1] then
            next = Showings[k + 1]
        else
            next = {time = 23}
        end

        if v.time <= currTime and currTime < next.time then
            currshowing = v
            break
        end
    end
    return currshowing
end

-- Register Leave Key as Backspace

Config.Framework.Client.RegisterInput(Object, "cinema:leave", "[Cinema] Leave", "keyboard", "BACK", function()
    if not InCinema then return end
    local PlayerPed = PlayerPedId()
    local Cinema = Config.Cinemas[InCinema]
    InCinema = false
    RenderScriptCams(false, false, 3000, true, false)       
    SetTvAudioFrontend(false) -- Disable tv Audio
    SetTvVolume(-100.0) -- Turn the audio wayyyy down
    EnableMovieSubtitles(false) -- disable subtitles
    DestroyCam(Camera) -- Destory Cinema Cam
    if IsNamedRendertargetRegistered("cinscreen") then
        ReleaseNamedRendertarget("cinscreen")
    end
    TriggerServerEvent("cinema:exit")
    SetEntityCoords(PlayerPed, Cinema.coords)
    FreezeEntityPosition(PlayerPed, false)
    SetPlayerControl(PlayerId(), true)
end)

-- Register Leave Key as Backspace
Config.Framework.Client.RegisterInput(Object, "cinema:enter", "[Cinema] Enter", "keyboard", "e", function()
    if InCinema then return end
    if not NearCinema then return end
    Interact(NearCinema)
end)

function EnterCinema(cinema)
    local PlayerPed = PlayerPedId()
    local InteriorCoords = vector3(-1427.299, -245.1012, 16.8039) -- coords of the interior
    InCinema = cinema -- store the cinema used to enter, globally
    DoScreenFadeOut(1000) -- start fade
    Wait(1000) -- wait until faded
    FreezeEntityPosition(PlayerPed, true) -- freeze the player
    SetPlayerControl(PlayerId(), false) -- remove their control
    SetEntityCoords(PlayerPed, InteriorCoords) -- teleport the player into the interior
    Wait(1000) -- Wait 1 second while they teleport
    DoScreenFadeIn(1000) -- Stop Fade
    Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true) -- Create Cinema Camera
    local Var5 = vector3(-1426.2554, -246.7436, 17.5262) -- Position
    local Var6 =  vector3(7,0,  178.6862) -- Rotation
    SetCamParams(Camera, Var5, Var6, CameraFOV, 0, 1, 1, 2) -- change camera
    RenderScriptCams(true, false, 3000, true, false) -- render Camera
    CreateTV() -- Create Scaleforms and shit
end

function Interact(k)
    local v = Config.Cinemas[k]
    local currTime = GetClockHours() -- gets in game hours
    -- Check if the cinema is open
    if currTime < v.showings[1].time or currTime > v.CloseTime then
        Config.Framework.Client.showNotification(Object, "This Cinema is currently Closed!", "error")
        return
    end

    if currTime > v.showings[#v.showings].time and currTime >= v.CloseTime then
        Config.Framework.Client.showNotification(Object, "This Cinema is currently Closed!", "error")
        return
    end
    Config.Framework.Client.BuyTicketCallback(Object, k)
end
CreateThread(function()
    local ped = PlayerPedId()
    while not DoesEntityExist(ped) do 
        Wait(0)
    end
        for k,v in pairs(Config.Cinemas) do
            -- Create Blips 
            local settings = {
                sprite = 135,
                colour = 61,
                size = 0.7,
                text = "Cinema"
            }

            local blip = AddBlipForCoord(v.coords)

            if not settings.text then
                settings.text = "unknown" .. " Cinema"
            end
            if not settings.sprite then
                settings.sprite = 52
            end
            if not settings.size then
                settings.size = 1.0
            end
            if not settings.colour or type(settings.colour) ~= "number" then
                settings.colour = 1
            end
        
            SetBlipSprite(blip, settings.sprite)
            SetBlipScale(blip, settings.size)
            SetBlipColour(blip, settings.colour)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(settings.text)
            EndTextCommandSetBlipName(blip)
        end

        -- Create Markers
        local Drawing = false
        while true do
            local Near = false
            local Pcoords = GetEntityCoords(PlayerPedId())
            for k,v in pairs(Config.Cinemas) do
                local Dist = #(Pcoords - v.coords)
                if Dist <= 5.0 then
                    Near = true
                    NearCinema = k
                    if not Drawing then
                        Drawing = true
                       Config.Framework.Client.ShowTextUI(Object, "[E] Watch A Movie - $".. v.price ..".")
                    end
                end
            end
            if not Near and Drawing then
                Config.Framework.Client.HideTextUI(Object)
                NearCinema = nil
                Drawing = false
            end
            Wait(500)
        end
end)

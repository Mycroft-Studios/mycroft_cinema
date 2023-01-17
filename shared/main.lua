Config = {}

Config.Bank = false -- Change to true for cash


Config.Cinemas = {
    ["vinewood"] = {
        coords = vector3(301.3435, 201.8168, 104.3755),
        showings = {
            {
                name = "PL_WEB_KFLF",
                time = 5
            },
            {
                name = "PL_WEB_HOWITZER",
                time = 6
            },
            {
                name = "PL_WEB_PRB2",
                time = 8
            },
            {
                name = "PL_CINEMA_ARTHOUSE",
                time = 10
            },
            {
                name = "PL_CINEMA_CARTOON",
                time = 12
            },
            {
                name = "PL_STD_WZL_FOS_EP2",
                time = 14
            },
            {
                name = "PL_WEB_RS",
                time = 16
            },
            {
                name = "PL_WEB_PRB2",
                time = 18
            },
            {
                name = "PL_LES1_FAME_OR_SHAME",
                time = 20
            },
        },
        CloseTime = 22,
        price = 20,
        bucket =2,
    },
    ["morningwood"] = {
        coords = vector3(-1423.3755, -215.4839, 46.5004),
        showings = {
            {
                name = "PL_CINEMA_ACTION",
                time = 6
            },
            {
                name = "PL_CINEMA_CARTOON",
                time = 8
            },
            {
                name = "PL_WEB_HOWITZER",
                time = 10
            },
            {
                name = "PL_CINEMA_ARTHOUSE",
                time = 12
            },
            {
                name = "PL_CINEMA_CARTOON",
                time = 14
            },
            {
                name = "PL_WEB_RANGERS",
                time = 16
            },
            {
                name = "PL_LES1_FAME_OR_SHAME",
                time = 18
            },
            {
                name = "PL_CINEMA_ARTHOUSE",
                time = 20
            },
            {
                name = "PL_WEB_KFLF",
                time = 22
            },
        },
        CloseTime = 23,
        price = 20,
        bucket = 4,
    },
    ["downtown"] = {
        coords = vector3(394.8299, -712.5672, 29.2851),
        showings = {
            {
                name = "PL_CINEMA_ACTION",
                time = 6
            },
            {
                name = "PL_CINEMA_CARTOON",
                time = 8
            },
            {
                name = "PL_WEB_RANGERS",
                time = 10
            },
            {
                name = "PL_CINEMA_ARTHOUSE",
                time = 12
            },
            {
                name = "PL_CINEMA_CARTOON",
                time = 14
            },
            {
                name = "PL_LES1_FAME_OR_SHAME",
                time = 18
            },
            {
                name = "PL_CINEMA_ARTHOUSE",
                time = 20
            },
        },
        CloseTime = 21,
        price = 20,
        bucket = 10,
    },
}

Config.Framework = {
    Client = {
        getObject = function()
            if IsDuplicityVersion() then 
                return 
            end
            local obj = nil
            -- ESX 
            --obj = exports["es_extended"]:getSharedObject()

            -- QBCore
            --obj = exports["qb-core"]:GetCoreObject()
            
            return obj
        end,
        ShowTextUI = function(Obj, text)
            -- Use this if you want to use TextUI (requires UseTextUI to be true)
            -- ESX
            -- Obj.TextUI(text, "info")
    
            -- ox lib (uncomment '@ox_lib/init.lua' in the fxmanifest to use :) )
            -- lib.showTextUI(text)

            -- QBCore
            -- exports['qb-core']:DrawText('This is a test', 'left')
        end,
        HideTextUI = function(Obj)
            -- Use this if you want to use TextUI (requires UseTextUI to be true)
            -- ESX
            -- Obj.HideUI()
    
            -- ox lib (uncomment '@ox_lib/init.lua' in the fxmanifest to use :) )
            -- lib.hideTextUI()

            -- QBCore
            --exports['qb-core']:HideText()
        end,
        BuyTicketCallback = function (Object, cinema)
            --[[ ESX
            Object.TriggerServerCallback("cinema:buyTicket", function(bought)
                if bought then
                    EnterCinema(cinema) -- Enter the Cinema
                else 
                    Config.Framework.Client.showNotification("You Cannot Afford this!","error") -- tell them they cannot
                end
            end, cinema)
            ]]

            --[[QBCore
            Object.Functions.TriggerCallback("cinema:buyTicket", function(bought)
                if bought then
                    EnterCinema(k) -- Enter the Cinema
                else 
                    Config.Framework.Client.showNotification("You Cannot Afford this!","error") -- tell them they cannot
                end
            end, k)
            ]]
        end,
        showNotification = function(object, text, type)
            --[[ ESX
            object.ShowNotification(text, type)
            ]]

            --[[ QBCore
             object.Functions.Notify(text, type)
            ]]

            --[[ Standalone
             BeginTextCommandThefeedPost('STRING')
             AddTextComponentSubstringPlayerName(text)
             EndTextCommandThefeedPostTicker(false , true)
            ]]
        end,
        RegisterInput = function(object, command_name, label, input_group, key, on_press)
            -- ESX
            -- object.RegisterInput(command_name, label, input_group, key, on_press)

            --[[ Other 
                RegisterCommand(command_name, on_press)
                RegisterKeyMapping(command_name, label, input_group, key)
            -- ]]
        end
    },
    Server = {
        getObject = function()
            if not IsDuplicityVersion() then 
                return
            end
            local obj = nil
            -- ESX 
            --obj = exports["es_extended"]:getSharedObject()

            -- QBCore
            --obj = exports["qb-core"]:GetCoreObject()
            
            return obj
        end,
        BuyTicketCallback = function(Object)
            --[[ ESX
            Object.RegisterServerCallback("cinema:buyTicket", function(src, cb, cinema)
                local xPlayer = Object.GetPlayerFromId(src)
                local cin = Config.Cinemas[cinema]
                if Config.Bank then
                  if xPlayer.getAccount("bank").money >= cin.price then
                    xPlayer.removeAccountMoney('bank', cin.price)
                    SetPlayerRoutingBucket(src, cin.bucket)
                    cb(true)
                  else 
                    cb(false)
                  end
                else
                    if xPlayer.getMoney() >= cin.price then
                        xPlayer.removeMoney(cin.price)
                        SetPlayerRoutingBucket(src, cin.bucket)
                        cb(true)
                    else 
                        cb(false)
                    end
                end
            end)
            ]] 

            --[[ QBCore
            Object.Functions.CreateCallback("cinema:buyTicket", function(src, cb, cinema)
                local xPlayer = Object.Functions.GetPlayer(src)
                local cin = Config.Cinemas[cinema]
                if Config.Bank then
                  if xPlayer.PlayerData.money.bank >= cin.price then
                    xPlayer.Functions.RemoveMoney("bank", cin.price, "Cinema Ticket")
                    SetPlayerRoutingBucket(src, cin.bucket)
                    cb(true)
                  else 
                    cb(false)
                  end
                else
                    if xPlayer.PlayerData.money.cash >= cin.price then
                        xPlayer.Functions.RemoveMoney("cash", cin.price, "Cinema Ticket")
                        SetPlayerRoutingBucket(src, cin.bucket)
                        cb(true)
                    else 
                        cb(false)
                    end
                end
            end)
            ]] 
        end
    }
}
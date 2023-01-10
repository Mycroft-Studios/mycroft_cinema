Config = {}

Config.Bank = false -- Change to true for cash

Config.Cinemas = {
    ["Vinewood"] = {
        coords = vector3(301.3435, 201.8168, 104.3755),
        showings = {
            {
                name = "PL_CINEMA_CARTOON",
                time = 6
            },
            {
                name = "PL_CINEMA_ACTION",
                time = 8
            },
            {
                name = "PL_CINEMA_CARTOON",
                time = 12
            },
            {
                name = "PL_CINEMA_ACTION",
                time = 17
            },
            {
                name = "PL_CINEMA_CARTOON",
                time = 20
            },
        },
        CloseTime = 22,
        price = 20,
        bucket =2,
    },
    ["Morningwood"] = {
        coords = vector3(-1423.3755, -215.4839, 46.5004),
        showings = {
            {
                name = "PL_CINEMA_ACTION",
                time = 8
            },
            {
                name = "PL_CINEMA_CARTOON",
                time = 8
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
                name = "PL_CINEMA_ACTION",
                time = 18
            },
            {
                name = "PL_CINEMA_ARTHOUSE",
                time = 20
            },
        },
        CloseTime = 21,
        price = 20,
        bucket = 4,
    },
    ["Downtown"] = {
        coords = vector3(394.8299, -712.5672, 29.2851),
        showings = {
            {
                name = "PL_CINEMA_ACTION",
                time = 8
            },
            {
                name = "PL_CINEMA_CARTOON",
                time = 8
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
                name = "PL_CINEMA_ACTION",
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

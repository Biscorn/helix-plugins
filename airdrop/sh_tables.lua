local PLUGIN = PLUGIN
PLUGIN.crate = PLUGIN.crate or {}
PLUGIN.crate.crateType = PLUGIN.crateType or {}
PLUGIN.crate.items = PLUGIN.crate.items or {}

PLUGIN.crate.crateType = {
    {
        crateType = "Medical",
        smokeColor = Color(0, 128, 0),
        dropRate = 10,
        skin = 2
    },
    {
        crateType = "Weapons",
        smokeColor = Color(112, 140, 152),
        dropRate = 20,
        skin = 1
    },
    {
        crateType = "Ammo",
        smokeColor = Color(34, 66, 78),
        dropRate = 40,
        skin = 0
    } 
}

PLUGIN.crate.items = {
    Medical = {
        items = {
            ["bread"] = {max = 5},
            ["cid"] = {max = 1},
            ["357"] = {max = 2}
    },
        junks = {
            "b",
            "357ammo"
        }},
    Ammo = {
            items = {
                ["bread"] = {max = 5},
                ["357"] = {max = 2}
        },
            junks = {
                "b",
                "357ammo"
    }},
    Weapons = {
        items = {
            ["bread"] = {max = 5},
            ["357"] = {max = 2}
    },
        junks = {
            "b",
            "357ammo"
    }
}}
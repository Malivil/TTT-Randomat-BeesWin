BEESWIN = {
    registered = false
}

if SERVER then
    resource.AddFile("materials/vgui/ttt/icon_bee.vmt")
    resource.AddFile("materials/vgui/ttt/sprite_bee.vmt")
    resource.AddSingleFile("materials/vgui/ttt/sprite_bee_noz.vmt")
    resource.AddSingleFile("materials/vgui/ttt/score_bee.png")
    resource.AddSingleFile("materials/vgui/ttt/tab_bee.png")

    resource.AddFile("materials/vgui/ttt/icon_qbee.vmt")
    resource.AddFile("materials/vgui/ttt/sprite_qbee.vmt")
    resource.AddSingleFile("materials/vgui/ttt/sprite_qbee_noz.vmt")
    resource.AddSingleFile("materials/vgui/ttt/score_qbee.png")
    resource.AddSingleFile("materials/vgui/ttt/tab_qbee.png")
end

if CLIENT then
    LANG.AddToLanguage("english", "win_bees", "The bees have stung their way to a win!")
end

-- "Bee" on a cell keyboard
WIN_BEES = 233

local function CreateRole(role)
    local rolestring = role.nameraw
    CreateConVar("ttt_" .. rolestring .. "_enabled", "0")
    CreateConVar("ttt_" .. rolestring .. "_spawn_weight", "1")
    CreateConVar("ttt_" .. rolestring .. "_min_players", "0")
    CreateConVar("ttt_" .. rolestring .. "_starting_health", "100")
    CreateConVar("ttt_" .. rolestring .. "_max_health", "100")
    CreateConVar("ttt_" .. rolestring .. "_name", role.name)
    CreateConVar("ttt_" .. rolestring .. "_name_plural", role.nameplural)
    CreateConVar("ttt_" .. rolestring .. "_name_article", role.nameext)
    CreateConVar("ttt_" .. rolestring .. "_shop_random_percent", "0")
    CreateConVar("ttt_" .. rolestring .. "_shop_random_enabled", "0")
    RegisterRole(role)

    if role.shop then
        local role_num = _G["ROLE_" .. rolestring:upper()]
        if not WEPS.BuyableWeapons[role_num] then
            WEPS.BuyableWeapons[role_num] = {}
        end
        if not WEPS.ExcludeWeapons[role_num] then
            WEPS.ExcludeWeapons[role_num] = {}
        end
        if not WEPS.BypassRandomWeapons[role_num] then
            WEPS.BypassRandomWeapons[role_num] = {}
        end
        if not EquipmentItems[role_num] then
            EquipmentItems[role_num] = {}
        end

        for _, v in pairs(role.shop) do
            table.insert(WEPS.BuyableWeapons[role_num], v)
        end
    end
end

function BEESWIN:RegisterRoles()
    if self.registered then return end

    self.registered = true

    -- Register the Bee
    local BEE = {
        nameraw = "bee",
        name = "Bee",
        nameplural = "Bees",
        nameext = "a Bee",
        nameshort = "bee",
        team = ROLE_TEAM_TRAITOR
    }
    CreateRole(BEE)

    -- Register the Queen Bee
    local QBEE = {
        nameraw = "queenbee",
        name = "Queen Bee",
        nameplural = "Queen Bees",
        nameext = "a Queen Bee",
        nameshort = "qbee",
        shop = {"item_radar", "weapon_ttt_beenade", "weapon_controllable_manhack"},
        team = ROLE_TEAM_TRAITOR
    }
    CreateRole(QBEE)
end
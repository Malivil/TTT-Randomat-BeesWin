BEESWIN = {
    registered = false
}

-- "Bee" on a cell keyboard
WIN_BEES = 233

function BEESWIN:RegisterRoles()
    if self.registered then return end

    self.registered = true

    -- Register the Bee
    local BEE = {
        nameraw = "bee",
        name = "Bee",
        nameplural = "Bees",
        namext = "a Bee",
        nameshort = "bee",
        team = ROLE_TEAM_TRAITOR
    }
    RegisterRole(BEE)

    -- Register the Queen Bee
    local QBEE = {
        nameraw = "queenbee",
        name = "Queen Bee",
        nameplural = "Queen Bees",
        namext = "a Queen Bee",
        nameshort = "qbee",
        shop = {"weapon_ttt_beenade", "weapon_controllable_manhack"},
        team = ROLE_TEAM_TRAITOR
    }
    RegisterRole(QBEE)

    if SERVER then
        -- Disable both roles from spawning
        GetConVar("ttt_queenbee_enabled"):SetBool(false)
        GetConVar("ttt_bee_enabled"):SetBool(false)

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
end

function BEESWIN:IsBeeTeam(ply)
    return ply:IsQueenBee() or ply:IsBee()
end
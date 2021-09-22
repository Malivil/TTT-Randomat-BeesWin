local EVENT = {}

util.AddNetworkString("RandomatBeesWinBegin")
util.AddNetworkString("RandomatBeesWinEnd")

CreateConVar("randomat_beeswin_count", 3, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "The number of bees spawned per player", 0, 10)

EVENT.Title = "Bees Win?"
EVENT.Description = "Those aren't traitors, they're BEEEEEEEEES!"
EVENT.id = "beeswin"
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE

function EVENT:Begin()
    net.Start("RandomatBeesWinBegin")
    net.Broadcast()

    BEESWIN:RegisterRoles()

    self:AddHook("TTTPrintResultMessage", function(win_type)
        if win_type == WIN_BEES then
            LANG.Msg("win_bees")
            ServerLog("Result: Bees win.\n")
            return true
        end
    end)

    self:AddHook("TTTCheckForWin", function()
        local bees_win = true
        for _, p in ipairs(player.GetAll()) do
            -- If there is a living non-bee then go back to the default check logic
            -- Exceptions for non-clown Jesters
            if p:Alive() and not p:IsSpec() and not Randomat:IsTraitorTeam(p) and (p:GetRole() == ROLE_CLOWN or not Randomat:IsJesterTeam(p)) then
                bees_win = false
                break
            end
        end

        if bees_win then
            return WIN_BEES
        end
    end)

    local traitors = {}
    local special = nil
    -- Collect the traitors to turn into bees
    for _, p in ipairs(self:GetAlivePlayers(true)) do
        if Randomat:IsTraitorTeam(p) then
            if p:GetRole() ~= ROLE_TRAITOR and special == nil then
                special = p
            end
            table.insert(traitors, p)
        end
    end

    -- If we don't have a special traitor, choose a random player
    if special == nil then
        special = traitors[math.random(1, #traitors)]
    end

    -- Convert the special traitor to the queen bee
    Randomat:SetRole(special, ROLE_QUEENBEE)
    self:StripRoleWeapons(special)
    special:SetCredits(3)
    special:PrintMessage(HUD_PRINTTALK, "You are the Queen Bee! Command your bees to swarm the enemy!")

    -- Convert all the other traitors to regular bees and give them their special weapon
    for _, p in ipairs(traitors) do
        if p ~= special then
            Randomat:SetRole(p, ROLE_BEE)
            self:StripRoleWeapons(p)
            p:SetCredits(0)
            p:Give("weapon_ttt_randomatbeecannon")
            p:PrintMessage(HUD_PRINTTALK, "You are a Worker Bee! Use your bee cannon and work with your hive to kill the enemy!")
        end
    end
    SendFullStateUpdate()

    -- Make bee team immune to bee damage
    self:AddHook("EntityTakeDamage", function(ent, dmginfo)
        if not IsPlayer(ent) then return end

        local att = dmginfo:GetAttacker()
        if not IsValid(att) then return end

        if Randomat:IsTraitorTeam(ent) and att:GetClass() == "npc_manhack" then
            dmginfo:ScaleDamage(0)
            dmginfo:SetDamage(0)
            return false
        end
    end)

    -- Start "bees" event if that is enabled
    local bee_count = GetConVar("randomat_beeswin_count"):GetInt()
    if bee_count > 0 then
        local t_count = #traitors
        local t_current = 1
        local b_current = 0
        timer.Create("RandomatBeesWinBeeSpawn", 0.1, bee_count * t_count, function()
            local rdmply = traitors[t_current]
            Randomat:SpawnBee(rdmply)

            -- Spawn an even number of bees around each bee role
            b_current = b_current + 1
            if b_current >= bee_count then
                t_current = t_current + 1
                b_current = 0
            end
        end)
    end
end

function EVENT:End()
    timer.Remove("RandomatBeesWinBeeSpawn")
end

function EVENT:Condition()
    if not CR_VERSION or not CRVersion("1.0.14") then return false end

    local t = 0
    for _, p in ipairs(self:GetAlivePlayers()) do
        if Randomat:IsTraitorTeam(p) then
            t = t + 1
        end
    end

    return t >= 2
end

function EVENT:GetConVars()
    local sliders = {}
    for _, v in ipairs({"count"}) do
        local name = "randomat_" .. self.id .. "_" .. v
        if ConVarExists(name) then
            local convar = GetConVar(name)
            table.insert(sliders, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 0
            })
        end
    end
    return sliders
end

Randomat:register(EVENT)
local EVENT = {}

util.AddNetworkString("RandomatBeesWinBegin")
util.AddNetworkString("RandomatBeesWinEnd")

CreateConVar("randomat_beeswin_count", 2, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "The number of bees spawned per player", 1, 10)

EVENT.Title = "Bees Win?"
EVENT.Description = "Those aren't traitors, they're BEEEEEEEEES!"
EVENT.id = "beeswin"

function EVENT:Begin()
    net.Start("RandomatBeesWinBegin")
    net.Broadcast()

    BEESWIN:RegisterRoles()

    hook.Add("TTTPrintResultMessage", "RandomatBeesWinPrintResult", function(win_type)
        if win_type == WIN_BEES then
            LANG.Msg("win_bees")
            ServerLog("Result: Bees win.\n")
            return true
        end
    end)

    hook.Add("TTTCheckForWin", "RandomatBeesWinCheck", function()
        local bees_win = true
        for _, p in ipairs(player.GetAll()) do
            -- If there is a living non-bee then go back to the default check logic
            if p:Alive() and not p:IsSpec() and not Randomat:IsTraitorTeam(p) then
                bees_win = false
                break
            end
        end

        if bees_win then
            return WIN_BEES
        end
    end)

    -- TODO: Select bees
    -- TODO: Set Queen Bee to 3 credits
    -- TODO: Make bee team immune to bee damage
    -- TODO: Give weapon_ttt_randomatbeecannon to non-queens
    -- TODO: Start "bees" event
    -- TODO: Tell everyone wtf is happening
end

function EVENT:End()
    hook.Remove("TTTPrintResultMessage", "RandomatBeesWinPrintResult")
    hook.Remove("TTTCheckForWin", "RandomatBeesWinCheck")
end

function EVENT:Condition()
    return CR_VERSION and CRVersion("1.0.14")
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
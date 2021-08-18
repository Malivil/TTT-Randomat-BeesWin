net.Receive("RandomatBeesWinBegin", function()
    BEESWIN:RegisterRoles()

    hook.Add("TTTScoringWinTitle", "RandomatBeesWinScoring", function(wintype, wintitle, title)
        if wintype == WIN_BEES then
            return { txt = "hilite_win_role_plural", params = { role = "BEES" }, c = Color(245, 200, 0, 255) }
        end
    end)
end)

net.Receive("RandomatBeesWinEnd", function()
    hook.Remove("TTTScoringWinTitle", "RandomatBeesWinScoring")
end)
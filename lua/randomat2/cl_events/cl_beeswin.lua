net.Receive("RandomatBeesWinBegin", function()
    BEESWIN:RegisterRoles()

    hook.Add("TTTScoringWinTitle", "RandomatBeesWinScoring", function(wintype, wintitle, title)
        if wintype == WIN_BEES then
            return { txt = "hilite_win_role_plural", params = { role = ROLE_STRINGS_PLURAL[ROLE_BEE]:upper() }, c = Color(245, 200, 0, 255) }
        end
    end)

    hook.Add("TTTEventFinishText", "RandomatBeesEventFinishText", function(e)
        if e.win == WIN_BEES then
            return LANG.GetTranslation("ev_win_bees")
        end
    end)

    hook.Add("TTTEventFinishIconText", "RandomatBeesEventFinishText", function(e, win_string, role_string)
        if e.win == WIN_BEES then
            return win_string, ROLE_STRINGS_PLURAL[ROLE_BEE]
        end
    end)
end)

net.Receive("RandomatBeesWinEnd", function()
    hook.Remove("TTTScoringWinTitle", "RandomatBeesWinScoring")
end)
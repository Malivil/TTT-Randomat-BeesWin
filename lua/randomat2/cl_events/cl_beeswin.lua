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

    -- Enable the tutorial page for these roles when the event is running
    hook.Add("TTTTutorialRoleEnabled", "RandomatBeesTutorialRoleEnabled", function(role)
        if (role == ROLE_BEE or role == ROLE_QUEENBEE) and Randomat:IsEventActive("beeswin") then
            return true
        end
    end)

    hook.Add("TTTTutorialRoleText", "RandomatBeesTutorialRoleText", function(role, titleLabel)
        if role ~= ROLE_BEE and role ~= ROLE_QUEENBEE then return end

        local roleColor = ROLE_COLORS[ROLE_TRAITOR]
        local html = "The " .. ROLE_STRINGS[role] .. " is a member of the <span style='color: rgb(" .. roleColor.r .. ", " .. roleColor.g .. ", " .. roleColor.b .. ")'>traitor team</span> whose job is to kill all of their enemies, both innocent and independent."

        if role == ROLE_BEE then
            html = html .. "<span style='display: block; margin-top: 10px;'>The " .. ROLE_STRINGS[ROLE_BEE] .. " is given a <span style='color: rgb(" .. roleColor.r .. ", " .. roleColor.g .. ", " .. roleColor.b .. ")'>Bee Cannon</span> which can be used to <span style='color: rgb(" .. roleColor.r .. ", " .. roleColor.g .. ", " .. roleColor.b .. ")'>shoot bees</span> at their enemies.</span>"
        else
            html = html .. "<span style='display: block; margin-top: 10px;'>The " .. ROLE_STRINGS[ROLE_QUEENBEE] .. " has <span style='color: rgb(" .. roleColor.r .. ", " .. roleColor.g .. ", " .. roleColor.b .. ")'>bee-themed items</span> available for purchase <span style='color: rgb(" .. roleColor.r .. ", " .. roleColor.g .. ", " .. roleColor.b .. ")'>in their shop</span>.</span>"
        end

        return html
    end)
end)

net.Receive("RandomatBeesWinEnd", function()
    hook.Remove("TTTScoringWinTitle", "RandomatBeesWinScoring")
    hook.Remove("TTTEventFinishText", "RandomatBeesEventFinishText")
    hook.Remove("TTTEventFinishIconText", "RandomatBeesEventFinishText")
    hook.Remove("TTTTutorialRoleEnabled", "RandomatBeesTutorialRoleEnabled")
    hook.Remove("TTTTutorialRoleText", "RandomatBeesTutorialRoleText")
end)
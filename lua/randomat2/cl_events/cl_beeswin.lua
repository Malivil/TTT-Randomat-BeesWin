local EVENT = {}
EVENT.id = "beeswin"

function EVENT:Initialize()
    timer.Simple(1, function()
        BEESWIN:RegisterRoles()
    end)
end

function EVENT:Begin()
    self:AddHook("TTTScoringWinTitle", function(wintype, wintitle, title)
        if wintype == WIN_BEES then
            return { txt = "hilite_win_role_plural", params = { role = ROLE_STRINGS_PLURAL[ROLE_BEE]:upper() }, c = Color(245, 200, 0, 255) }
        end
    end)

    self:AddHook("TTTEventFinishText", function(e)
        if e.win == WIN_BEES then
            return LANG.GetTranslation("ev_win_bees")
        end
    end)

    self:AddHook("TTTEventFinishIconText", function(e, win_string, role_string)
        if e.win == WIN_BEES then
            return win_string, ROLE_STRINGS_PLURAL[ROLE_BEE]
        end
    end)

    -- Enable the tutorial page for these roles when the event is running
    self:AddHook("TTTTutorialRoleEnabled", function(role)
        if (role == ROLE_BEE or role == ROLE_QUEENBEE) and Randomat:IsEventActive("beeswin") then
            return true
        end
    end)

    self:AddHook("TTTTutorialRoleText", function(role, titleLabel)
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
end

Randomat:register(EVENT)
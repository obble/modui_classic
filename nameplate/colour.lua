

    local OnEvent = function(_, event, unit)
        if  MODUI_VAR['elements']['nameplate'].enable and MODUI_VAR['elements']['nameplate'].friendlyclass then
            SetCVar('ShowClassColorInFriendlyNameplate', 1)
        end
    end

    local  e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', OnEvent)


    --

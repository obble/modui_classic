

    local _, ns = ...
    local build = tonumber(string.sub(GetBuildInfo() , 1, 2))
    if build > 1 then return end

    local plates = {}

    local events = {
        'NAME_PLATE_UNIT_ADDED',
        'PLAYER_ENTERING_WORLD',
        'PLAYER_TARGET_CHANGED',
    }

    local uevents = {
        'UNIT_MAXPOWER',
        'UNIT_POWER_FREQUENT',
    }

    local CreateComboFrame = function(unit)
        local plate = C_NamePlate.GetNamePlateForUnit(unit)
        plate.cp = plate.UnitFrame.healthBar:CreateFontString(nil, 'OVERLAY')
        plate.cp:SetFont(STANDARD_TEXT_FONT, 16, 'OUTLINE')
        plate.cp:SetPoint('RIGHT', plate.UnitFrame.healthBar)
        plate.cp:Hide()
    end

    local Update = function(frame)
        local points = GetComboPoints('player', 'target')
        local plate = C_NamePlate.GetNamePlateForUnit'target'
        if  plate then
            plate.cp:Hide()
            if  points > 0 then
                plate.cp:Show()
                plate.cp:SetText(string.rep('°', points))
                plate.cp:SetTextColor(.5*(points - 1), 2/(points - 1), .5/(points - 1))
                tinsert(plates, plate)
            end
        end
    end

    local Remove = function()
        for _, v in pairs(plates) do v.cp:Hide() end
        plates = {}
    end

    local OnEvent = function(self, event, ...)
        if  MODUI_VAR['elements']['nameplate'].enable and MODUI_VAR['elements']['nameplate'].combo then
            if event == 'NAME_PLATE_UNIT_ADDED' then
                CreateComboFrame(...)
            elseif event == 'PLAYER_TARGET_CHANGED' then
                Remove()
            else
                Update()
        	end
        end
    end

    local e = CreateFrame'Frame'
    for _, v in pairs(events)  do e:RegisterEvent(v) end
    for _, v in pairs(uevents) do e:RegisterUnitEvent(v, 'player') end
    e:SetScript('OnEvent', OnEvent)

    --

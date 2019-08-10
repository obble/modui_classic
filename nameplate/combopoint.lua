

    local _, ns = ...
    local build = tonumber(string.sub(GetBuildInfo() , 1, 2))
    if build > 1 then return end

    local cp    = {}
    local last  = 0

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
        if  not plate.ComboFrame then
            plate.ComboFrame = CreateFrame('Frame', nil, plate.UnitFrame.healthBar)
            plate.ComboFrame:SetSize(60, 10)
            plate.ComboFrame:SetPoint('CENTER', plate.UnitFrame.healthBar, 'BOTTOM', 10, -2)
            plate.ComboFrame:SetFrameStrata'TOOLTIP'
            plate.ComboFrame:Hide()
            tinsert(cp, plate.ComboFrame)

            plate.ComboFrame.ComboPoints = {}
            for i = 1, UnitPowerMax(PlayerFrame.unit, Enum.PowerType.ComboPoints) do
                plate.ComboFrame.ComboPoints[i] = CreateFrame('Frame', nil, plate.ComboFrame, 'ComboPointTemplate')
                plate.ComboFrame.ComboPoints[i]:SetSize(9, 9)
                --plate.ComboFrame.ComboPoints[i]:Hide()
                if  i > 1 then
                    plate.ComboFrame.ComboPoints[i]:SetPoint('LEFT', plate.ComboFrame.ComboPoints[i - 1], 'RIGHT', 1, 0)
                else
                    plate.ComboFrame.ComboPoints[i]:SetPoint'LEFT'
                end

                local bg = plate.ComboFrame.ComboPoints[i]:GetRegions()
                bg:SetSize(9, 11)

                local highlight = plate.ComboFrame.ComboPoints[i].Highlight
                highlight:SetSize(7, 11)

                local shine = plate.ComboFrame.ComboPoints[i].Shine
                shine:SetSize(10, 11)
            end
        end
        plate.ComboFrame.unit = unit
    end

    local Update = function(frame)
        local points = GetComboPoints(PlayerFrame.unit, 'target')

        for i = 1, #frame.ComboPoints do
            frame.ComboPoints[i]:Hide()
        end

        if  points > 0 and UnitIsUnit(frame.unit, 'target') then
            if  not frame:IsShown() then
                frame:Show()
                UIFrameFadeIn(frame, COMBOFRAME_FADE_IN)
            end
            local index = 1
            for i = 1, frame.maxComboPoints do
                local fade = {}
                local point = frame.ComboPoints[index]
                if  i <= points then
                    if  i > last then
                        fade.mode = 'IN'
                        fade.timeToFade = COMBOFRAME_HIGHLIGHT_FADE_IN
                        fade.finishedFunc = ComboPointShineFadeIn
                        fade.finishedArg1 = point.Shine
                        UIFrameFade(point.Highlight, fade)
                    end
                else
                    point.Highlight:SetAlpha(0)
                    point.Shine:SetAlpha(0)
                end
                point:Show()
                index = index + 1
            end
        else
            frame:Hide()
        end
        last = points
    end

    local UpdateMax = function(frame)
        frame.maxComboPoints = UnitPowerMax(PlayerFrame.unit, Enum.PowerType.ComboPoints)

        for i = 1, #frame.ComboPoints do
            frame.ComboPoints[i]:Hide()
        end

        Update(frame)
    end

    local OnEvent = function(self, event, ...)
        if event == 'NAME_PLATE_UNIT_ADDED' then
            CreateComboFrame(...)
            for _, plate in pairs(cp) do
                UpdateMax(plate)
            end
        elseif event == 'PLAYER_TARGET_CHANGED' or event == 'UNIT_POWER_FREQUENT' then
            for _, plate in pairs(cp) do
                Update(plate)
            end
    	elseif event == 'UNIT_MAXPOWER' then
            for _, plate in pairs(cp) do
                UpdateMax(plate)
            end
    	end
    end

    local e = CreateFrame'Frame'
    for _, v in pairs(events)  do e:RegisterEvent(v) end
    for _, v in pairs(uevents) do e:RegisterUnitEvent(v, 'player') end
    e:SetScript('OnEvent', OnEvent)

    --

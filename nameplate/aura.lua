

    local _, ns = ...

    local events = {
        'NAME_PLATE_UNIT_ADDED',
        'UNIT_AURA'
    }

    local CreateAura = function(plate)
        if  not plate.aura then
            plate.aura = {}
            for i = 1, 4 do
                plate.aura[i] = CreateFrame('Frame', nil, plate)
                plate.aura[i]:SetSize(16, 12)
                plate.aura[i]:SetPoint('BOTTOMLEFT', i == 1 and plate or plate.aura[i - 1], i == 1 and 'TOPLEFT' or 'BOTTOMRIGHT', 10, i == 1 and 15 or 0)

                plate.aura[i].icon = plate.aura[i]:CreateTexture(nil, 'ARTWORK')
                plate.aura[i].icon:SetAllPoints()

                plate.aura[i].count = plate.aura[i]:CreateFontString(nil, 'OVERLAY')
                plate.aura[i].count:SetTextColor(1, 1, 1)
                plate.aura[i].count:SetFontObject'SystemFont_Shadow_Small'
                plate.aura[i].count:SetPoint('CENTER', plate.aura[i], 'BOTTOM')

                plate.aura[i].cooldown = CreateFrame('Cooldown', nil, plate.aura[i], 'CooldownFrameTemplate')
                plate.aura[i].cooldown:SetAllPoints()
                plate.aura[i].cooldown:SetReverse(true)
                plate.aura[i].cooldown:SetHideCountdownNumbers(true)
            end
        end
    end

    local UpdateFilter = function(unit)
        if  UnitIsUnit('player', unit) then
            return 'HELPFUL|INCLUDE_NAME_PLATE_ONLY'
        else
            local r = UnitReaction('player', unit)
            if  r and r <= 4 then
                return 'HARMFUL|INCLUDE_NAME_PLATE_ONLY'
            else
                return 'HARMFUL|RAID'
            end
        end
    end

    local ShouldShowBuff = function(name, caster, showpersonal, showall)
        if not name then return false end
        return showall or (showpersonal and (caster == 'player' or caster == 'pet'))
    end

    local UpdateAura = function(plate, unit)
        local filter = UpdateFilter(unit)
        for i = 1, 4 do
            local name, icon, count, type, duration, expiration, caster, _, showpersonal, spellid, _, _, _, showall = UnitAura(unit, i, filter)
			plate.aura[i]:Hide()
            if  ShouldShowBuff(name, caster, showpersonal, showall, duration) then -- use "show"
                plate.aura[i]:SetID(i)
                plate.aura[i].icon:SetTexture(icon)
                if  count > 1 then
                    plate.aura[i].count:SetText(count)
                    plate.aura[i].count:Show()
                else
                    plate.aura[i].count:Hide()
                end
                CooldownFrame_Set(plate.aura[i].cooldown, expiration - duration, duration, duration > 0, true)
                plate.aura[i]:Show()
            end
        end
    end

    local OnEvent = function(_, event, unit)
        if  event == 'NAME_PLATE_UNIT_ADDED' then
            CreateAura(C_NamePlate.GetNamePlateForUnit(unit))
        elseif event == 'UNIT_AURA' then
            local  plate = C_NamePlate.GetNamePlateForUnit(unit)
            if not plate then return end
            UpdateAura(plate, unit)
        end
    end

    local  e = CreateFrame'Frame'
    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnEvent', OnEvent)


    --

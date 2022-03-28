

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
                ns.BD(plate.aura[i], 1, -2)
                ns.BUBorder(plate.aura[i], 18, 12, 4, 5)
                for j = 1, 4 do
                    tinsert(ns.skinbu, plate.aura[i].bo[j])
                    plate.aura[i].bo[j]:SetVertexColor(MODUI_VAR['theme_bu'].r, MODUI_VAR['theme_bu'].g, MODUI_VAR['theme_bu'].b)
                end
                --ns.BD(plate.aura[i])
                plate.aura[i]:SetSize(16, 9)
                plate.aura[i]:SetPoint('BOTTOMLEFT', i == 1 and plate or plate.aura[i - 1], i == 1 and 'TOPLEFT' or 'BOTTOMRIGHT', i == 1 and 2 or 8, i == 1 and 2 or 0)
                plate.aura[i]:Hide()

                plate.aura[i].icon = plate.aura[i]:CreateTexture(nil, 'ARTWORK')
                plate.aura[i].icon:SetTexCoord(.1, .9, .1, .6)
                plate.aura[i].icon:SetAllPoints()

                plate.aura[i].count = plate.aura[i]:CreateFontString(nil, 'OVERLAY')
                plate.aura[i].count:SetTextColor(1, 1, 1)
                plate.aura[i].count:SetFontObject'SystemFont_Shadow_Small'
                plate.aura[i].count:SetPoint('CENTER', plate.aura[i], 'BOTTOM')

                plate.aura[i].cooldown = CreateFrame('Cooldown', nil, plate.aura[i], 'CooldownFrameTemplate')
                plate.aura[i].cooldown:SetAllPoints()
                plate.aura[i].cooldown:SetSwipeTexture[[Interface\CHARACTERFRAME\TempPortraitAlphaMaskSmall]]
                plate.aura[i].cooldown:SetReverse(true)

                local t = plate.aura[i].cooldown:GetRegions()
                t:SetFont(STANDARD_TEXT_FONT, 8, 'OUTLINE')
                t:ClearAllPoints()
                t:SetPoint('CENTER', plate.aura[i].cooldown, 'TOP')
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
        if caster == 'player' or caster == 'pet' then
            return true
        else
            return false
        end
    end

    local UpdateAura = function(plate, unit, ...)
        local filter = UpdateFilter(unit)
        for i = 1, 4 do
            local name, icon, count, type, duration, expiration, caster, _, showpersonal, spellid, _, _, _, showall = UnitAura(unit, i, filter)
            local colour = DebuffTypeColor[type or 'none']

			plate.aura[i]:Hide()
            if  ShouldShowBuff(name, caster) then -- use "show"
                plate.aura[i]:SetID(i)
                plate.aura[i].icon:SetTexture(icon)
                if  count > 1 then
                    plate.aura[i].count:SetText(count)
                    plate.aura[i].count:Show()
                else
                    plate.aura[i].count:Hide()
                end

                for j = 1, 4 do
                    plate.aura[i].bo[j]:SetVertexColor(colour.r*1.7, colour.g*1.7, colour.b*1.7)
                end

                -- its really annoying but we can't track durations and determine when a spell is refreshed or not using UnitAura
                -- we'll probably have to move over to combat log events if LCD isnt flexible enough...

                if  ns.auras[name] then

                    if  expiration and expiration ~= 0 then
                        local start = expiration - duration
                        CooldownFrame_Set(plate.aura[i].cooldown, start, duration, true)
                    else
                        CooldownFrame_Clear(plate.aura[i].cooldown)
                    end
                end

                plate.aura[i]:Show()
            end
        end
    end

    local OnEvent = function(_, event, unit, ...)
        if  MODUI_VAR['elements']['nameplate'].enable and MODUI_VAR['elements']['nameplate'].aura then
            local  plate = C_NamePlate.GetNamePlateForUnit(unit)
            if not plate then return end
            if  event == 'NAME_PLATE_UNIT_ADDED' then
                CreateAura(plate)
            end
            UpdateAura(plate, unit, ...)
        end
    end

    local  e = CreateFrame'Frame'
    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnEvent', OnEvent)


    --

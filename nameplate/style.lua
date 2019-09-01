
    local _, ns = ...

    local events = {
        'NAME_PLATE_CREATED',
        'NAME_PLATE_UNIT_ADDED',
    }

    local LCMH = LibStub'LibClassicMobHealth-1.0'

    local UpdatePvP = function(plate, unit)
        if not plate.pvp then return end
        local rank = UnitPVPRank(unit)
        plate.pvp:Hide()
        if  rank then
            local _, rankNo = GetPVPRankInfo(rank)
            if  rankNo > 0 then
                plate.pvp:Show()
                plate.pvp:SetTexture(format('%s%02d', 'Interface\\PvPRankBadges\\PvPRank', rankNo))
            end
        end
    end

    local UpdateHealthText = function(plate)
        local frame = plate:GetParent()
        local v, max, found = LCMH:GetUnitHealth(frame.namePlateUnitToken)

        if  UnitIsUnit('target', frame.namePlateUnitToken) then
            v, max, found = LCMH:GetUnitHealth'target'
        end

        if  v and v > 0 and v ~= 100 then
            plate.healthBar.LeftText:SetText(v)
            ns.GRADIENT_COLOUR(plate.healthBar.LeftText, v, 0, max)
        else
            plate.healthBar.LeftText:SetText''
        end
    end

    local AddElements = function(plate)
        plate.pvp = plate:CreateTexture(nil, 'OVERLAY')
        plate.pvp:SetSize(14, 13)
        plate.pvp:SetPoint('RIGHT', plate.name, 'LEFT', -3, 1)
        plate.pvp:Hide()

        plate.name:SetFont(STANDARD_TEXT_FONT, 10)
        plate.name:ClearAllPoints()
        plate.name:SetPoint('BOTTOMRIGHT', plate, 'TOPRIGHT', -6, -13)
        plate.name:SetJustifyH'RIGHT'

        -- plate.healthBar:SetStatusBarTexture[[Interface/AddOns/modui_classic/art/statusbar/namebg.tga]]

        plate.healthBar.LeftText = plate.healthBar:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
        plate.healthBar.LeftText:SetPoint('LEFT', plate.healthBar, 2, 1)
        plate.healthBar.LeftText:SetFont(STANDARD_TEXT_FONT, 8, 'OUTLINE')

        plate.healthBar:HookScript('OnValueChanged', function() UpdateHealthText(plate) end)

        for _, v in pairs({plate.healthBar.border:GetRegions()}) do
            tinsert(ns.skin, v)
            v:SetVertexColor(MODUI_VAR['theme'].r or 1, MODUI_VAR['theme'].g or 1, MODUI_VAR['theme'].b or 1)
        end
    end

    local OnEvent = function(self, event, ...)
        if MODUI_VAR['elements']['nameplate'].enable then
            if event == 'NAME_PLATE_CREATED' then
                local base = ...
                AddElements(base.UnitFrame)
            else
                local unit  = ...
                local plate = C_NamePlate.GetNamePlateForUnit(...)
                UpdatePvP(plate, unit)
            end
        end
   end

   local  e = CreateFrame'Frame'
   for _, v in pairs(events) do e:RegisterEvent(v) end
   e:SetScript('OnEvent', OnEvent)


    --

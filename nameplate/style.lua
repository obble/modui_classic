
    local _, ns = ...

    local UpdatePvP = function(plate, unit)
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

    local AddElements = function(plate)
        plate.pvp = plate:CreateTexture(nil, 'OVERLAY')
        plate.pvp:SetSize(14, 13)
        plate.pvp:SetPoint('RIGHT', plate.name, 'LEFT', -3, 1)
        plate.pvp:Hide()

        plate.name:SetFont(STANDARD_TEXT_FONT, 10)
        plate.name:ClearAllPoints()
        plate.name:SetPoint('BOTTOMRIGHT', plate, 'TOPRIGHT', -6, -13)
        plate.name:SetJustifyH'RIGHT'

        plate.healthBar:SetStatusBarTexture[[Interface/AddOns/modui_classic/art/statusbar/namebg.tga]]

        plate.healthBar.border:SetVertexColor(.2, .2, .2)

        tinsert(ns.skin, plate.healthBar.border)
    end

    local OnEvent = function(self, event, ...)
        if MODUI_VAR['elements']['nameplate'].enable then
            local base = ...
            AddElements(base.UnitFrame)
        end
   end

   local e = CreateFrame'Frame'
   e:RegisterEvent'NAME_PLATE_CREATED'
   e:SetScript('OnEvent', OnEvent)


    --

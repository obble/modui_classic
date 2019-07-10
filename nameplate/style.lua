

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
    end


    --

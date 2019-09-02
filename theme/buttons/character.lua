

    local _, ns = ...

    local events = {
        'PLAYER_LOGIN',
        'UNIT_INVENTORY_CHANGED'
    }

    local slots = {
        [0] = 'Ammo',
        'Head',
        'Neck',
        'Shoulder',
        'Shirt',
        'Chest',
        'Waist',
        'Legs',
        'Feet',
        'Wrist',
        'Hands',
        'Finger0',
        'Finger1',
        'Trinket0',
        'Trinket1',
        'Back',
        'MainHand',
        'SecondaryHand',
        'Ranged',
        'Tabard'
    }

    local AddSlots = function()
        for _, v in pairs(slots) do
            local bu =  _G['Character'..v..'Slot']
            ns.ItemElements(bu)
            ns.BUBorder(bu)
            bu:SetNormalTexture''
            print(v)
            if  v == 'SecondaryHand' or v == 'Ranged' then
                local x = {bu:GetPoint()}
                bu:ClearAllPoints()
                bu:SetPoint(x[1], x[2], x[3], 10, x[5])
            elseif  v == 'Head' then
                bu:ClearAllPoints()
                bu:SetPoint('TOPLEFT', 21, -72)
            elseif  v == 'Hands' then
                bu:ClearAllPoints()
                bu:SetPoint('TOPLEFT', 306, -72)
            elseif  v == 'MainHand' then
                local x = {bu:GetPoint()}
                bu:ClearAllPoints()
                bu:SetPoint('TOPLEFT', x[2], 'BOTTOMLEFT', 122, 127)
            else
                local x = {bu:GetPoint()}
                bu:ClearAllPoints()
                bu:SetPoint(x[1], x[2], x[3], x[4], -8.5)
            end
        end
    end

    local UpdateSlotSize = function(self)
        if not self:GetName():find'Ammo' then self:SetSize(33, 33) end
    end

    local UpdateSlots = function()
        for i, v in pairs(slots) do
            local  bu   = _G['Character'..v..'Slot']
            if not bu.bo then return end
            local rarity = GetInventoryItemQuality('player', i)
            for i, v in pairs(bu.bo) do
                if  rarity and rarity >= 2 and BAG_ITEM_QUALITY_COLORS[rarity] then
                    local colour = BAG_ITEM_QUALITY_COLORS[rarity]
                    bu.bo[i]:SetVertexColor(colour.r*1.5, colour.g*1.5, colour.b*1.5)
                else
                    bu.bo[i]:SetVertexColor(MODUI_VAR['theme'].r or 1, MODUI_VAR['theme'].g or 1, MODUI_VAR['theme'].b or 1)
                end
            end
        end
    end

    local OnEvent = function(self, event, ...)
        if  event == 'UNIT_INVENTORY_CHANGED' then
            UpdateSlots()
        else
            AddSlots()
            hooksecurefunc('PaperDollItemSlotButton_Update', UpdateSlotSize)
        end
    end

    local  e = CreateFrame('Frame', nil, CharacterFrame)
    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnShow',  UpdateSlots)
    e:SetScript('OnEvent', OnEvent)

    --

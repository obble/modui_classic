

    local _, ns = ...

    local FONT_REGULAR = ns.FONT_REGULAR

    local e = CreateFrame'Frame'

    local ColourBagBorders = function(bu, slotID, texture, rarity, type, quest)
        local q = _G[bu:GetName()..'IconQuestTexture']
        local s = _G[bu:GetName()].searchOverlay
        if  bu.bo then
            for i, v in pairs(bu.bo) do
                if  texture then
                        -- search
                    if  s:IsShown() then
                        bu.bo[i]:SetVertexColor(1, 1, 1)
                        -- quest
                    elseif quest then
                        bu.bo[i]:SetVertexColor(248/255, 98/255, 86/255)
                        -- uncommon+ quality
                    elseif rarity and rarity >= 2 and BAG_ITEM_QUALITY_COLORS[rarity] then
                        local colour = BAG_ITEM_QUALITY_COLORS[rarity]
                        bu.bo[i]:SetVertexColor(colour.r*1.5, colour.g*1.5, colour.b*1.5)
                    elseif type > 0 then
                        bu.bo[i]:SetVertexColor(.4, .3, 0)
                    else
                        bu.bo[i]:SetVertexColor(MODUI_VAR['theme_bu'].r or 1, MODUI_VAR['theme_bu'].g or 1, MODUI_VAR['theme_bu'].b or 1)
                    end
                else
                    if  type > 0 then
                        bu.bo[i]:SetVertexColor(.4, .3, 0)
                    else
                        bu.bo[i]:SetVertexColor(.2, .2, .2)
                    end
                end
            end
        end
    end

    local ColourBankBorders = function(bu, name)
        local q = bu['IconQuestTexture']
        if  bu.bo then
            -- quest
            for i, v in pairs(bu.bo) do
                if name then
                    if  q and q:IsShown() then
                        bu.bo[i]:SetVertexColor(248/255, 98/255, 86/255)
                    -- uncommon+
                    elseif bu.quality and bu.quality > 1 and BAG_ITEM_QUALITY_COLORS[bu.quality] then
                        local colour = BAG_ITEM_QUALITY_COLORS[bu.quality]
                        bu.bo[i]:SetVertexColor(colour.r, colour.g, colour.b)
                    else
                        bu.bo[i]:SetVertexColor(MODUI_VAR['theme_bu'].r or 1, MODUI_VAR['theme_bu'].g or 1, MODUI_VAR['theme_bu'].b or 1)
                    end
                else
                    bu.bo[i]:SetVertexColor(.2, .2, .2)
                end
            end
        end
    end

    ns.ColourUpdate = function(frame)
        local name = frame:GetName()
        local id   = frame:GetID()
        for i = 1, frame.size do
            local bu = _G[name..'Item'..i]
            local itemID = GetContainerItemID(id, bu:GetID())
            local texture, _, _, rarity = GetContainerItemInfo(id, bu:GetID())
            local itemlink = GetContainerItemLink(id, bu:GetID())
            local quest = false
            if  itemlink then
                local _, _, _, _, _, itemtype = GetItemInfo(itemlink)
                if itemtype == TRANSMOG_SOURCE_2 then
                    quest = true
                end
            end

            local _, type = GetContainerNumFreeSlots(id)
            ColourBagBorders(bu, itemID, texture, rarity, type, quest)
            bu.IconBorder:Hide()
        end
    end

    ns.BankColourUpdate = function(bu)
        local id        = bu:GetID()
        local container = bu:GetParent():GetID()

        if bu.isBag then container = -4 end
        if container == 0 then return end -- stop colouring bags

        local _, _, _, _, _, _, ilink = GetContainerItemInfo(container, id)
        bu.ilink   = ilink
        bu.quality = nil

        if  bu.ilink then
            bu.name, _, bu.quality = GetItemInfo(bu.ilink)
        end

        ColourBankBorders(bu, bu.name)
    end

    ns.AddButtonStyle = function(bu)
        if  bu and not bu.bo then
            ns.BU(bu, 1, true)
            ns.BUBorder(bu, 21)
            ns.ItemElements(bu)
        end
    end

    local AddBankSlots = function()
        for i = 1, 7 do
            local bu = BankSlotsFrame['Bag'..i]
            ns.BU(bu)
            ns.BUElements(bu)
        end
    end

    hooksecurefunc('ContainerFrame_Update',                 ns.ColourUpdate)
    hooksecurefunc('ContainerFrame_UpdateSearchResults',    ns.ColourUpdate)
    hooksecurefunc('BankFrameItemButton_Update',            ns.BankColourUpdate)

    --

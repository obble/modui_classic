

    local _, ns = ...

    local FONT_REGULAR = ns.FONT_REGULAR

    local e = CreateFrame'Frame'

    --[[ns.BD(BagItemAutoSortButton)
    BagItemAutoSortButton:SetSize(15, 15)
    BagItemAutoSortButton:GetNormalTexture():SetTexCoord(.15, .85, .15, .85)
    BagItemAutoSortButton:GetNormalTexture():ClearAllPoints()
    BagItemAutoSortButton:GetNormalTexture():SetPoint('TOPLEFT', -1, 1)
    BagItemAutoSortButton:GetNormalTexture():SetPoint('BOTTOMRIGHT', 1, -1)
    BagItemAutoSortButton:HookScript('OnClick', function()
        if ReagentBankFrame:IsShown() and IsReagentBankUnlocked() then
            SortReagentBankBags()
        elseif BankFrame:IsShown() then
            SortBankBags()
        end
    end)

    for _, v in pairs({
        BagItemSearchBox.Left, BagItemSearchBox.Middle, BagItemSearchBox.Right
    }) do
        v:Hide()
    end]]

    local ColourBagBorders = function(bu, slotID, texture, rarity)
        local q = _G[bu:GetName()..'IconQuestTexture']
        local s = _G[bu:GetName()].searchOverlay
        if  bu.bo then
            for i, v in pairs(bu.bo) do
                if  texture then
                        -- search
                    if  s:IsShown() then
                        bu.bo[i]:SetVertexColor(1, 1, 1)
                        -- quest
                    elseif q and q:IsShown() then
                        bu.bo[i]:SetVertexColor(248/255, 98/255, 86/255)
                        -- uncommon+ quality
                    elseif rarity and rarity >= 2 and BAG_ITEM_QUALITY_COLORS[rarity] then
                        local colour = BAG_ITEM_QUALITY_COLORS[rarity]
                        bu.bo[i]:SetVertexColor(colour.r, colour.g, colour.b)
                    else
                        bu.bo[i]:SetVertexColor(1, 1, 1)
                    end
                else
                    bu.bo[i]:SetVertexColor(.2, .2, .2)
                end
            end
        end
    end

    local ColourBankBorders = function(bu)
        local q = bu['IconQuestTexture']
        if  bu.bo then
            -- quest
            for i, v in pairs(bu.bo) do
                if  q and q:IsShown() then
                    bu.bo[i]:SetVertexColor(248/255, 98/255, 86/255)
                -- uncommon+
                elseif bu.quality and bu.quality > 1 and BAG_ITEM_QUALITY_COLORS[bu.quality] then
                    local colour = BAG_ITEM_QUALITY_COLORS[bu.quality]
                    bu.bo[i]:SetVertexColor(colour.r, colour.g, colour.b)
                else
                    bu.bo[i]:SetVertexColor(1, 1, 1)
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
            ColourBagBorders(bu, itemID, texture, rarity)
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

        ColourBankBorders(bu)
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

    local AddTokens = function()
        for i = 1, 3 do
            local bu    = _G['BackpackTokenFrameToken'..i]
            local ic    = _G['BackpackTokenFrameToken'..i..'Icon']
            local count = _G['BackpackTokenFrameToken'..i..'Count']
            if bu then
                ic:ClearAllPoints()
                ic:SetPoint('RIGHT', bu)
                ic:SetTexCoord(.1, .9, .1, .9)

                count:ClearAllPoints()
                count:SetPoint('RIGHT', ic, 'LEFT', -3, 0)
                count:SetFont(FONT_REGULAR, 7)
            end
        end
    end

    local AddSlots = function()
        for i = 0, 3 do
            local bu = _G['CharacterBag'..i..'Slot']
            ns.BU(bu)
            ns.BUElements(bu)
            bu:SetSize(18, 12)
        end
    end

    local MinorButtonSkins = function()
        AddTokens()
        AddSlots()
        AddBankSlots()
        e:UnregisterEvent'PLAYER_ENTERING_WORLD'
    end

    e:RegisterEvent'PLAYER_ENTERING_WORLD'
    e:SetScript('OnEvent', MinorButtonSkins)

    hooksecurefunc('ContainerFrame_Update',                 ns.ColourUpdate)
    hooksecurefunc('ContainerFrame_UpdateSearchResults',    ns.ColourUpdate)
    hooksecurefunc('BankFrameItemButton_Update',            ns.BankColourUpdate)

    --



    local _, ns = ...

    local classifications = {
    	worldboss  = ' Boss',
    	rareelite  = ' Rare Elite',
    	rare       = ' Rare',
    	elite      = ' Elite',
    }

    local tooltips = {
        GameTooltip,
        ItemRefTooltip
    }

    local AddPrice = function(tooltip, count, id)
        local _, item

        if  id then
    	    item = id
        else
            _, item = tooltip:GetItem()
        end

        if  item then
        	local _, _, _, _, _, _, _, _, _, _, price = GetItemInfo(item)

        	if  price and price > 0 then
        		tooltip:AddDoubleLine(SELL_PRICE..': ', GetCoinText(count and price*count or price), nil, nil, nil, 1, 1, 1)
        	end

        	if  tooltip:IsShown() then
                tooltip:Show()
            end
        end
    end

    local UnitColours = function(unit)
    	if  UnitIsPlayer(unit)then
    		local _, class = UnitClass(unit)
    		return ns.INTERNAL_CLASS_COLORS[class]
    	elseif UnitReaction(unit, 'player') then
    		return FACTION_BAR_COLORS[UnitReaction(unit, 'player')]
        else
            return nil
    	end
    end

    local AddStatusBarColour = function(bar, unit)
        local colour = UnitColours(unit)
        if  colour then
            bar:SetStatusBarColor(colour.r, colour.g, colour.b)
        end
    end

    local AddRaidIcon = function(unit)
        local  index = GetRaidTargetIndex(unit)
        return index and '  '..ICON_LIST[index]..'10|t' or ''
    end

    local AddRelationship  = function(unit)
        local   relationship = UnitRealmRelationship(unit)
        return (relationship == 2 or relationship == 3) and ' —|r' or '|r'  -- ends colour formatting
    end

    local AddFaction  = function(unit)
        local faction = UnitFactionGroup(unit)
        local path = '|TInterface\\COMMON\\icon-'
        local icon
        if faction == FACTION_HORDE then
            icon = path..'horde:14:14:0:0:64:64:14:50:14:50|t '
        elseif faction == FACTION_ALLIANCE then
            icon = path..'alliance:14:14:0:0:64:64:14:50:14:50|t '
        else
            icon = ''
        end
        return icon
    end

    local AddFlag = function(unit)
        local AFK = UnitIsAFK(unit) and ' |cff00ff00'..CHAT_FLAG_AFK..'|r'
        local DND = UnitIsDND(unit) and ' |cff00ff00'..CHAT_FLAG_DND..'|r'
        return AFK or DND or ''
    end

    local AddName = function(unit)
        local colour        = UnitColours(unit) and ConvertRGBtoColorString(UnitColours(unit)) or nil
        local icon          = AddRaidIcon(unit)
        local name          = UnitName(unit)
        local relationship  = AddRelationship(unit)
        local faction       = AddFaction(unit)
        local flag          = AddFlag(unit)
        if colour then -- band-aid fix the error from zoning -_-
            GameTooltipTextLeft1:SetFormattedText('%s%s%s%s%s%s', faction, flag, colour, name, relationship, icon)
        end
    end

    local AddGuild = function(unit, line, Guild)
        local colour = UnitIsInMyGuild(unit) and '004af1' or '13f62e'
        line:SetFormattedText('|cff'..colour..'<%s>|r', Guild)
    end

    local AddClassification = function(unit)
        return classifications[UnitClassification(unit)] or ''
    end

    local AddHooks = function(unit)
        for _, v in pairs(tooltips) do
            hooksecurefunc(v, 'SetAuctionItem', function(self, type, index)
            	local _, _, count = GetAuctionItemInfo(type, index)
            	AddPrice(self, count)
            end)

            hooksecurefunc(v, 'SetAuctionSellItem', function(self)
            	local _, _, count = GetAuctionSellItemInfo()
            	AddPrice(self, count)
            end)

            hooksecurefunc(v, 'SetBagItem', function(self, container, slot)
                local _, count = GetContainerItemInfo(container, slot)
            	AddPrice(self, count)
            end)

            hooksecurefunc(v, 'SetCraftItem', function(self, skill, slot)
                local count = 1
                if slot then _, _, count = GetCraftReagentInfo(skill, slot) end
            	AddPrice(self, count)
            end)

            --[[hooksecurefunc(v, 'SetHyperLink', function(self, link, count)
            	count = tonumber(count)
            	if  not count or count < 1 then
            		local owner = self:GetOwner()
            		count = owner and tonumber(owner.count)
            		if  not count or count < 1 then
            			count = 1
            		end
            	end
                AddPrice(self, count)
            end)]]

            --[[hooksecurefunc(v, 'SetIventoryItem', function(self, unit, slot)
                if type(slot) ~= 'number' or slot < 0 then return end
            	local count = 1
            	if  slot < 20 or slot > 39 and slot < 68 then
            		count = GetInventoryItemCount(unit, slot)
            	end
            	AddPrice(self, count)
            end)]]

            hooksecurefunc(v, 'SetLootItem', function(self, slot)
                local _, _, count = GetLootSlotInfo(slot)
                AddPrice(self, count)
            end)

            hooksecurefunc(v, 'SetLootRollItem', function(self, id)
                local _, _, count = GetLootRollItemInfo(id)
                AddPrice(self, count)
            end)

            hooksecurefunc(v, 'SetMerchantItem', function(self, slot)
                local _, _, _, count = GetMerchantItemInfo(slot)
                AddPrice(self, count)
            end)

            hooksecurefunc(v, 'SetMerchantCostItem', function(self, index, item)
                local _, count = GetMerchantItemCostItem(index, item)
                AddPrice(self, count)
            end)

            hooksecurefunc(v, 'SetQuestItem', function(self, type, slot)
                local _, _, count = GetQuestItemInfo(type, slot)
                AddPrice(self, count)
            end)

            hooksecurefunc(v, 'SetQuestLogItem', function(self, _, index)
                local _, _, count = GetQuestLogRewardInfo(index)
                AddPrice(self, count)
            end)

            hooksecurefunc(v, 'SetSendMailItem', function(index)
            	local _, _, count = GetSendMailItem(index)
                AddPrice(self, count)
            end)

            hooksecurefunc(v, 'SetTradePlayerItem', function(self, index)
                local _, _, count = GetTradePlayerItemInfo(index)
                AddPrice(self, count)
            end)

            hooksecurefunc(v, 'SetTradeSkillItem', function(self, skill, slot)
            	local count = 1
            	if  slot then _, _, count = GetTradeSkillReagentInfo(skill, slot) end
                AddPrice(self, count)
            end)

            hooksecurefunc(v, 'SetTradeTargetItem', function(self, index)
            	local _, _, count = GetTradeTargetItemInfo(index)
                AddPrice(self, count)
            end)
        end
    end

    local AddContents = function(self)
    	local _, unit = self:GetUnit()
    	if not unit then return end

        local Guild     = GetGuildInfo(unit)
        --  health bar: colour to unit type
        AddStatusBarColour(GameTooltipStatusBar, unit)
        --  line 1: format name
        AddName(unit)
        --  format further lines
    	for i = 2, self:NumLines() do
    		local line = _G['GameTooltipTextLeft'..i]
    		local t = line:GetText()
            --  ALL lines
            -- line:SetTextColor(.8, .8, .6)
            --  line 2:  guild
            if Guild and t:find(Guild) then
                AddGuild(unit, line, Guild)
            end
            --  line 3:  level
            if t:find(TOOLTIP_UNIT_LEVEL or 'Level %s') then
                local classification = AddClassification(unit)
                line:SetText(t..classification)
            end
            --  hide pvp/faction flags.
            if  t:find(PVP)
            or  t:find(FACTION_HORDE)
            or  t:find(FACTION_ALLIANCE) then
                line:SetText''
                line:Hide()
            end
        end
    end

    local OnEvent = function(self, event)
        if  MODUI_VAR['elements']['tooltip'].enable then
            AddHooks()
            GameTooltip:HookScript('OnTooltipSetUnit', AddContents)
        end
    end

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', OnEvent)


    --

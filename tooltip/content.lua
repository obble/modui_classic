

    local _, ns = ...
    local e = CreateFrame'Frame'

    local classifications = {
    	worldboss  = ' Boss',
    	rareelite  = ' Rare Elite',
    	rare       = ' Rare',
    	elite      = ' Elite',
    }

    local AddID = function(type, id)
        GameTooltip:AddLine(string.format('%s '..ID..': |cffd083cd%s|r', type, id))
    	GameTooltip:Show()
    end

    local UnitColours = function(unit)
    	if  UnitIsPlayer(unit) and not UnitHasVehicleUI(unit) then
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

    local AddIDHooks = function(unit)
        hooksecurefunc(GameTooltip, 'SetAction', function(self)
        	local _, _, id = self:GetSpell()
        	if id then
        		AddID(STAT_CATEGORY_SPELL, id)
        	else
        		local _, ilink = self:GetItem()
        		if  ilink then
        			AddID(HELPFRAME_ITEM_TITLE, string.match(ilink, 'item:(%d+)'))
        		end
        	end
        end)

        hooksecurefunc(GameTooltip, 'SetSpellByID', function(self, id)
            AddID(STAT_CATEGORY_SPELL, id)
        end)

        hooksecurefunc(GameTooltip, 'SetTalent', function(self, id)
        	AddID(STAT_CATEGORY_SPELL, id)
        end)

        hooksecurefunc(GameTooltip, 'SetBagItem', function(self, container, slot)
        	local id = GetContainerItemID(container, slot)
        	if id then AddID(HELPFRAME_ITEM_TITLE, id) end
        end)

        hooksecurefunc(GameTooltip, 'SetUnitAura', function(self, unit, index, filter)
        	local name, icon, count, dtype, duration, expiration, _, _, _, id = UnitAura(unit, index, filter)
        	if id then AddID(STAT_CATEGORY_SPELL, id) end
        end)

        e:UnregisterAllEvents()
    end

    --  format tooltip
    GameTooltip:HookScript('OnTooltipSetUnit', function(self)
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
            line:SetTextColor(.8, .8, .6)
            --  line 2:  guild
            if Guild and t:find(Guild) then
                AddGuild(unit, line, Guild)
            end
            --  line 3:  level
            if t:find(TOOLTIP_UNIT_LEVEL) then
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
    end)

    e:RegisterEvent'PLAYER_ENTERING_WORLD'
    e:SetScript('OnEvent', AddIDHooks)


    --

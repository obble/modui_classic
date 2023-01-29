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
    GameTooltip:HookScript('OnTooltipSetUnit', AddContents)
end

local e = CreateFrame'Frame'
e:RegisterEvent'PLAYER_LOGIN'
e:SetScript('OnEvent', OnEvent)


--

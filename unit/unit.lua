local _, ns = ...

local events = {
    'PLAYER_LOGIN',
    'GROUP_ROSTER_UPDATE',
    'RAID_ROSTER_UPDATE',
    'PLAYER_TARGET_CHANGED',
    'PLAYER_FOCUS_CHANGED',
    'UNIT_SPELLCAST_START',
    'UNIT_SPELLCAST_CHANNEL_START',
    'UNIT_FACTION'
}

local AddPlayerFrame = function()
    for _, v in pairs(
        {
            PlayerFrameHealthBarText,
            PlayerFrameHealthBarTextLeft,
            PlayerFrameHealthBarTextRight,
            PlayerFrameManaBarText,
            PlayerFrameManaBarTextLeft,
            PlayerFrameManaBarTextRight,
        }
        ) do
        v:SetFont(STANDARD_TEXT_FONT, 10, 'OUTLINE')
    end

    PlayerFrame:ClearAllPoints();
    PlayerFrame:SetPoint("TOPLEFT", UIParent, 380, -290);
    PlayerFrame:SetUserPlaced(true)


    if not PlayerFrame.bg then
        local _, class  = UnitClass'player'
        local colour    = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
        PlayerFrame.bg = PlayerFrame:CreateTexture()
        PlayerFrame.bg:SetPoint('TOPLEFT', PlayerFrameBackground)
        PlayerFrame.bg:SetPoint('BOTTOMRIGHT', PlayerFrameBackground, 0, 22)
        PlayerFrame.bg:SetVertexColor(colour.r, colour.g, colour.b)
    end

    PlayerPVPIcon:SetAlpha(0)


    CastingBarFrame.Icon:SetSize(16, 16)
    CastingBarFrame.Icon:ClearAllPoints()
    CastingBarFrame.Icon:SetPoint('LEFT', CastingBarFrame, -25, 0)
    CastingBarFrame.Icon:SetTexCoord(.1, .9, .1, .9)

    CastingBarFrame.IconF = CreateFrame('Frame', nil, CastingBarFrame, "BackdropTemplate")
    CastingBarFrame.IconF:SetAllPoints(CastingBarFrame.Icon)

    ns.BD(CastingBarFrame.IconF)
    ns.BUBorder(CastingBarFrame.IconF, 18)

    for i = 1, 4 do
        tinsert(ns.skinbu, CastingBarFrame.IconF.bo[i])
        CastingBarFrame.IconF.bo[i]:SetVertexColor(MODUI_VAR['theme'].r, MODUI_VAR['theme'].g, MODUI_VAR['theme'].b)
    end
    CastingBarFrame.Icon:SetParent(CastingBarFrame.IconF)

    CastingBarFrame.SafeZone = CastingBarFrame:CreateTexture(nil, 'BORDER')
    ns.SB(CastingBarFrame.SafeZone)
    CastingBarFrame.SafeZone:SetVertexColor(.69, .31, .31)


    PetFrame:SetPoint("TOPLEFT", -30, 30)
end

local UpdateCastingBarLatency = function(start, endtime)
    if endtime then
        local width = CastingBarFrame:GetWidth()
        local _, _, _, ms = GetNetStats()
        local x = (ms/1e3)/((endtime/1e3) - (start/1e3))

        if x > 1 then x = 1 end

        CastingBarFrame.SafeZone:SetWidth(width*x)
        CastingBarFrame.SafeZone:ClearAllPoints()
        CastingBarFrame.SafeZone:SetPoint(channel and 'LEFT' or 'RIGHT')
        CastingBarFrame.SafeZone:SetPoint'TOP'
        CastingBarFrame.SafeZone:SetPoint'BOTTOM'
    end
end

local UpdateCastingBarIcon = function(texture)
    if  CastingBarFrame.Spark.offsetY < 1 then
        CastingBarFrame.Icon:ClearAllPoints()
        CastingBarFrame.Icon:SetPoint('LEFT', CastingBarFrame, -25, 0)
    else
        CastingBarFrame.Icon:SetTexture(texture)
        CastingBarFrame.Icon:Show()
        CastingBarFrame.Icon:ClearAllPoints()
        CastingBarFrame.Icon:SetPoint('LEFT', CastingBarFrame, -32, 3)
    end
end

local UpdateCastingBar = function(channel, unit)

    if UnitIsPlayer(unit) then
        seconds = GetTime();
        local  name, _, texture, start, endtime
        if  channel then
            name, _, texture, start, endtime = ChannelInfo()
        else
            name, _, texture, start, endtime = CastingInfo()
        end
        if name then
            UpdateCastingBarLatency(start, endtime, channel)
            UpdateCastingBarIcon(texture)
        end
    end
end

local AddFocusFrame = function()

    FocusFrame.Elite = FocusFrameTextureFrame:CreateTexture(nil, 'BORDER')
    FocusFrame.Elite:SetTexture[[Interface\AddOns\modui_classic\art\unitframe\UI-TargetingFrame-Elite]]
    FocusFrame.Elite:SetSize(128, 128)
    FocusFrame.Elite:SetPoint('TOPRIGHT', FocusFrame)
    FocusFrame.Elite:Hide()

    FocusFrame.Rare = FocusFrameTextureFrame:CreateTexture(nil, 'BORDER')
    FocusFrame.Rare:SetTexture[[Interface\AddOns\modui_classic\art\unitframe\UI-TargetingFrame-Rare-Elite]]
    FocusFrame.Rare:SetSize(128, 128)
    FocusFrame.Rare:SetPoint('TOPRIGHT', FocusFrame)
    FocusFrame.Rare:Hide()


    FocusFrameNameBackground:SetVertexColor(0.0, 0.0, 0.0, 0.5)

    FocusFrameSpellBar.Border:SetVertexColor(MODUI_VAR['theme'].r, MODUI_VAR['theme'].g, MODUI_VAR['theme'].b)

    FocusFrameTextureFramePVPIcon:SetAlpha(0)

    FocusFrameSpellBar.Icon:SetSize(14, 14)
    FocusFrameSpellBar.Icon:ClearAllPoints()
    FocusFrameSpellBar.Icon:SetPoint('LEFT', FocusFrameSpellBar, -25, 0)
    FocusFrameSpellBar.Icon:SetTexCoord(.1, .9, .1, .9)

    FocusFrameSpellBar.IconF = CreateFrame('Frame', nil, FocusFrameSpellBar, "BackdropTemplate")
    FocusFrameSpellBar.IconF:SetAllPoints(FocusFrameSpellBar.Icon)
    ns.BD(FocusFrameSpellBar.IconF, 1,  -2)
    ns.BUBorder(FocusFrameSpellBar.IconF, 16, 16, 5, 5)


    for i = 1, 4 do
        tinsert(ns.skinbu, FocusFrameSpellBar.IconF.bo[i])
        FocusFrameSpellBar.IconF.bo[i]:SetVertexColor(MODUI_VAR['theme'].r, MODUI_VAR['theme'].g, MODUI_VAR['theme'].b)
    end
    FocusFrameSpellBar.Icon:SetParent(FocusFrameSpellBar.IconF)
end



local AddTargetFrame = function()

    for _, v in pairs(
        {
            TargetFrameTextureFrame.HealthBarText,
            TargetFrameTextureFrame.ManaBarText,
        }
        ) do
        v:SetFont(STANDARD_TEXT_FONT, 10, 'OUTLINE')
    end

    TargetFrameNameBackground:Hide()
    TargetFrame.Elite = TargetFrameTextureFrame:CreateTexture(nil, 'BORDER')
    TargetFrame.Elite:SetTexture[[Interface\AddOns\modui_classic\art\unitframe\UI-TargetingFrame-Elite]]
    TargetFrame.Elite:SetSize(128, 128)
    TargetFrame.Elite:SetPoint('TOPRIGHT', TargetFrame)
    TargetFrame.Elite:Hide()

    TargetFrame.Rare = TargetFrameTextureFrame:CreateTexture(nil, 'BORDER')
    TargetFrame.Rare:SetTexture[[Interface\AddOns\modui_classic\art\unitframe\UI-TargetingFrame-Rare-Elite]]
    TargetFrame.Rare:SetSize(128, 128)
    TargetFrame.Rare:SetPoint('TOPRIGHT', TargetFrame)
    TargetFrame.Rare:Hide()

    TargetFrameSpellBar.Border:SetVertexColor(MODUI_VAR['theme'].r, MODUI_VAR['theme'].g, MODUI_VAR['theme'].b)

    TargetFrameTextureFramePVPIcon:SetAlpha(0)

    TargetFrameSpellBar.Icon:SetSize(14, 14)
    TargetFrameSpellBar.Icon:ClearAllPoints()
    TargetFrameSpellBar.Icon:SetPoint('LEFT', TargetFrameSpellBar, -25, 0)
    TargetFrameSpellBar.Icon:SetTexCoord(.1, .9, .1, .9)

    TargetFrameSpellBar.IconF = CreateFrame('Frame', nil, TargetFrameSpellBar, "BackdropTemplate")
    TargetFrameSpellBar.IconF:SetAllPoints(TargetFrameSpellBar.Icon)
    ns.BD(TargetFrameSpellBar.IconF, 1,  -2)
    ns.BUBorder(TargetFrameSpellBar.IconF, 16, 16, 5, 5)


    for i = 1, 4 do
        tinsert(ns.skinbu, TargetFrameSpellBar.IconF.bo[i])
        TargetFrameSpellBar.IconF.bo[i]:SetVertexColor(MODUI_VAR['theme'].r, MODUI_VAR['theme'].g, MODUI_VAR['theme'].b)
    end
    TargetFrameSpellBar.Icon:SetParent(TargetFrameSpellBar.IconF)
end

local AddToTFrame = function()
    TargetFrameToTPortrait:SetSize(37, 37)
    TargetFrameToTPortrait:SetPoint('TOPLEFT', 5, -5)
end

local AddTargetAura = function(self)
    -- nb: needs update: these are being generated ad-hoc
    for i = 1, MAX_TARGET_BUFFS do
        local n     = 'TargetFrameBuff'..i
        local bu    = _G[n]
        local cd    = _G[n..'Cooldown']

        if  bu and not bu.skinned then
            ns.BUBorder(bu, 20, 20, 3, 4)
            for j = 1, 4 do
                tinsert(ns.skinbu, bu.bo[j])
                bu.bo[j]:SetVertexColor(MODUI_VAR['theme'].r, MODUI_VAR['theme'].g, MODUI_VAR['theme'].b)
            end

            cd:SetHideCountdownNumbers(false)

            local t = cd:GetRegions()
            t:SetFont(STANDARD_TEXT_FONT, 7, 'OUTLINE')
            t:ClearAllPoints()
            t:SetPoint('CENTER', cd, 'BOTTOM', 0, 3)
            bu.skinned = true
        end
    end
    for i = 1, MAX_TARGET_DEBUFFS do
        local n     = 'TargetFrameDebuff'..i
        local bu    = _G[n]
        local cd    = _G[n..'Cooldown']

        if  bu and not bu.skinned then
            ns.BUBorder(bu, 20, 20, 3, 4)
            cd:SetHideCountdownNumbers(false)

            local t = cd:GetRegions()
            t:SetFont(STANDARD_TEXT_FONT, 7, 'OUTLINE')
            t:ClearAllPoints()
            t:SetPoint('CENTER', cd, 'BOTTOM', 0, 3)
            bu.skinned = true
        end
    end



    for i = 1, MAX_TARGET_BUFFS do
        local n     = 'FocusFrameBuff'..i
        local bu    = _G[n]
        local cd    = _G[n..'Cooldown']

        if  bu and not bu.skinned then
            ns.BUBorder(bu, 20, 20, 3, 4)
            for j = 1, 4 do
                tinsert(ns.skinbu, bu.bo[j])
                bu.bo[j]:SetVertexColor(MODUI_VAR['theme'].r, MODUI_VAR['theme'].g, MODUI_VAR['theme'].b)
            end

            cd:SetHideCountdownNumbers(false)

            local t = cd:GetRegions()
            t:SetFont(STANDARD_TEXT_FONT, 7, 'OUTLINE')
            t:ClearAllPoints()
            t:SetPoint('CENTER', cd, 'BOTTOM', 0, 3)
            bu.skinned = true
        end
    end
    for i = 1, MAX_TARGET_DEBUFFS do
        local n     = 'FocusFrameDebuff'..i
        local bu    = _G[n]
        local cd    = _G[n..'Cooldown']

        if  bu and not bu.skinned then
            ns.BUBorder(bu, 20, 20, 3, 4)
            cd:SetHideCountdownNumbers(false)

            local t = cd:GetRegions()
            t:SetFont(STANDARD_TEXT_FONT, 7, 'OUTLINE')
            t:ClearAllPoints()
            t:SetPoint('CENTER', cd, 'BOTTOM', 0, 3)
            bu.skinned = true
        end
    end

end

local AddAuraDuration = function(self)
    AddTargetAura(self)
end

local UpdateTargetNameClassColour = function()
    TargetFrameNameBackground:SetVertexColor(0.0, 0.0, 0.0, 0.5)
    FocusFrameNameBackground:SetVertexColor(0.0, 0.0, 0.0, 0.5)
end

local UpdatePartyTextClassColour = function()
    for i = 1, MAX_PARTY_MEMBERS do
        local name = _G['PartyMemberFrame'..i..'Name']
        name:SetTextColor(1, .8, 0)
    end
end

local CheckClassification = function(self)

    local classification = UnitClassification(self.unit)

    for _, v in pairs(
        {
            self.Elite,
            self.Rare
        }
        ) do
        v:Hide()
    end

    self.borderTexture:SetTexture[[Interface\TargetingFrame\UI-TargetingFrame]]

    if  classification == 'worldboss' or classification == 'elite' or classification == 'rareelite' then
        self.Elite:Show()
    elseif classification == 'rare' then
        self.Rare:Show()
    end
end

local UpdateToT = function(self, elapsed)
    local _, class = UnitClass'targettarget'
    local colour = RAID_CLASS_COLORS[class]
    local name   = UnitName'targettarget'

    TargetFrameToTTextureFrameName:SetTextColor(1, .8, 0)

    TargetFrameToTTextureFrameName:ClearAllPoints()
    TargetFrameToTTextureFrameName:SetPoint('BOTTOMLEFT', TargetFrameToTTextureFrame, 49, 0)
end

local true_format = function(value)
    if value > 1e7 then
        return (math.floor(value / 1e6)) .. 'm'
    elseif value > 1e6 then
        return (math.floor((value / 1e6) * 10) / 10) .. 'm'
    elseif value > 1e4 then
        return (math.floor(value / 1e3)) .. 'k'
    elseif value > 1e3 then
        return (math.floor((value / 1e3) * 10) / 10) .. 'k'
    else
        return value
    end
end

local New_TextStatusBar_UpdateTextStringWithValues = function(statusFrame, textString, value, valueMin, valueMax)
    local value = statusFrame.finalValue or statusFrame:GetValue();
    local unit = statusFrame.unit

    if (statusFrame.LeftText and statusFrame.RightText) then
        statusFrame.LeftText:SetText("");
        statusFrame.RightText:SetText("");
        statusFrame.LeftText:Hide();
        statusFrame.RightText:Hide();
    end

    if ((tonumber(valueMax) ~= valueMax or valueMax > 0) and not (statusFrame.pauseUpdates)) then
        statusFrame:Show();

        if ((statusFrame.cvar and GetCVar(statusFrame.cvar) == "1" and statusFrame.textLockable) or statusFrame.forceShow) then
            textString:Show();
        elseif (statusFrame.lockShow > 0 and (not statusFrame.forceHideText)) then
            textString:Show();
        else
            textString:SetText("");
            textString:Hide();
            return ;
        end

        local valueDisplay = value;
        local valueMaxDisplay = valueMax;

        local textDisplay = GetCVar("statusTextDisplay");
        if (value and valueMax > 0 and ((textDisplay ~= "NUMERIC" and textDisplay ~= "NONE") or statusFrame.showPercentage) and not statusFrame.showNumeric) then
            if (value == 0 and statusFrame.zeroText) then
                textString:SetText(statusFrame.zeroText);
                statusFrame.isZero = 1;
                textString:Show();
            elseif (textDisplay == "BOTH" and not statusFrame.showPercentage) then
                if (statusFrame.LeftText and statusFrame.RightText) then
                    if (not statusFrame.powerToken or statusFrame.powerToken == "MANA") then
                        statusFrame.LeftText:SetText(mceil((value / valueMax) * 100) .. "%");
                        statusFrame.LeftText:Show();
                    end
                    statusFrame.RightText:SetText(valueDisplay);
                    statusFrame.RightText:Show();
                    textString:Hide();
                else
                    valueDisplay = "(" .. mceil((value / valueMax) * 100) .. "%) " .. valueDisplay .. " / " .. valueMaxDisplay;
                end
                textString:SetText(valueDisplay);
            else
                valueDisplay = mceil((value / valueMax) * 100) .. "%";
                if (statusFrame.prefix and (statusFrame.alwaysPrefix or not (statusFrame.cvar and GetCVar(statusFrame.cvar) == "1" and statusFrame.textLockable))) then
                    textString:SetText(statusFrame.prefix .. " " .. valueDisplay);
                else
                    textString:SetText(valueDisplay);
                end
            end
        elseif (value == 0 and statusFrame.zeroText) then
            textString:SetText(statusFrame.zeroText);
            statusFrame.isZero = 1;
            textString:Show();
            return ;
        else
            statusFrame.isZero = nil;
            if (statusFrame.prefix and (statusFrame.alwaysPrefix or not (statusFrame.cvar and GetCVar(statusFrame.cvar) == "1" and statusFrame.textLockable))) then
                textString:SetText(statusFrame.prefix .. " " .. valueDisplay .. " / " .. valueMaxDisplay);
            else
                if (value > 1e5) then
                    textString:SetFormattedText("%s || %.0f%%", true_format(value), 100 * value / valueMax);
                else
                    textString:SetText(value)
                end
            end
        end
    elseif unit and UnitIsDeadOrGhost(unit) then
        textString:SetText("")
    else
        textString:Hide();
        textString:SetText("");
        if (not statusFrame.alwaysShow) then
            statusFrame:Hide();
        else
            statusFrame:SetValue(0);
        end
    end
end

local function OnEvent(self, event, unit)
    if  event == 'PLAYER_LOGIN' then
        AddPlayerFrame()
        AddTargetFrame()
        AddToTFrame()
        AddFocusFrame()
        hooksecurefunc('TargetFrame_CheckClassification', CheckClassification)
        hooksecurefunc('TargetFrame_UpdateAuras', AddAuraDuration)
        hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", New_TextStatusBar_UpdateTextStringWithValues)
    end

    if  event == 'UNIT_SPELLCAST_START' or event == 'UNIT_SPELLCAST_CHANNEL_START' then
        UpdateCastingBar(event == 'UNIT_SPELLCAST_CHANNEL_START' and true or false, unit)
    end

    UpdateTargetNameClassColour()
end

local  e = CreateFrame'Frame'
for _, v in pairs(events) do e:RegisterEvent(v) end
e:SetScript('OnEvent', OnEvent)

hooksecurefunc("PlayerFrame_UpdateStatus", function()
    if IsResting("player") then
        PlayerStatusTexture:Hide()
        PlayerRestIcon:Hide()
        PlayerRestGlow:Hide()
        PlayerStatusGlow:Hide()
    elseif PlayerFrame.inCombat then
        PlayerStatusTexture:Hide()
        PlayerAttackIcon:Hide()
        PlayerRestIcon:Hide()
        PlayerAttackGlow:Hide()
        PlayerRestGlow:Hide()
        PlayerStatusGlow:Hide()
        PlayerAttackBackground:Hide()
    end
end)

PlayerFrameGroupIndicator:HookScript("OnShow", function(self) self:Hide() end);



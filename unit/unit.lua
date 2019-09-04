
    local _, ns = ...

    local LCD = LibStub'LibClassicDurations'
    LCD:Register'modui'

    local LCMH = LibStub'LibClassicMobHealth-1.0'

    local events = {
        'PLAYER_LOGIN',
        'GROUP_ROSTER_UPDATE',
        'PLAYER_TARGET_CHANGED',
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
        for _, v in pairs(
            {
                PlayerFrameHealthBar,
                PlayerFrameManaBar
            }
        ) do
            --ns.SB(v)
        end
        if  not PlayerFrame.bg then
            local _, class  = UnitClass'player'
            local colour    = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
            PlayerFrame.bg = PlayerFrame:CreateTexture()
            PlayerFrame.bg:SetPoint('TOPLEFT', PlayerFrameBackground)
            PlayerFrame.bg:SetPoint('BOTTOMRIGHT', PlayerFrameBackground, 0, 22)
            PlayerFrame.bg:SetTexture[[Interface/AddOns/modui_classic/art/statusbar/namebg.tga]]
            PlayerFrame.bg:SetVertexColor(colour.r, colour.g, colour.b)
        end

        PlayerPVPIcon:SetSize(48, 48)
        PlayerPVPIcon:ClearAllPoints()
        PlayerPVPIcon:SetPoint('CENTER', PlayerFrame, 'LEFT', 60, 16)

        if  MODUI_VAR['elements']['unit'].castbar then
            CastingBarFrame.Icon:SetSize(16, 16)
            CastingBarFrame.Icon:ClearAllPoints()
            CastingBarFrame.Icon:SetPoint('LEFT', CastingBarFrame, -25, 0)
            CastingBarFrame.Icon:SetTexCoord(.1, .9, .1, .9)

            CastingBarFrame.IconF = CreateFrame('Frame', nil, CastingBarFrame)
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
    		CastingBarFrame.SafeZone:SetPoint'RIGHT'
    		CastingBarFrame.SafeZone:SetPoint'TOP'
    		CastingBarFrame.SafeZone:SetPoint'BOTTOM'
        end
    end

    local UpdateCastingBarLatency = function(start, endtime)
        local width = CastingBarFrame:GetWidth()
        local _, _, _, ms = GetNetStats()
        local x = (ms/1e3)/((endtime/1e3) - (start/1e3))

        if x > 1 then x = 1 end

        CastingBarFrame.SafeZone:SetWidth(width*x)
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

    local UpdateCastingBar = function()
        local _, _, texture, start, endtime = CastingInfo()
        print(start, endtime)
        UpdateCastingBarLatency(start, endtime)
        UpdateCastingBarIcon(texture)
    end

    local UpdateTargetValue = function()
        local v, max, found = LCMH:GetUnitHealth'target'
        local display = GetCVar'statusTextDisplay'
        TextStatusBar_UpdateTextStringWithValues(TargetFrameHealthBar, TargetFrameHealthBarText, v, 0, max)
        if  TargetFrameHealthBar.RightText and display == 'BOTH' and not TargetFrameHealthBar.showPercentage then
            TargetFrameHealthBar.RightText:SetText(v)
        end
    end

    local AddTargetFrame = function()
        for _, v in pairs(
            {
                TargetFrameHealthBar,
                TargetFrameManaBar
            }
        ) do
            --ns.SB(v)
        end

        TargetFrameHealthBar:HookScript('OnValueChanged', UpdateTargetValue)

        TargetFrameNameBackground:SetTexture[[Interface/AddOns/modui_classic/art/statusbar/namebg.tga]]

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

        TargetFrameHealthBarText = TargetFrameTextureFrame:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
        TargetFrameHealthBarText:SetPoint('CENTER', -50, 3)
        TargetFrameHealthBar.TextString = TargetFrameHealthBarText

        TargetFrameHealthBarTextLeft = TargetFrameTextureFrame:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
        TargetFrameHealthBarTextLeft:SetPoint('LEFT', 8, 3)
        TargetFrameHealthBar.LeftText = TargetFrameHealthBarTextLeft

        TargetFrameHealthBarTextRight = TargetFrameTextureFrame:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
        TargetFrameHealthBarTextRight:SetPoint('RIGHT', -110, 3)
        TargetFrameHealthBar.RightText = TargetFrameHealthBarTextRight

        for _, v in pairs(
            {
                TargetFrameHealthBarText,
                TargetFrameHealthBarTextLeft,
                TargetFrameHealthBarTextRight,
            }
        ) do
            v:SetFont(STANDARD_TEXT_FONT, 10, 'OUTLINE')
        end

        TargetFrameTextureFramePVPIcon:SetSize(48, 48)
        TargetFrameTextureFramePVPIcon:ClearAllPoints()
        TargetFrameTextureFramePVPIcon:SetPoint('CENTER', TargetFrame, 'RIGHT', -42, 16)
    end

    local AddToTFrame = function()
        TargetFrameToTPortrait:SetSize(37, 37)
        TargetFrameToTPortrait:SetPoint('TOPLEFT', 5, -5)

        for _, v in pairs(
            {
                TargetFrameToTHealthBar,
                TargetFrameToTManaBar
            }
        ) do
            if  v then
                --ns.SB(v)
            end
        end
    end

    local AddPartyFrame = function()
        for i = 1, 4 do
            for _, v in pairs(
                {
                    _G['PartyMemberFrame'..i..'HealthBar'],
                    _G['PartyMemberFrame'..i..'ManaBar']
                }
            ) do
                --ns.BD(v)
                --ns.SB(v)
            end
        end
    end

    local AddHealthTextColour = function(t, statusbar)
        local min, max = statusbar:GetMinMaxValues()
        local v = statusbar:GetValue()
        ns.GRADIENT_COLOUR(t, v, min, max)
    end

    local AddManaTextColour = function(t, class, powertype)
        if  MODUI_VAR['elements']['unit'].vcolour then
            if class == 'ROGUE' or (class == 'DRUID' and powertype == 3) then
                t:SetTextColor(250/255, 240/255, 200/255)
            elseif class == 'WARRIOR' or (class == 'DRUID' and powertype == 1) then
                t:SetTextColor(250/255, 108/255, 108/255)
            else
                t:SetTextColor(.6, .65, 1)
            end
        else
            t:SetTextColor(1, 1, 1)
        end
    end

    local AddTargetAura = function(self)
        -- nb: needs update: these are being generated ad-hoc
        for i = 1, MAX_TARGET_BUFFS do
            local n     = 'TargetFrameBuff'..i
            local bu    = _G[n]
            local cd    = _G[n..'Cooldown']
            if  bu and not bu.skinned then
                ns.BUBorder(bu, 18, 18, 3, 4)
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
        for i = 1, MAX_TARGET_BUFFS do
            local name, icon, count, dtype, duration, expiration, caster, canstealorpurge, _ , spellid, _, _, isplayer, nameplateshowall = UnitBuff(self.unit, i, nil)
            if  name then
                local n     = self:GetName()..'Buff'..i
                local bu    = _G[n]
                local cd    = _G[n..'Cooldown']

                local duration2, expiration2 = LCD:GetAuraDurationByUnit(self.unit, spellid, caster)
                if  duration == 0 and duration2 then
                    duration    = duration2
                    expiration  = expiration2
                end

                CooldownFrame_Set(cd, expiration - duration, duration, duration > 0, true)
            else
                break
            end
        end

        local num           = 1
        local i             = 1
        local max           = self.maxDebuffs or MAX_TARGET_DEBUFFS
        while num <= max and i <= max do
            local name, icon, count, dtype, duration, expiration, caster, _, _, spellid, _, _, isplayer, nameplates= UnitDebuff(self.unit, i, 'INCLUDE_NAME_PLATE_ONLY')
            if  name then
                if  TargetFrame_ShouldShowDebuffs(self.unit, caster, nameplateshowall, casterisplayer) then
                    local n     = self:GetName()..'Debuff'..num
                    local bu    = _G[n]
                    local cd    = _G[n..'Cooldown']

                    local duration2, expiration2 = LCD:GetAuraDurationByUnit(self.unit, spellid, caster)
                    if  duration == 0 and duration2 then
                        duration    = duration2
                        expiration  = expiration2
                    end

                    CooldownFrame_Set(cd, expiration - duration, duration, duration > 0, true)
                    num = num + 1
                end
            else
                break
            end
            i = i + 1
        end
    end

    local AddPartyPets = function()
        local  var = GetCVar'showPartyPets'
		if not var == '1' then SetCVar('showPartyPets', 1) end
    end

    local UpdateTargetNameClassColour = function()
        if  UnitIsPlayer'target' then
            local _, class  = UnitClass'target'
            local colour    = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
            TargetFrameNameBackground:SetVertexColor(colour.r, colour.g, colour.b)
        end
    end

    local UpdatePartyTextClassColour = function()
        for i = 1, MAX_PARTY_MEMBERS do
            local name = _G['PartyMemberFrame'..i..'Name']
            if  UnitIsPlayer('party'..i) then
                local _, class  = UnitClass('party'..i)
                local colour    = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
                if  colour then
                    name:SetTextColor(colour.r, colour.g, colour.b)
                end
            else
                name:SetTextColor(1, .8, 0)
            end
        end
    end

     local UpdateTextStringColour = function(statusbar)
         local _, class = UnitClass'player'
         local  n = statusbar:GetName()
         for _, t in pairs(
            {
                statusbar.TextString,
                statusbar.LeftText,
                statusbar.RightText,
            }
        ) do
            if  t and n == 'PlayerFrameManaBar' then
                AddManaTextColour(t, class, UnitPowerType'player')
            elseif t and (n == 'PlayerFrameHealthBar'  or n == 'TargetFrameHealthBar') then
                AddHealthTextColour(t, statusbar)
            end
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

        if  UnitIsPlayer'targettarget' then
            TargetFrameToTTextureFrameName:SetTextColor(colour.r, colour.g, colour.b)
        else
            TargetFrameToTTextureFrameName:SetTextColor(1, .8, 0)
        end

        TargetFrameToTTextureFrameName:ClearAllPoints()
        TargetFrameToTTextureFrameName:SetPoint('BOTTOMLEFT', TargetFrameToTTextureFrame, 49, 0)
    end

    local function OnEvent(self, event)
        if  not MODUI_VAR['elements']['unit'].enable then return end

        if  event == 'PLAYER_LOGIN' then
            if  MODUI_VAR['elements']['unit'].player then
                AddPlayerFrame()
            end

            if  MODUI_VAR['elements']['unit'].target then
                AddTargetFrame()
            end

            if  MODUI_VAR['elements']['unit'].tot then
                AddToTFrame()
                -- TargetFrameToT:HookScript('OnUpdate', UpdateToT) tainting i think
            end

            if  MODUI_VAR['elements']['unit'].rcolour then
                hooksecurefunc('TargetFrame_CheckClassification', CheckClassification)
            end

            if  MODUI_VAR['elements']['unit'].vcolour then
                hooksecurefunc('TextStatusBar_UpdateTextString', UpdateTextStringColour)
            end

            if  MODUI_VAR['elements']['unit'].auras then
                hooksecurefunc('TargetFrame_UpdateAuras', AddAuraDuration)
            end
        end

        if  event == 'UNIT_SPELLCAST_START' or event == 'UNIT_SPELLCAST_CHANNEL_START' then
            if  MODUI_VAR['elements']['unit'].castbar then
                UpdateCastingBar()
            end
        end

        if  MODUI_VAR['elements']['unit'].target then
            UpdateTargetNameClassColour()
        end

        if  MODUI_VAR['elements']['unit'].party then
            AddPartyPets()
            if not InCombatLockdown() then UpdatePartyTextClassColour() end
        end
    end

    local  e = CreateFrame'Frame'
    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnEvent', OnEvent)


    --

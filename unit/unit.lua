
    local _, ns = ...

    local events = {
        'PLAYER_LOGIN',
        'GROUP_ROSTER_UPDATE',
        'PLAYER_TARGET_CHANGED',
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
            ns.SB(v)
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
    end


    local AddTargetFrame = function()
        for _, v in pairs(
            {
                TargetFrameHealthBar,
                TargetFrameManaBar
            }
        ) do
            ns.SB(v)
        end

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
                ns.SB(v)
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
            local bu = _G['TargetFrameBuff'..i]
            if  bu and not bu.bo then
                ns.BUBorder(bu, 18, 18, 3, 4)
            end
        end
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
            elseif t and n == 'PlayerFrameHealthBar' then
                AddHealthTextColour(t, statusbar)
            end
        end
     end

     local CheckClassification = function()
         local classification = UnitClassification'target'

         -- this is wigging out for some reason at the minute (unitclassification?) and i cant figure out why :()

         --TargetFrame.borderTexture:SetTexture[[Interface\TargetingFrame\UI-TargetingFrame]]

         TargetFrame.Elite:Hide()
         TargetFrame.Rare:Hide()

         --[[if  classification == 'worldboss' or classification == 'elite' then
             TargetFrame.Elite:Show()
         elseif c == 'rare' then
             TargetFrame.Rare:Show()
         end]]
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
                hooksecurefunc('TargetofTarget_Update', UpdateToT)
            end

            if  MODUI_VAR['elements']['unit'].rcolour then
                CheckClassification()
            end

            if  MODUI_VAR['elements']['unit'].vcolour then
                hooksecurefunc('TextStatusBar_UpdateTextString', UpdateTextStringColour)
            end

            hooksecurefunc('TargetFrame_UpdateAuras', AddTargetAura)
        end

        if  MODUI_VAR['elements']['unit'].target then
            UpdateTargetNameClassColour()
        end

        if  MODUI_VAR['elements']['unit'].party then
            UpdatePartyTextClassColour()
        end
    end

    local  e = CreateFrame'Frame'
    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnEvent', OnEvent)


    --

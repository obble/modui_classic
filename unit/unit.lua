
    local _, ns = ...

    local var   = MODUI_VAR['elements']['unit']

    local events = {
        'GROUP_ROSTER_UPDATE',
        'PLAYER_TARGET_CHANGED',
        'UNIT_FACTION'
    }

    local AddColour = function(bar, unit)
        if  UnitIsPlayer(unit) and UnitIsConnected(unit) and unit == bar.unit and UnitClass(unit) then
            local _, class = UnitClass(unit)
            local colour = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
            bar:SetStatusBarColor(colour.r, colour.g, colour.b)
        end
    end

    for _, t in pairs(
        {
            TargetFrameNameBackground,
            --FocusFrameNameBackground
        }
    ) do
        t:SetTexture[[Interface/AddOns/modui_classic/art/statusbar/namebg.tga]]
    end

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
            PlayerFrame.bg:SetTexture(TargetFrameNameBackground:GetTexture())
            PlayerFrame.bg:SetVertexColor(colour.r, colour.g, colour.b)
        end
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
        if  UnitIsPlayer'target' then
            local _, class  = UnitClass'target'
            local colour    = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
            TargetFrameNameBackground:SetVertexColor(colour.r, colour.g, colour.b)
        end

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
    end

    local AddToTFrame = function()
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
        if  var.vcolour then
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

     local UpdateTextString = function(statusbar)
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
         if not var.rcolour then return end
         local c = UnitClassification'target'

         TargetFrame.borderTexture:SetTexture[[Interface\TargetingFrame\UI-TargetingFrame]]

         for _, v in pairs(
            {
                TargetFrame.Elite,
                TargetFrame.Rare
            }
        ) do
            v:Hide()
        end

        if  c == 'worldboss' or c == 'rareelite' or c == 'elite' then
            TargetFrame.Elite:Show()
        elseif c == 'rare' then
            TargetFrame.Rare:Show()
        end
    end

    local function OnEvent(self, event)
        AddPlayerFrame()
        AddTargetFrame()
        AddToTFrame()
    end

    local  e = CreateFrame'Frame'
    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnEvent', OnEvent)

    hooksecurefunc('TextStatusBar_UpdateTextString',    UpdateTextString)
    hooksecurefunc('TargetFrame_CheckClassification',   CheckClassification)
    hooksecurefunc('TargetFrame_UpdateAuras',           AddTargetAura)

    -- hooksecurefunc('UnitFrameHealthBar_Update', colour)
    --hooksecurefunc('HealthBar_OnValueChanged', function(self) AddColour(self, self.unit) end)

    --

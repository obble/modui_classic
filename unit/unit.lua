
    local _, ns = ...

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

    local function OnEvent(self, event)
        AddPlayerFrame()
        AddTargetFrame()
        AddToTFrame()
    end

    local  e = CreateFrame'Frame'
    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnEvent', OnEvent)

    -- hooksecurefunc('UnitFrameHealthBar_Update', colour)
    --hooksecurefunc('HealthBar_OnValueChanged', function(self) AddColour(self, self.unit) end)

    --


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
        ns.SB(t)
    end

    local function OnEvent(self, event)
        if  UnitIsPlayer'target' then
            local _, class  = UnitClass'target'
            local colour    = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
            TargetFrameNameBackground:SetVertexColor(colour.r, colour.g, colour.b)
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

    local  e = CreateFrame'Frame'
    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnEvent', OnEvent)

    -- hooksecurefunc('UnitFrameHealthBar_Update', colour)
    --hooksecurefunc('HealthBar_OnValueChanged', function(self) AddColour(self, self.unit) end)

    --

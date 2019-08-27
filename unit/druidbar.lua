
    local _, ns = ...

    local events = {
        'PLAYER_LOGIN',
        'UNIT_POWER_UPDATE',
        'UPDATE_SHAPESHIFT_FORM',
    }

    local AddDruidBar = function()
        local mana = PowerBarColor['MANA']

        local bar = CreateFrame('StatusBar', 'modui_druidbar', PlayerFrame)
        ns.SB(bar)
        bar:SetSize(118, 8)
        bar:SetPoint('TOPLEFT', PlayerFrame, 'TOPLEFT', 107, -66)
        bar:SetStatusBarColor(mana.r, mana.g, mana.b)

        bar.border = CreateFrame('Frame', nil, UIParent)
        bar.border:SetSize(258, 33)
        bar.border:SetPoint('TOPLEFT', PlayerFrame, 'TOPLEFT', 100, -62)

        bar.border.t = bar.border:CreateTexture(nil, 'BACKGROUND')
        bar.border.t:SetAllPoints(bar.border)
        bar.border.t:SetTexture[[Interface\AddOns\modui_classic\art\unitframe\border]]
        tinsert(ns.skin, bar.border.t)

        bar.background = CreateFrame('Frame', nil, PlayerFrame)
        bar.background:SetSize(258, 33)
        bar.background:SetPoint('TOPLEFT', PlayerFrame, 'TOPLEFT', 100, -62)

        bar.background.t = bar.background:CreateTexture(nil, 'BACKGROUND')
        bar.background.t:SetAllPoints(bar.background)
        bar.background.t:SetTexture[[Interface\AddOns\modui_classic\art\unitframe\background]]
        tinsert(ns.skin, bar.background.t)
    end

    local UpdatePower = function(self)
        self:SetMinMaxValues(0, UnitPowerMax('player', 0))
        self:SetValue(UnitPower('player', 0))
    end

    local ToggleDruidBar = function(self)
        local _, class = UnitClass'player'
        local form = GetShapeshiftForm()
        self:Hide()
        self.border:Hide()
        self.background:Hide()
        if  class == 'DRUID' and (form == 1 or form == 3) then
            self:Show()
            self.border:Show()
            self.background:Show()
        end
    end

    local OnEvent = function(self, event, ...)
        if  event == 'PLAYER_LOGIN' then
            AddDruidBar()
            ToggleDruidBar(_G['modui_druidbar'])
        elseif event == 'UNIT_POWER_UPDATE' then
            local bar = _G['modui_druidbar']
            if bar then UpdatePower(bar) end
        elseif event == 'UPDATE_SHAPESHIFT_FORM' then
            local bar = _G['modui_druidbar']
            if bar then ToggleDruidBar(bar) end
        end
    end

    local  e = CreateFrame'Frame'
    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnEvent', OnEvent)


    --

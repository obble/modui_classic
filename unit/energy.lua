
    local _, ns = ...

    local _, class = UnitClass'player'
    if not (class == 'ROGUE' or class == 'DRUID') then return end

    local events = {
        'PLAYER_LOGIN',
        'PLAYER_REGEN_DISABLED',
        'PLAYER_REGEN_ENABLED',
    }

    local last_tick  = GetTime()
    local last_value = 0

    local SetEnergyValue = function(self, value)
        local x         = self:GetWidth()
        local v, max  = UnitPower'player', UnitPowerMax'player'
        local type      = UnitPowerType'player'

	if  type ~= Enum.PowerType.Energy then
		self.energy.spark:Hide()
	else
		local position = (x*value)/2
		self.energy.spark:Show()
		self.energy.spark:SetPoint('CENTER', self, 'LEFT', position, 0)
	end

    end

    local UpdateEnergy = function(self, unit)
        local energy = UnitPower('player', Enum.PowerType.Energy)
        local time  = GetTime()
    	local v = time - last_tick

    	if  energy > last_value or time >= last_tick + 2 then
    		last_tick = time
    	end

    	SetEnergyValue(self:GetParent(), v)

    	last_value = energy
    end

    local AddEnergy = function()
        PlayerFrameManaBar.energy = CreateFrame('Statusbar', 'PlayerFrameManaBar_modui_energy', PlayerFrameManaBar)

        PlayerFrameManaBar.energy.spark = PlayerFrameManaBar.energy:CreateTexture(nil, 'OVERLAY')
        PlayerFrameManaBar.energy.spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
        PlayerFrameManaBar.energy.spark:SetSize(32, 32)
        PlayerFrameManaBar.energy.spark:SetPoint('CENTER', PlayerFrameManaBar, 0, 0)
        PlayerFrameManaBar.energy.spark:SetBlendMode'ADD'
        PlayerFrameManaBar.energy.spark:SetAlpha(.4)

        PlayerFrameManaBar.energy:RegisterEvent'UNIT_POWER_UPDATE'
		PlayerFrameManaBar.energy:SetScript('OnUpdate', UpdateEnergy)
    end

    local ToggleCombat = function(alpha)
        PlayerFrameManaBar.energy.spark:SetAlpha(alpha)
    end

    local OnEvent = function(self, event, ...)
        if event == 'PLAYER_LOGIN' then
            AddEnergy()
        elseif event == 'PLAYER_REGEN_DISABLED' then
            ToggleCombat(1)
        elseif event == 'PLAYER_REGEN_ENABLED' then
            ToggleCombat(.3)
        end
    end

    local  e = CreateFrame'Frame'
    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnEvent', OnEvent)


    --

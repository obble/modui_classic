
    local _, ns = ...

    local _, class = UnitClass'player'
    if not (class == 'ROGUE' or class == 'DRUID') then return end

    local events = {
        'PLAYER_LOGIN',
        'UNIT_DISPLAYPOWER',
        'PLAYER_REGEN_DISABLED',
        'PLAYER_REGEN_ENABLED',
        'UNIT_POWER_UPDATE',
    }

    local lastEnergyValue       = 0     -- The energy value after the last regen pulse.
    local currentEnergyValue    = 0     -- The current energy value at the time of the current regen pulse.
    local preLastPulseTime      = 2     -- Time of the second to last regen pulse.
    local lastPulseTime         = 2     -- Time of the last regen pulse.
    local pulseTotal            = 0     -- Total time of all regen pulse gaps > 2.0.
    local pulseCount            = 0     -- Total number of regen pulses > 2.0.
    local syncNextUpdate        = false -- True if a regen pulse just ocurred and energy value will sync next frame.

    local OnUpdate = function()
        local energy = _G['PlayerFrameManaBar_modui_energy']
        local spark  = energy.spark
        if  syncNextUpdate then
            local v = mod((GetTime() - lastPulseTime), 2)
            spark:SetPoint('CENTER', energy, 'LEFT', (energy:GetWidth()*(v/2)), 0)

            local nextPulseTotalAddition = (lastPulseTime - preLastPulseTime)
            if ((nextPulseTotalAddition > 2) and (nextPulseTotalAddition < 2.5)) then
                pulseTotal = pulseTotal + (lastPulseTime - preLastPulseTime)
                pulseCount = (pulseCount + 1)

                -- -- TEST BLOCK ---------------------------
                -- print('Sync update just ocurred')
                -- print('time to be added to total: ' .. (lastPulseTime - preLastPulseTime))
                -- print('pulseTotal: '.. pulseTotal)
                -- print('pulseCount: ' .. pulseCount)
                -- print('pulseAverage: ' .. pulseTotal / pulseCount)
                -- -- END TESTBLOCK ------------------------
            end
            syncNextUpdate = false
        else
            if  pulseCount == 0 then
                local v = mod((GetTime() - lastPulseTime), 2.0)
                spark:SetPoint('CENTER', energy, 'LEFT', (energy:GetWidth()*(v/2)), 0)
            else
                local v = mod((GetTime() - lastPulseTime), (pulseTotal / pulseCount))
                spark:SetPoint('CENTER', energy, 'LEFT', (energy:GetWidth()*(v/(pulseTotal/pulseCount))), 0)

                if ((GetTime() - lastPulseTime) > 120) then
                    energy:Hide()
                end

                -- -- TEST BLOCK ---------------------------
                -- print('running average mode')
                -- print('pulseTotal: '.. pulseTotal)
                -- print('pulseCount: ' .. pulseCount)
                -- print('pulseAverage: ' .. pulseTotal / pulseCount)
                -- -- END TESTBLOCK ------------------------
            end
        end
    end

    local AddEnergy = function()
        local energy = CreateFrame('Statusbar', 'PlayerFrameManaBar_modui_energy', PlayerFrameManaBar)
        energy:SetAllPoints()
        energy:Hide()

        energy.spark = energy:CreateTexture(nil, 'OVERLAY')
        energy.spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
        energy.spark:SetSize(32, 32)
        energy.spark:SetBlendMode'ADD'
        energy.spark:SetAlpha(.4)
    end

    local ShowEnergy = function(show)
        local energy = _G['PlayerFrameManaBar_modui_energy']
        if show then energy:Show() else energy:Hide() end
    end

    local ToggleCombat = function(alpha)
        local energy = _G['PlayerFrameManaBar_modui_energy']
        energy.spark:SetAlpha(alpha)
    end

    local UpdateEnergy = function(unit)
        if  unit == 'player' then
            local energy = _G['PlayerFrameManaBar_modui_energy']
            currentEnergyValue = UnitPower'player'
            if  currentEnergyValue == lastEnergyValue + 20 then
                preLastPulseTime = lastPulseTime
                lastPulseTime = GetTime()
                syncNextUpdate = true
                energy:Show()
            end
            lastEnergyValue = currentEnergyValue
        end
    end

    local OnEvent = function(self, event, ...)
        if event == 'PLAYER_LOGIN' then
            AddEnergy()
        elseif event == 'PLAYER_REGEN_DISABLED' then
            ToggleCombat(1)
        elseif event == 'PLAYER_REGEN_ENABLED' then
            ToggleCombat(.3)
        elseif event == 'UNIT_DISPLAYPOWER' then
            local _, power  = UnitPowerType'player'
            if  power == 'ENERGY' then
                ShowEnergy(true)
            else
                ShowEnergy(false)
            end
        else
            UpdateEnergy(...)
        end
    end

    local  e = CreateFrame'Frame'
    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnUpdate', OnUpdate)
    e:SetScript('OnEvent', OnEvent)


    --



    local _, ns = ...

    -- TODO: hide/alpha elements based on totem (without taint)
    -- find way to accurately get duration, icon, UnitAura-like details..
    -- we have the old private server table if we have to, but lets not if possible....
    -- extrapolate totem table for player totem tracking.

    local events = {
        'NAME_PLATE_UNIT_ADDED',
        'UNIT_AURA'
    }

    local totems = {
        ['Grounding']         = {
                                    time = 45,
                                    type = 'Earth'
                                },
        ['Earthbind']         = {
                                    time = 45,
                                    type = 'Earth'
                                },
        ['Stoneclaw']         = {
                                    time = 15,
                                    type = 'Earth',
                                },
        ['Strength of Earth'] = {
                                    time = 120,
                                    type = 'Earth'
                                },
        ['Stoneskin']         = {
                                    time = 120,
                                    type = 'Earth'
                                    },
        ['Tremor']            = {
                                    time = 120,
                                    type = 'Earth'
                                },
            --
        ['Fire Nova']         = {
                                    time = 5,
                                    type = 'Fire'
                                },
        ['Flametongue']       = {
                                    time = 120,
                                    type = 'Fire'
                                },
        ['Frost Resistance']  = {
                                    time = 120,
                                    type = 'Fire'
                                },
        ['Magma']             = {
                                    time = 20,
                                    type = 'Fire'
                                },
        ['Searing']           = {
                                    time = 55,
                                    type = 'Fire',
                                },
            --
        ['Grace of Air']      = {
                                    time = 120,
                                    type = 'Air'
                                },
        ['Nature Resistance'] = {
                                    time = 120,
                                    type = 'Air'
                                },
        ['Sentry']            = {
                                    time = 300,
                                    type = 'Air'
                                },
        ['Tranquil Air']      = {
                                    time = 120,
                                    type = 'Air'
                                },
        ['Windfury']          = {
                                    time = 120,
                                    type = 'Air'
                                },
        ['Windwall']          = {
                                    time = 120,
                                    type = 'Air'
                                },
            --
        ['Disease Cleansing'] = {
                                    time = 120,
                                    type = 'Water'
                                },
        ['Fire Resistance']   = {
                                    time = 120,
                                    type = 'Water'
                                },
        ['Healing Stream']    = {
                                    time = 60,
                                    type = 'Water'
                                },
        ['Mana Spring']       = {
                                    time = 60,
                                    type = 'Water'
                                },
        ['Mana Tide']         = {
                                    time = 12,
                                    type = 'Water'
                                },
        ['Poison Cleansing']  = {
                                    time = 120,
                                    type = 'Water'
                                },
        ['Ancient Mana Spring'] = {
                                    time = 24,
                                    type = 'Water'
                                },
    }

    local CreateTotem = function(plate)
        if  not plate.totem then
            plate.totem = CreateFrame('Button', nil, plate)
            plate.totem:SetPoint('BOTTOM', plate)
            ns.BUBorder(plate.totem, 14, 14, 2)
            ns.BD(plate.totem)

            plate.totem.icon = plate.totem:CreateTexture(nil, 'ARTWORK')
            plate.totem.icon:SetAllPoints()
            plate.totem.icon:SetTexCoord(.1, .9, .15, .85)

            plate.totem.cooldown = CreateFrame('Cooldown', nil, plate.totem, 'CooldownFrameTemplate')
            plate.totem.cooldown:SetAllPoints()
            plate.totem.cooldown:SetReverse(true)
            plate.totem.cooldown:SetHideCountdownNumbers(true)
        end
    end

    local TogglePlate = function(plate, show)
        if  plate.healthBar then
            plate.healthBar:SetStatusBarTexture(show and 'Interface//TargetingFrame//UI-TargetingFrame-BarFill' or nil)
            plate.healthBar.border:SetAlpha(show and 1 or 0)
            plate.healthBar.background:SetAlpha(show and 1 or 0)
        end
        for _, v in pairs(
            {
                plate.name,
                plate.LevelFrame,
                plate.selectionHighlight,
            }
        ) do
            v:SetAlpha(show and 1 or 0)
        end
    end

    local UpdateTotem = function(plate, unit)
        local n = gsub(UnitName(unit), '(.+) Totem', '%1')
        if  totems[n] then
            plate.totem:Show()
            SetPortraitTexture(plate.totem.icon, unit)
            CooldownFrame_Set(plate.totem.cooldown, GetTime(), totems[n].time, totems[n].time > 0, true)
            TogglePlate(plate, false)
        else
            plate.totem:Hide()
            TogglePlate(plate, true)
        end
    end

    local OnEvent = function(_, event, unit)
        local  plate = C_NamePlate.GetNamePlateForUnit(unit)
        if not plate then return end
        if  event == 'NAME_PLATE_UNIT_ADDED' then
            CreateTotem(plate)
        end
        UpdateTotem(plate, unit)
    end

    local  e = CreateFrame'Frame'
    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnEvent', OnEvent)


    --

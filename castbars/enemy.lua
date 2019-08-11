

    local _, ns     = ...

    local build = tonumber(string.sub(GetBuildInfo() , 1, 2))
    -- if build > 1 then return end -- BfA dont need this

    -- TODO: level check against parented unit UnitLevel for cast-time?

    local GUIDs             = {}
    local timer             = {}
    local frames            = {}
    local pool              = {}
    local anchors           = {}
    local created  = 0
    local active   = 0
    local FONT_REGULAR = ns.FONT_REGULAR

    local f = CreateFramePool(
        'Statusbar',
        UIParent,
        'SmallCastingBarFrameTemplate',
        function(pool, frame)
            frame:Hide()
            frame:SetParent(nil)
            frame:ClearAllPoints()

            if  frame._data then
                frame._data = nil
            end
        end
    )

    local e = CreateFrame'Frame'

    local InitializeNewFrame = function(frame)
        frame.Border:ClearAllPoints()
        frame.Icon:ClearAllPoints()
        frame.Text:ClearAllPoints()
        frame.Icon:SetPoint('LEFT', frame, -35, 0)
        frame.Text:SetPoint'CENTER'
        frame.Flash:SetAlpha(0)

        frame:SetScript('OnLoad', nil)
        frame:SetScript('OnEvent', nil)
        frame:SetScript('OnUpdate', nil)
        frame:SetScript('OnShow', nil)

        frame.Timer = frame:CreateFontString(nil, 'OVERLAY')
        frame.Timer:SetTextColor(1, 1, 1)
        frame.Timer:SetFontObject'SystemFont_Shadow_Small'
    end

    local GetAnchor = function(unit, default)
        if  string.find(unit, 'nameplate') then
            return C_NamePlate.GetNamePlateForUnit(unit)
        elseif string.match(unit, 'target') then
            return TargetFrame
        end
    end

    local SetTargetCastbarPosition = function(castbar, parent)
        -- Set position based on aura amount & targetframe type
        local rows = parent.auraRows or 0
        if parent.haveToT or parent.haveElite then
            if  parent.buffsOnTop or rows <= 1 then
                castbar:SetPoint('CENTER', TargetFrame, -8, -75)
            else
                castbar:SetPoint('CENTER', TargetFrame, -8, -100)
            end
        else
            if  not parent.buffsOnTop and rows > 0 then
                castbar:SetPoint('CENTER', TargetFrame, -8, -100)
            else
                castbar:SetPoint('CENTER', TargetFrame, -8, -50)
            end
        end
    end

    local SetCastbarIconAndText = function(castbar, cast)
        --name = cast.rank and cast.name..' ('..cast.rank..')' or cast.name
        name = cast.name
        -- Update text + icon if it has changed
        if  castbar.Text:GetText() ~= name then
            castbar.Icon:SetTexture(cast.icon)
            castbar.Text:SetText(name)
            castbar.Timer:SetPoint('RIGHT', castbar, 23, 0)
        end
    end

    local SetCastbarStyle = function(castbar, cast, db)
        castbar:SetSize(150, 14)
        castbar.Timer:SetShown(true)
        ns.SB(castbar)

        castbar.Spark:SetAlpha(1)

        castbar.Icon:SetSize(16, 16)
        castbar.Icon:SetPoint('LEFT', castbar, -25, 0)
        castbar.Icon:SetTexCoord(.1, .9, .1, .9)

        if not castbar.IconBorder then
            castbar.IconBorder = CreateFrame('Frame', nil, castbar)
            castbar.IconBorder:SetAllPoints(castbar.Icon)
            ns.BD(castbar.IconBorder)
            ns.BUBorder(castbar.IconBorder, 18)
            castbar.Icon:SetParent(castbar.IconBorder)
        end

        castbar.Text:SetFont(FONT_REGULAR, 9)
        castbar.Timer:SetFont(FONT_REGULAR, 9)

        castbar.Border:SetAlpha(1)

        if  castbar.BorderFrame then -- unneccesary?
            castbar.BorderFrame:SetAlpha(0)
        end

        -- Update border to match castbar size
        local width, height = castbar:GetWidth()*1.16, castbar:GetHeight()*1.16
        castbar.Border:SetPoint("TOPLEFT", width, height)
        castbar.Border:SetPoint("BOTTOMRIGHT", -width, -height)
    end

    local DisplayCastbar = function(castbar, unit)
        local  parent = GetAnchor(unit)
        if not parent then return end -- sanity check

        local cast = castbar._data
        castbar:SetMinMaxValues(0, cast.max)
        castbar:SetParent(parent)

        if  unit == 'target' then
            SetTargetCastbarPosition(castbar, parent)
            castbar:SetScale(1)
        else
            castbar:SetPoint('CENTER', parent, -6, -35) -- -5.5 x position?
            castbar:SetScale(.7)
        end

        SetCastbarStyle(castbar, cast)
        SetCastbarIconAndText(castbar, cast)

        castbar:SetAlpha(1)
        castbar:Show()
    end

    local AcquireFrame = function()
        if  created >= 300 then return end -- should never happen

        local frame, isNew = f:Acquire()
        active = active + 1

        if  isNew then
            frame:Hide()
            InitializeNewFrame(frame)

            created = created + 1
            -- frame._data = {}
        end

        return frame, isNew, created
    end

    local ReleaseFrame = function(frame)
        if  frame then
            f:Release(frame)
            active = active - 1
        end
    end

    local GetFramePool = function()
        return pool
    end

    local GetCastbarFrame = function(unit)
        -- pool:DebugInfo()

        if  frames[unit] then
            return frames[unit]
        end

        -- store reference, refs are deleted on frame recycled.
        -- This allows us to not have to Release & Acquire a frame everytime a
        -- castbar is shown/hidden for the *same* unit
        frames[unit] = AcquireFrame()

        return frames[unit]
    end

    local FadeOut = function(self)
        local a = self:GetAlpha() - CASTING_BAR_ALPHA_STEP
        if  a > 0 then
            CastingBarFrame_ApplyAlpha(self, a)
        else
            self.fade = nil
            self:Hide()
            self:SetScript('OnUpdate', nil)
        end
    end

    local StartCast = function(GUID, unit)
        if not timer[GUID] then return end

        local  castbar = GetCastbarFrame(unit)
        if not castbar then return end

        castbar._data = timer[GUID]
        DisplayCastbar(castbar, unit)
    end

    local StopCast = function(unit, hide)
        local  castbar = frames[unit]
        if not castbar then return end
        castbar._data = nil
        if  castbar.fade and not hide then
            --C_Timer.After(1, function() castbar:SetScript('OnUpdate', FadeOut) end)
            castbar:Hide()
        end
    end

    local StartAllCasts = function(GUID)
        if not timer[GUID] then return end
        for unit, guid in pairs(GUIDs) do
            if  guid == GUID then
                StartCast(guid, unit)
            end
        end
    end

    local StopAllCasts = function(GUID)
        for unit, guid in pairs(GUIDs) do
            if  guid == GUID then
                if  frames[unit] then
                    frames[unit].fade = true
                end
                StopCast(unit)
            end
        end
    end

    local StoreCast = function(GUID, name, icon, time, rank, channeled)
        timer[GUID] = {
            name        = name,
            rank        = rank,
            icon        = icon,
            max         = time/1000,
            endTime     = GetTime() + (time/1000),
            GUID        = GUID,
            channeled   = channeled,
        }

        StartAllCasts(GUID)
    end

    local DeleteCast = function(GUID)
        if  GUID then
            StopAllCasts(GUID)
            timer[GUID] = nil
        end
    end

    local CastPushback = function(GUID, amount, faded)
        local  cast = timer[GUID]
        if not cast then return end

        -- Set cast time modifier (i.e Curse of Tongues)
        if  not faded and amount and amount > 0 then
            if  not cast.currTimeModValue or cast.currTimeModValue < amount then -- run only once unless % changed to higher val
                if  cast.currTimeModValue then -- already was reduced
                    -- if existing modifer is e.g 50% and new is 60%, we only want to adjust cast by 10%
                    amount = amount - cast.currTimeModValue

                    -- Store previous lesser modifier that was active
                    cast.prevCurrTimeModValue = cast.prevCurrTimeModValue or {}
                    cast.prevCurrTimeModValue[#cast.prevCurrTimeModValue + 1] = cast.currTimeModValue
                end

                -- print("refreshing timer", percentageAmount)
                cast.currTimeModValue = (cast.currTimeModValue or 0) + amount -- highest active modifier
                cast.max = cast.max + (cast.max * amount)/100
                cast.endTime = cast.endTime + (cast.max * amount)/100
            elseif cast.currTimeModValue == amount then
                -- new modifier has same percentage as current active one, just store it for later
                -- print("same percentage, storing")
                cast.prevCurrTimeModValue = cast.prevCurrTimeModValue or {}
                cast.prevCurrTimeModValue[#cast.prevCurrTimeModValue + 1] = amount
            end
        elseif faded and amount then
            -- Reset cast time modifier
            if  cast.currTimeModValue == amount then
                cast.max = cast.max - (cast.max*amount)/100
                cast.endTime = cast.endTime - (cast.max*amount)/100
                cast.currTimeModValue = nil

                -- Reset to lesser modifier if available
                if cast.prevCurrTimeModValue then
                    local highest, index = 0
                    for i = 1, #cast.prevCurrTimeModValue do
                        if cast.prevCurrTimeModValue[i] and cast.prevCurrTimeModValue[i] > highest then
                            highest, index = cast.prevCurrTimeModValue[i], i
                        end
                    end

                    if  index then
                        cast.prevCurrTimeModValue[index] = nil
                        -- print("resetting to lesser modifier", highest)
                        return CastPushback(GUID, highest)
                    end
                end
            end

            if cast.prevCurrTimeModValue then
                -- Delete 1 old modifier (doesn't matter which one aslong as its the same %)
                for i = 1, #cast.prevCurrTimeModValue do
                    if  cast.prevCurrTimeModValue[i] == amount then
                        -- print("deleted lesser modifier, new total:", #cast.prevCurrTimeModValue - 1)
                        cast.prevCurrTimeModValue[i] = nil
                        return
                    end
                end
            end
        else -- normal pushback
            if  not cast.isChanneled then
                cast.pushback = cast.pushback or 1
                cast.max = cast.max + cast.pushback
                cast.endTime = cast.endTime + cast.pushback
                cast.pushback = max(cast.pushback - .2, .2)
            else
                -- channels are reduced by 25%
                cast.max = cast.max - (cast.max*25)/100
                cast.endTime = cast.endTime - (cast.max*25)/100
            end
        end
    end

    local PLAYER_ENTERING_WORLD = function(login)
        if  login then return end

        for _, table in pairs(
            {
                GUIDs, timer, frames
            }
        ) do
            wipe(table)
        end

        pool:GetFramePool():ReleaseAll()
    end

    local PLAYER_LOGIN = function()
        e:UnregisterEvent'PLAYER_LOGIN'
        for _, v in pairs(
            {
                'COMBAT_LOG_EVENT_UNFILTERED',
                'PLAYER_ENTERING_WORLD',
                'PLAYER_TARGET_CHANGED',
                'NAME_PLATE_UNIT_ADDED',
                'NAME_PLATE_UNIT_REMOVED',
            }
        ) do
            e:RegisterEvent(v)
        end
    end

    local PLAYER_TARGET_CHANGED = function()
        GUIDs.target = UnitGUID'target' or nil
        StopCast('target', true)
        StartCast(GUIDs.target, 'target')
    end

    local NAME_PLATE_UNIT_ADDED = function(unit)
        local GUID  = UnitGUID(unit)
        GUIDs[unit] = GUID
        StartCast(GUID, unit)
    end

    local NAME_PLATE_UNIT_REMOVED = function(unit)
        GUIDs[unit] = nil
        local castbar = frames[unit]
        if  castbar then
            ReleaseFrame(castbar)
            frames[unit] = nil
        end
    end

    local COMBAT_LOG_EVENT_UNFILTERED = function()
        local _, event, _, srcGUID, _, srcFlags, _, dstGUID,  _, dstFlags, _, _, name, _, damage, _, resisted, blocked, absorbed = CombatLogGetCurrentEventInfo()
        if  event == 'SPELL_CAST_START' then
            local  spellid = ns.cast[name]
            if not spellid then return end -- nb: keep an eye on how this table loop affects performance
            local _, _, icon, time = GetSpellInfo(spellid)
            if not time or time == 0 then return end

            local talentdecrease = ns.talentdecrease[name]
            if  talentdecrease then
                if  bit.band(srcFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0 then
                    time = time - (talentdecrease*1000)
                end
            end

            return StoreCast(srcGUID, name, icon, time, GetSpellSubtext(spellid))
        elseif event == 'SPELL_CAST_SUCCESS' then
            -- channeled spells start here
            local spell = ns.channelled[name]
            if  spell then
                return StoreCast(srcGUID, name, GetSpellTexture(spell[2]), spell[1]*1000, nil, true)
            end
            return DeleteCast(srcGUID)
        elseif event == 'SPELL_AURA_APPLIED' then
            local decrease  = ns.decrease[name]
            local increase  = ns.delay[name]
            local cc        = ns.CC[name]
            if  decrease then
                return CastPushback(dstGUID, decrease)
            elseif increase then
                return CastPushback(dstGUID, increase, true)
            elseif cc then
                return DeleteCast(dstGUID)
            end
        elseif event == 'SPELL_AURA_REMOVED' then
            local increase  = ns.delay[name]
            if  ns.channelled[name] then
                return DeleteCast(srcGUID)
            elseif increase then
                return CastPushback(dstGUID, increase, true)
            end
        elseif event == 'SPELL_CAST_FAILED' then
            if  srcGUID == UnitGUID'player' then
                if  not CastingInfo'player' then
                    return DeleteCast(srcGUID)
                end
            else
                return DeleteCast(srcGUID)
            end
        elseif event == 'PARTY_KILL' or event == 'UNIT_DIED' or event == 'SPELL_INTERRUPT' then
            return DeleteCast(dstGUID)
        elseif event == 'SWING_DAMAGE' or event == 'ENVIRONMENTAL_DAMAGE' or event == 'RANGE_DAMAGE' or event == 'SPELL_DAMAGE' then
            if  resisted or blocked or absorbed then return end
            if  bit.band(dstFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0 then
                return CastPushback(dstGUID)
            end
        end
    end

    local OnUpdate = function()
        if not next(timer) then return end
        local current = GetTime()
        for unit, castbar in pairs(frames) do
            local cast = castbar._data
            if  cast then
                local time = cast.endTime - current
                if  time > 0 then
                    local v = cast.max - time
                    if  cast.channeled then
                        v = cast.max - v
                    end
                    castbar:SetMinMaxValues(0, cast.max)
                    castbar:SetValue(v)
                    castbar.Timer:SetFormattedText('%.1f', time)
                    castbar.Spark:SetPoint('CENTER', castbar, 'LEFT', (v/cast.max)*castbar:GetWidth(), 0)
                else
                    DeleteCast(cast.GUID)
                end
            end
        end
    end

    local OnEvent = function(self, event, ...)
        if  MODUI_VAR['elements']['ecastbar'].enable then
            if  event == 'PLAYER_LOGIN' then
                PLAYER_LOGIN()
                e:SetScript('OnUpdate', OnUpdate)
            elseif event == 'COMBAT_LOG_EVENT_UNFILTERED' then
                COMBAT_LOG_EVENT_UNFILTERED()
            elseif event == 'NAME_PLATE_UNIT_REMOVED' then
                NAME_PLATE_UNIT_REMOVED(...)
            elseif event == 'NAME_PLATE_UNIT_ADDED' then
                NAME_PLATE_UNIT_ADDED(...)
            elseif event == 'PLAYER_TARGET_CHANGED' then
                PLAYER_TARGET_CHANGED()
            end
        end
    end

    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent',  OnEvent)

    --

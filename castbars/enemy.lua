

    local _, ns     = ...

    local build = tonumber(string.sub(GetBuildInfo() , 1, 2))
    -- if build > 1 then return end -- BfA dont need this

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

    local channeledspells = {
        -- MISC
        [GetSpellInfo(746)] = 7,        -- First Aid
        [GetSpellInfo(13278)] = 4,      -- Gnomish Death Ray
        [GetSpellInfo(20577)] = 10,     -- Cannibalize

        -- DRUID
        --[GetSpellInfo(17401)] = 9.5,    -- Hurricane
        [GetSpellInfo(740)] = 9.5,      -- Tranquility

        -- HUNTER
        [GetSpellInfo(6197)] = 60,      -- Eagle Eye
        --[GetSpellInfo(1002)] = 60,      -- Eyes of the Beast
        --[GetSpellInfo(20900)] = 3,      -- Aimed Shot TODO: verify

        -- MAGE
        [GetSpellInfo(5143)] = 4.5,     -- Arcane Missiles
        --[GetSpellInfo(10)] = 7.5,       -- Blizzard
        [GetSpellInfo(12051)] = 8,      -- Evocation

        -- PRIEST
        [GetSpellInfo(15407)] = 3,      -- Mind Flay
        [GetSpellInfo(2096)] = 60,      -- Mind Vision
        [GetSpellInfo(605)] = 3,        -- Mind Control

        -- WARLOCK
        --[GetSpellInfo(689)] = 4.5,      -- Drain Life
        --[GetSpellInfo(5138)] = 4.5,     -- Drain Mana
        --[GetSpellInfo(1120)] = 14.5,    -- Drain Soul
        [GetSpellInfo(5740)] = 7.5,     -- Rain of Fire
        [GetSpellInfo(1949)] = 15,      -- Hellfire
        [GetSpellInfo(755)] = 10,       -- Health Funnel
    }

    local castdecreases = {
        -- WARLOCK
        [1714] = 50,    -- Curse of Tongues Rank 1
        [11719] = 60,   -- Curse of Tongues Rank 2

        -- ROGUE
        [5760] = 40,    -- Mind-Numbing Poison Rank 1
        [8692] = 50,    -- Mind-Numbing Poison Rank 2
        [25810] = 50,   -- Mind-Numbing Poison Rank 2 incorrect?
        [11398] = 60,   -- Mind-Numbing Poison Rank 3

        -- ITEMS
        [17331] = 10,   -- Fang of the Crystal Spider
    }

    local talentdecreases = {
        [GetSpellInfo(403)] = 1,        -- Lightning Bolt
        [GetSpellInfo(421)] = 1,        -- Chain Lightning
        [GetSpellInfo(6353)] = 2,       -- Soul Fire
        [GetSpellInfo(116)] = .5,      -- Frostbolt
    --  [GetSpellInfo(133)] = .5,      -- Fireball
        [GetSpellInfo(686)] = .5,      -- Shadow Bolt
        [GetSpellInfo(348)] = .5,      -- Immolate
        --[GetSpellInfo(331)] = .5,      -- Healing Wave
        [GetSpellInfo(585)] = .5,      -- Smite
        [GetSpellInfo(14914)] = .5,    -- Holy Fire
        --[GetSpellInfo(2054)] = .5,     -- Heal
        --[GetSpellInfo(25314)] = .5,    -- Greater Heal
        --[GetSpellInfo(8129)] = .5,     -- Mana Burn
        [GetSpellInfo(5176)] = .5,     -- Wrath
        [GetSpellInfo(2912)] = .5,     -- Starfire
        --[GetSpellInfo(5185)] = .5,     -- Healing Touch
        [GetSpellInfo(2645)] = 2,       -- Ghost Wolf
        [GetSpellInfo(691)] = 4,        -- Summon Felhunter
        [GetSpellInfo(688)] = 4,        -- Summon Imp
        [GetSpellInfo(697)] = 4,        -- Summon Voidwalker
        [GetSpellInfo(712)] = 4,        -- Summon Succubus
    }

    local CC = {
        [GetSpellInfo(5211)] = 1,       -- Bash
        [GetSpellInfo(24394)] = 1,      -- Intimidation
        [GetSpellInfo(853)] = 1,        -- Hammer of Justice
        [GetSpellInfo(22703)] = 1,      -- Inferno Effect (Summon Infernal)
        [GetSpellInfo(408)] = 1,        -- Kidney Shot
        --[GetSpellInfo(12809)] = 1,      -- Concussion Blow
        --[GetSpellInfo(20253)] = 1,      -- Intercept Stun
        [GetSpellInfo(20549)] = 1,      -- War Stomp
        [GetSpellInfo(2637)] = 1,       -- Hibernate
        [GetSpellInfo(3355)] = 1,       -- Freezing Trap
        [GetSpellInfo(19386)] = 1,      -- Wyvern Sting
        [GetSpellInfo(118)] = 1,        -- Polymorph
        [GetSpellInfo(28271)] = 1,      -- Polymorph: Turtle
        [GetSpellInfo(28272)] = 1,      -- Polymorph: Pig
        [GetSpellInfo(20066)] = 1,      -- Repentance
        [GetSpellInfo(1776)] = 1,       -- Gouge
        [GetSpellInfo(6770)] = 1,       -- Sap
        --[GetSpellInfo(1513)] = 1,       -- Scare Beast
        [GetSpellInfo(8122)] = 1,       -- Psychic Scream
        [GetSpellInfo(2094)] = 1,       -- Blind
        [GetSpellInfo(5782)] = 1,       -- Fear
        [GetSpellInfo(5484)] = 1,       -- Howl of Terror
        [GetSpellInfo(6358)] = 1,       -- Seduction
        [GetSpellInfo(5246)] = 1,       -- Intimidating Shout
        [GetSpellInfo(6789)] = 1,       -- Death Coil
        --[GetSpellInfo(9005)] = 1,       -- Pounce
        [GetSpellInfo(1833)] = 1,       -- Cheap Shot
        --[GetSpellInfo(16922)] = 1,      -- Improved Starfire
        --[GetSpellInfo(19410)] = 1,      -- Improved Concussive Shot
        --[GetSpellInfo(12355)] = 1,      -- Impact
        --[GetSpellInfo(20170)] = 1,      -- Seal of Justice Stun
        --[GetSpellInfo(15269)] = 1,      -- Blackout
        --[GetSpellInfo(18093)] = 1,      -- Pyroclasm
        --[GetSpellInfo(12798)] = 1,      -- Revenge Stun
        --[GetSpellInfo(5530)] = 1,       -- Mace Stun
        --[GetSpellInfo(19503)] = 1,      -- Scatter Shot
        [GetSpellInfo(605)] = 1,        -- Mind Control
        [GetSpellInfo(7922)] = 1,       -- Charge Stun
        --[GetSpellInfo(18469)] = 1,      -- Counterspell - Silenced
        [GetSpellInfo(15487)] = 1,      -- Silence
        --[GetSpellInfo(18425)] = 1,      -- Kick - Silenced
        --[GetSpellInfo(24259)] = 1,      -- Spell Lock
        --[GetSpellInfo(18498)] = 1,      -- Shield Bash - Silenced

        -- ITEMS
        [GetSpellInfo(13327)] = 1,      -- Reckless Charge
        [GetSpellInfo(1090)] = 1,       -- Sleep
        [GetSpellInfo(5134)] = 1,       -- Flash Bomb Fear
        [GetSpellInfo(19821)] = 1,      -- Arcane Bomb Silence
        [GetSpellInfo(4068)] = 1,       -- Iron Grenade
        [GetSpellInfo(19769)] = 1,      -- Thorium Grenade
        [GetSpellInfo(13808)] = 1,      -- M73 Frag Grenade
        [GetSpellInfo(4069)] = 1,       -- Big Iron Bomb
        [GetSpellInfo(12543)] = 1,      -- Hi-Explosive Bomb
        [GetSpellInfo(4064)] = 1,       -- Rough Copper Bomb
        [GetSpellInfo(12421)] = 1,      -- Mithril Frag Bomb
        [GetSpellInfo(19784)] = 1,      -- Dark Iron Bomb
        [GetSpellInfo(4067)] = 1,       -- Big Bronze Bomb
        [GetSpellInfo(4066)] = 1,       -- Small Bronze Bomb
        [GetSpellInfo(4065)] = 1,       -- Large Copper Bomb
        [GetSpellInfo(13237)] = 1,      -- Goblin Mortar
        [GetSpellInfo(835)] = 1,        -- Tidal Charm
        [GetSpellInfo(13181)] = 1,      -- Gnomish Mind Control Cap
        [GetSpellInfo(12562)] = 1,      -- The Big One
        [GetSpellInfo(15283)] = 1,      -- Stunning Blow (Weapon Proc)
        [GetSpellInfo(56)] = 1,         -- Stun (Weapon Proc)
        [GetSpellInfo(26108)] = 1,      -- Glimpse of Madness
    }

    local InitializeNewFrame = function(frame)
        -- Some of the points set by SmallCastingBarFrameTemplate doesn't
        -- work well when user modify castbar size, so set our own points instead
        frame.Border:ClearAllPoints()
        frame.Icon:ClearAllPoints()
        frame.Text:ClearAllPoints()
        frame.Icon:SetPoint('LEFT', frame, -35, 0)
        frame.Text:SetPoint'CENTER'
        frame.Flash:SetAlpha(0) -- we don't use this atm

        -- Clear any scripts inherited from frame template
        frame:SetScript('OnLoad', nil)
        frame:SetScript('OnEvent', nil)
        frame:SetScript('OnUpdate', nil)
        frame:SetScript('OnShow', nil)

        -- Add cast countdown timer
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
                castbar:SetPoint('CENTER', TargetFrame, -18, -75)
            else
                castbar:SetPoint('CENTER', TargetFrame, -18, -100)
            end
        else
            if  not parent.buffsOnTop and rows > 0 then
                castbar:SetPoint('CENTER', TargetFrame, -18, -100)
            else
                castbar:SetPoint('CENTER', TargetFrame, -18, -50)
            end
        end
    end

    local SetCastbarIconAndText = function(castbar, cast)
        name = cast.rank and cast.name..' ('..cast.rank..')' or cast.name
        -- Update text + icon if it has changed
        if  castbar.Text:GetText() ~= name then
            castbar.Icon:SetTexture(cast.icon)
            castbar.Text:SetText(name)
            castbar.Timer:SetPoint('RIGHT', castbar, name:len() >= 19 and 20 or 6, 0)
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
                cast.max = cast.max + .5
                cast.endTime = cast.endTime + .5
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
        local _, event, _, srcGUID, _, srcFlags, _, dstGUID,  _, dstFlags, _, spellid, name, _, _, _, _, resisted, blocked, absorbed = CombatLogGetCurrentEventInfo()
        if  event == 'SPELL_CAST_START' then
            local _, _, icon, time = GetSpellInfo(spellid)
            if not time or time == 0 then return end

            if  talentdecreases[name] then
                if  bit.band(srcFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0 then
                    time = time - (talentdecreases[name]*1000)
                end
            end

            return StoreCast(srcGUID, name, icon, time, GetSpellSubtext(spellid))
        elseif event == 'SPELL_CAST_SUCCESS' then
            local time = channeledspells[name]
            if  time then
                return StoreCast(srcGUID, name, GetSpellTexture(spellid), time*1000, nil, true)
            end
            return DeleteCast(srcGUID)
        elseif event == 'SPELL_AURA_APPLIED' then
            if  castdecreases[spellid] then
                return CastPushback(dstGUID, castdecreases[spellid])
            elseif CC[name] then
                return DeleteCast(dstGUID)
            end
        elseif event == 'SPELL_AURA_REMOVED' then
            if  channeledspells[name] then
                return DeleteCast(srcGUID)
            elseif castdecreases[spellid] then
                return CastPushback(dstGUID, castdecreases[spellid], true)
            end
        elseif event == 'SPELL_CAST_FAILED' then
            if  srcGUID == UnitGUID'player' then
                if  not (CastingInfo or UnitCastingInfo)'player' then
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

    local OnEvent = function(self, event, ...)
        if  event == 'PLAYER_LOGIN' then
            PLAYER_LOGIN()
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

    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent',  OnEvent)
    e:SetScript('OnUpdate', OnUpdate)

    --

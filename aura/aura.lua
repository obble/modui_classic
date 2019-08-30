

    local _, ns = ...
    local FONT_REGULAR = ns.FONT_REGULAR

    local e = CreateFrame'Frame'

    local layout    = {
        ['player|HELPFUL']  = {
            point           = 'TOPRIGHT',
            sort            = 'TIME',
            minWidth        = 330,
            minHeight       = 100,
            x               = -38,
            y               = 0,
            wrapAfter       = 12,
            wrapY           = -42,
            direction       = '+',
            position        = {
                'TOPRIGHT',
                Minimap,
                'TOPLEFT',
                -100,
                -8,
            },
        },
        ['player|HARMFUL']  = {
            point           = 'TOPRIGHT',
            sort            = 'TIME',
            minWidth        = 330,
            minHeight       = 100,
            x               = -50,
            wrapAfter       = 1,
            wrapY           = -50,
            direction       = '+',
            position        = {
                'TOPRIGHT',
                QuestWatchFrame,
                'TOPLEFT',
                -25,
                -20,
            },
        },
        ['weapons|NA']      =   {
            xOffset         = 40,
            position        = {
                'TOPRIGHT',
                QuestWatchFrame,
                'TOPLEFT',
                -25,
                -20,
            },
        },
    }

    local AbbrevTime = function(bu, time)
        local h, m, s, text
        if  time <= 0 then
            text = ''
        elseif time < 3600 and time > 60 then
            h       = floor(time/3600)
            m       = floor(mod(time, 3600)/60 + 1)
            s       = mod(time, 60)
            text    = format('|cffffffff%d|rm', m)
        elseif time < 60 then
            m       = floor(time/60)
            s       = mod(time, 60)
            text    = m == 0 and format('|cffffffff%d|rs', s)
        else
            h       = floor(time/3600 + 1)
            text    = format('|cffffffff%d|rh', h)
        end
        return text
    end

    local UpdateSB = function(self, duration, expiration)
        self.sb:Hide()
        if  MODUI_VAR['elements']['aura'].statusbars and expiration and duration > 0 then
            -- local p = duration/expiration
            self.sb:SetMinMaxValues(0, duration)
            self.sb:SetValue(expiration)
            self.sb:SetStatusBarColor(self.debuff and 1 or 0, self.debuff and 0 or 1, 0)
            self.sb:Show()
        end
    end

    local OnUpdate = function(self, elapsed)
    	if  self.expiration then
    		self.expiration = max(self.expiration - elapsed, 0)
            if  MODUI_VAR['elements']['aura'].values then
                self:SetText(self.expiration > 0 and AbbrevTime(self, self.expiration) or '')
            else
                self:SetFormattedText(SecondsToTimeAbbrev(self.expiration))
            end
            UpdateSB(self, self.duration, self.expiration)
    	end
    end

    local UpdateTempEnchant = function(...)
        for i = 1, BuffFrame.numEnchants do
            local enchant, expiration, charges = select(i, ...)
            if  enchant then
                local bu = _G['TempEnchant'..i]
                if  MODUI_VAR['elements']['aura'].values then
                    bu.duration:SetText(expiration > 0 and AbbrevTime(bu, expiration/1000) or '')
                else
                    bu.duration:SetFormattedText(SecondsToTimeAbbrev(expiration/1000))
                end
                for k = 1, 4 do
                    bu.bo[k]:SetVertexColor(1, 0, .7)
                end
            end
        end
    end

    local FormatDebuffs = function(self, name, dtype)
        if  name then
            local colour = DebuffTypeColor[dtype or 'none']
            self.Name:SetText(strupper(name))
            self.Name:SetTextColor(colour.r*1.7, colour.g*1.7, colour.b*1.7)    -- brighten up
            self.Name:SetWidth(150)
            self.Name:SetWordWrap(true)
            for  i, v in pairs(self.F.bo) do
                 self.F.bo[i]:SetVertexColor(colour.r, colour.g, colour.b)
            end
        else
            self.Name:SetText''
            for  i, v in pairs(self.F.bo) do
                 self.F.bo[i]:SetVertexColor(MODUI_VAR['theme_bu'].r, MODUI_VAR['theme_bu'].g, MODUI_VAR['theme_bu'].b)
            end
        end
    end

    local OnAttributeChanged = function(self, attribute, index)
    	if attribute ~= 'index' then return end
        local header = self:GetParent()
        local unit, filter = header:GetAttribute'unit', header:GetAttribute'filter'
        local name, icon, count, dtype, duration, expiration = UnitAura(unit, index, filter)
    	if  name then
    		self:SetNormalTexture(icon)
    		self.Count:SetText(count > 1 and count or '')

            self.debuff     = false
            self.duration   = duration
    		self.expiration = expiration - GetTime()

            if  self.expiration and duration > 0 then
                self.sb:SetMinMaxValues(0, duration)
            end

            if  filter == 'HARMFUL' then
                self.debuff = true
                FormatDebuffs(self, name, dtype)
            end
    	end
    end

    local AddButton = function(self, name, bu)
    	if  name:match'^child' then
        	bu:SetScript('OnUpdate',            OnUpdate)
            bu:SetScript('OnAttributeChanged',  OnAttributeChanged)

            bu.F = CreateFrame('Frame', nil, bu)
            bu.F:SetAllPoints()
            ns.BD(bu)

            ns.BUBorder(bu.F, 20)
            for i = 1, 4 do
                tinsert(ns.skinbu, bu.F[i])
            end

        	local icon = bu:CreateTexture('$parentTexture', 'ARTWORK')
        	icon:SetAllPoints()
        	icon:SetTexCoord(.1, .9, .1, .9)

            local name = bu:CreateFontString('$parentName', nil, 'GameFontNormal')
            name:SetFont(FONT_REGULAR, 14)
            name:SetShadowOffset(1, -1)
        	name:SetShadowColor(0, 0, 0)
            name:SetJustifyH'RIGHT'
            name:SetPoint('RIGHT', bu, 'LEFT', -15, 0)

        	local d = bu:CreateFontString('$parentDuration', nil, 'GameFontNormalSmall')
        	d:SetPoint('TOP', bu, 'BOTTOM', 0, -8)

        	local count = bu:CreateFontString('$parentCount', nil, 'GameFontNormal')
            count:SetParent(bu.F)
            count:SetJustifyH'CENTER'
        	count:SetPoint('CENTER', bu, 'TOP', 0, 2)

            local sb = CreateFrame('StatusBar', nil, bu)
            ns.BD(sb, 1, -2)
            ns.SB(sb)
            sb:SetHeight(5)
            sb:SetPoint'LEFT'
            sb:SetPoint'RIGHT'
            sb:SetPoint'BOTTOM'
            sb:SetMinMaxValues(0, 1)
            sb:Hide()

            sb.bg = sb:CreateTexture(nil, 'BORDER')
            ns.SB(sb.bg)
            sb.bg:SetAllPoints()
            sb.bg:SetVertexColor(.2, .2, .2)

            bu:SetFontString(d)
            bu:SetNormalTexture(icon)

        	bu.Count = count
            bu.Name  = name
            bu.sb    = sb
        end
    end

    local AddHeader = function(unit, filter, attribute)
        local Header = CreateFrame('Frame', 'modauras'..filter, Minimap, 'SecureAuraHeaderTemplate')
        Header:SetAttribute('template',         'modauraTemplate')
        --Header:SetAttribute('weaponTemplate',   'modauraTemplate')
        Header:SetAttribute('unit',             unit)
        Header:SetAttribute('filter',           filter)
        Header:SetAttribute('includeWeapons',   0)
        Header:SetAttribute('xOffset',          attribute.x)
        Header:SetPoint(unpack(attribute.position))


        Header:SetAttribute('sortDirection',    attribute.direction)
        Header:SetAttribute('sortMethod',       attribute.sort)
        Header:SetAttribute('sortDirection',    attribute.direction)
        Header:SetAttribute('point',            attribute.point)
        Header:SetAttribute('minWidth',         attribute.minWidth)
        Header:SetAttribute('minHeight',        attribute.minHeight)
        Header:SetAttribute('xOffset',          attribute.x)
        Header:SetAttribute('wrapYOffset',      attribute.wrapY)
        Header:SetAttribute('wrapAfter',        attribute.wrapAfter)

        Header:HookScript('OnAttributeChanged', AddButton)
        Header:Show()

        RegisterAttributeDriver(Header, 'unit', '[vehicleui] vehicle; player')
    end

    local RemoveBuffFrame = function()
        for _, v in pairs(
            {
                BuffFrame
            }
        ) do
            v:UnregisterAllEvents()
            v:Hide()
        end
    end

    local AddTemporaryEnchant = function()
        TemporaryEnchantFrame:ClearAllPoints()
        TemporaryEnchantFrame:SetPoint('TOPRIGHT', Minimap, 'TOPLEFT', -10, -7)

        hooksecurefunc('TemporaryEnchantFrame_Update', UpdateTempEnchant)

        for i = 1, 2 do
            local bu = _G['TempEnchant'..i]
            local icon = _G['TempEnchant'..i..'Icon']
            local duration = _G['TempEnchant'..i..'Duration']
            local border = _G['TempEnchant'..i..'Border']

            icon:SetTexCoord(.1, .9, .1, .9)

            ns.BUBorder(bu, 20, 20, 5, 5)

            duration:SetPoint('TOP', bu, 'BOTTOM', 0, -6)

            border:Hide()
        end
    end

    local AddHeader = function()
        if not MODUI_VAR['elements']['aura'].enable then return end
        RemoveBuffFrame()
        AddTemporaryEnchant()
        for i ,v in pairs(layout) do
            local unit, filter = i:match'(.-)|(.+)'
            if  unit then
                AddHeader(unit, filter, v)
            end
        end
    end

    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', AddHeader)

    --

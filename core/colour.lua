

	local _, ns = ...

	local _, class = UnitClass'player'
	local colour   = RAID_CLASS_COLORS[class]

	local INTERNAL_CLASS_COLORS = {
		['DRUID']       = {r = 255/255, g = 110/255, b = 063/255, colorStr = 'ffff6e3f'},
		['HUNTER']      = {r = 140/255, g = 220/255, b = 105/255, colorStr = 'ff8cdc69'},
		['MAGE']        = {r = 000/255, g = 194/255, b = 255/255, colorStr = 'ff00c2ff'},
		['PALADIN']     = {r = 255/255, g = 095/255, b = 168/255, colorStr = 'ffff5fa8'},
		['PRIEST']      = {r = 255/255, g = 255/255, b = 255/255, colorStr = 'ffffffff'},
		['ROGUE']       = {r = 255/255, g = 232/255, b = 000/255, colorStr = 'ffffe800'},
		['SHAMAN']      = {r = 050/255, g = 111/255, b = 255/255, colorStr = 'ff326fff'},
		['WARLOCK']     = {r = 140/255, g = 118/255, b = 238/255, colorStr = 'ff8c76ee'},
		['WARRIOR']     = {r = 214/255, g = 148/255, b = 110/255, colorStr = 'ffd6946e'}
	}

	RAID_CLASS_COLORS['SHAMAN'] = {r = 050/255, g = 111/255, b = 255/255, colorStr = 'ff326fff'}

	local CUSTOM_FACTION_BAR_COLORS = {
		[1] = {r = 1, g = .2, b = .2},	-- hated
		[2] = {r = 1, g = .2, b = .2},	-- hostile
		[3] = {r = 1, g = .6, b = .2},	-- unfriendly
		[4] = {r = 1, g = .8, b = .1},	-- neutral
		[5] = {r = .4, g = 1, b = .2},	-- friend
		[6]	= {r = .4, g = 1, b = .3},	-- honoured
		[7]	= {r = .3, g = 1, b = .4},	-- revered
		[8]	= {r = .3, g = 1, b = .5},	-- exalted
	}

    ns.CLASS_COLOUR = function(f, a)
        if  f:GetObjectType() == 'StatusBar' then
            f:SetStatusBarColor(colour.r, colour.g, colour.b)
        elseif
            f:GetObjectType() == 'FontString' then
            f:SetTextColor(colour.r, colour.g, colour.b)
        else
            f:SetVertexColor(colour.r, colour.g, colour.b)
        end
    end

    ns.TEXT_WHITE = function(t, ...)
        t:SetTextColor(1, 1, 1)
    end

    ns.GRADIENT_COLOUR = function(f, v, min, max)
        if  not v then
            v = f:GetValue()
        end
        if  not min or not max then
             min, max = f:GetMinMaxValues()
        end
        if (not v) or v < min or v > max then return end
        if (max - min) > 0 then
            v = (v - min)/(max - min)
        else
            v = 0
        end
        if v > .5 then
            r = (1 - v)*2
            g = 1
        elseif v < .2 then
			r = 1
			g = 0
		else
            r = 1
            g = v*2
        end
        b = 0
        if  f:GetObjectType() == 'StatusBar'  then
            f:SetStatusBarColor(r, g, b)
        elseif f:GetObjectType() == 'FontString' then
            f:SetTextColor(r*1.5, g*1.5, b*1.5)
        else
            f:SetVertexColor(r, g, b)
        end
    end

	ns.INTERNAL_CLASS_COLORS 		= INTERNAL_CLASS_COLORS
	ns.CUSTOM_FACTION_BAR_COLORS 	= CUSTOM_FACTION_BAR_COLORS

	--

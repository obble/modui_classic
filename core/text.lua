local _, ns = ...

local FONT_REGULAR 	   	= 'Interface\\AddOns\\modui\\font\\NotoSans-Regular.ttf'
local FONT_BOLD		   	= 'Interface\\AddOns\\modui\\font\\NotoSans-Bold.ttf'

ns.FONT_REGULAR     	= FONT_REGULAR
ns.FONT_BOLD        	= FONT_BOLD

local strings = {
    ['warnings'] = {
        RaidWarningFrameSlot1,
        RaidWarningFrameSlot2,
        RaidBossEmoteFrameSlot1,
        RaidBossEmoteFrameSlot2
    },
    ['zone']	 = {
        ZoneTextString,
        SubZoneTextString,
        PVPInfoTextString,
        PVPArenaTextString
    },
    ['map']		 = {
        WorldMapFrameAreaLabel,
        WorldMapFrameAreaDescription,
        WorldMapFrameAreaPetLevels
    },
    ['toast']	 = {
        BNToastFrameTopLine,
        BNToastFrameMiddleLine,
        BNToastFrameBottomLine,
        BNToastFrameDoubleLine
    },
    ['tooltip']	 = {
        GameTooltipTextLeft1
    },
}

local iterate = function(v, callback)
    local i, j = next(v, nil)
    while i do
        callback(j)
        i, j = next(v, i)
    end
end

for n, v in pairs(strings) do
    if n == 'zone' or n == 'warnings' then
        iterate(v, function(t)
            t:SetFont(FONT_BOLD, 7)
            t:SetShadowOffset(1, -1.25)
            t:SetShadowColor(0, 0, 0, 1)
        end)
    elseif n == 'map' then
        iterate(v, function(t)
            t:SetFont(FONT_BOLD, 30)
            t:SetShadowOffset(1, -1.25)
            t:SetShadowColor(0, 0, 0, 1)
        end)
    elseif n == 'toast' then
        iterate(v, function(t)
            if t == BNToastFrameTopLine then t:SetJustifyH'CENTER' end
            t:SetFont(t == BNToastFrameTopLine and FONT_BOLD or FONT_REGULAR,
            t == BNToastFrameTopLine and 13 or 10)
            t:SetShadowOffset(1, -1.25)
            t:SetShadowColor(0, 0, 0, 1)
        end)
    elseif n == 'tooltip' then
        iterate(v, function(t)
            t:SetFont(FONT_REGULAR, 13)
            t:SetShadowOffset(1, -1.25)
            t:SetShadowColor(0, 0, 0, 1)
        end)
    elseif n == 'common' then
        iterate(v, function(t)
            t:SetFont(FONT_REGULAR, 13)
        end)
    end
end

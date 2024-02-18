local _, ns     = ...

local size      = 5
local elapsed   = 0

local coord = CreateFrame('Frame', nil, WorldMapFrame)
coord:SetFrameLevel(WorldMapFrame:GetFrameLevel() + 2)
coord:SetPoint('BOTTOM', WorldMapFrame, 8, 10)
coord:SetSize(200, 16)

coord.Player = coord:CreateFontString(nil, 'OVERLAY')
coord.Player:SetFont(STANDARD_TEXT_FONT, 13, 'OUTLINE')
coord.Player:SetShadowOffset(0, -0)
coord.Player:SetJustifyH'CENTER'
coord.Player:SetPoint('BOTTOM', -100, 0)
coord.Player:SetTextColor(1, 1, 1)

coord.Cursor = coord:CreateFontString(nil, 'OVERLAY')
coord.Cursor:SetFont(STANDARD_TEXT_FONT, 13, 'OUTLINE')
coord.Cursor:SetShadowOffset(0, -0)
coord.Cursor:SetJustifyH'CENTER'
coord.Cursor:SetPoint('BOTTOM', 100, 0)
coord.Cursor:SetTextColor(1, 1, 1)

coord:SetScript('OnUpdate', function(self, elapsed)
    local x, y
    local id = C_Map.GetBestMapForUnit'player'
    if  id then
        local player = C_Map.GetPlayerMapPosition(id, 'player')
        if  player then
            x, y = player:GetXY()
        end
    end

    x = x or 0
    y = y or 0

    coord.Player:SetShown(x + y > 0)
    coord.Player:SetText(PLAYER..format(': %.0f / %.0f', x*100, y*100))

    x, y = WorldMapFrame.ScrollContainer:GetNormalizedCursorPosition()

    coord.Cursor:SetShown(x + y > 0)
    coord.Cursor:SetText('Mouse'..format(': %.0f / %.0f', x*100, y*100))
end)


WorldMapFrame:HookScript('OnUpdate', function(self, e)
    elapsed = elapsed + e
    if elapsed > .5 then -- update frequency
        elapsed = 0
        local groupSize = GetNumGroupMembers()
        if groupSize > 0 then
            local groupType = IsInRaid() and 'Raid' or 'Party'
            for i = 1, groupSize do
                local f = _G['WorldMap'..groupType..i]
                if  f then
                    if  not f.overlay then
                        f.overlay = f:CreateTexture(nil, 'OVERLAY')
                        f.overlay:SetDrawLayer('OVERLAY', 7)
                    end

                    f.overlay:ClearAllPoints()

                    if  WorldMapFrame_InWindowedMode() then
                        f.overlay:SetPoint('TOPLEFT', f.icon, -size - 6, size + 6)
                        f.overlay:SetPoint('BOTTOMRIGHT', f.icon, size + 6, -size - 6)
                    else
                        f.overlay:SetPoint('TOPLEFT', f.icon, -size, size)
                        f.overlay:SetPoint('BOTTOMRIGHT', f.icon, size, -size)
                    end

                    local _, _, subgroup = GetRaidRosterInfo(i)

                    f.overlay:SetTexture(groupType == 'Raid' and ('Interface\\AddOns\\modui\\art\\worldmap\\raid'..subgroup) or 'Interface\\AddOns\\modui\\art\\worldmap\\party')
                    if  f.unit and f:IsShown() then
                        local _, class = UnitClass(f.unit)
                        local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
                        if  color then
                            f.overlay:SetVertexColor(color.r, color.g, color.b)
                        else
                            f.overlay:SetVertexColor(103/255, 103/255, 103/255)
                        end
                        if  GetTime()%1 < .5 then
                            if UnitAffectingCombat(f.unit) then
                                f.overlay:SetVertexColor(1, 0, 0)
                            elseif UnitIsDeadOrGhost(f.unit) then
                                f.overlay:SetVertexColor(.2, .2, .2)
                            elseif UnitIsAFK(f.unit) then
                                f.overlay:SetVertexColor(89/255, 0/255, 165/255)
                            end
                        end
                    end
                end
            end
        end
    end
end)

WorldMapFrame:SetScale(.8)
WorldMapFrame.BlackoutFrame:EnableMouse(false)
WorldMapFrame.BlackoutFrame:SetAlpha(0)

local WorldMapHolder = CreateFrame("Frame", nil, UIParent)
WorldMapHolder:SetSize(WorldMapFrame:GetWidth(), WorldMapFrame:GetHeight())
WorldMapHolder:SetPoint("CENTER", UIParent, 0, 0)

WorldMapFrame:SetParent(WorldMapHolder)
WorldMapFrame:ClearAllPoints()
WorldMapFrame:SetPoint("CENTER", WorldMapHolder, 0, 0)

WorldMapFrame.ScrollContainer.GetCursorPosition = function(frame)
    local x, y = MapCanvasScrollControllerMixin.GetCursorPosition(frame)
    local s = WorldMapFrame:GetScale()
    return x/s, y/s
end

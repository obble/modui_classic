

    local _, ns = ...

    local AddZoom = function(self, delta)
        if delta > 0 and Minimap:GetZoom() < 5 then
            Minimap:SetZoom(Minimap:GetZoom() + 1)
        elseif delta < 0 and Minimap:GetZoom() > 0 then
            Minimap:SetZoom(Minimap:GetZoom() - 1)
        end
    end

    Minimap:EnableMouseWheel(true)
    Minimap:SetScript('OnMouseWheel', AddZoom)


    for _, v in pairs(
        {
            MinimapZoomIn,
            MinimapZoomOut
        }
    ) do
        v:Hide()
    end


    local time  = TimeManagerClockButton or GameTimeFrame

    --t:SetFrameStrata'MEDIUM'
    --t:ClearAllPoints()
    --t:SetPoint('BOTTOMRIGHT', Minimap)

    if  MiniMapTracking then
        MiniMapTracking:ClearAllPoints()
        --MiniMapTracking:SetAllPoints(t)
        MiniMapTracking:SetPoint('TOPLEFT', Minimap)
    end

    MiniMapMailFrame:ClearAllPoints()
    MiniMapMailFrame:SetPoint('TOPRIGHT', Minimap, 4, -5)

    MinimapZoneText:ClearAllPoints()
    MinimapZoneText:SetPoint('TOP', Minimap, -2, 17)

    for _, v in pairs(
        {
            GameTimeFrame,
            MinimapBorderTop,
            MinimapToggleButton,
            MiniMapWorldMapButton,
        }
    ) do
        v:Hide()
    end

    --

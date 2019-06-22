

    local _, ns = ...

    local AddZoom = function()
        if not arg1 then return end
        if arg1 > 0 and Minimap:GetZoom() < 5 then
            Minimap:SetZoom(Minimap:GetZoom() + 1)
        elseif arg1 < 0 and Minimap:GetZoom() > 0 then
            Minimap:SetZoom(Minimap:GetZoom() - 1)
        end
    end

    local z = CreateFrame('Frame', nil, Minimap)
    z:SetAllPoints()
    z:EnableMouse(false)
    z:EnableMouseWheel(true)
    z:SetScript('OnMouseWheel', AddZoom)

    local t     = MiniMapTrackingButton or MiniMapTrackingFrame
    local time  = TimeManagerClockButton or GameTimeFrame

    t:SetFrameStrata'MEDIUM'
    t:ClearAllPoints()
    t:SetPoint('TOPRIGHT', Minimap)

    if  MiniMapTracking then
        MiniMapTracking:ClearAllPoints()
        MiniMapTracking:SetAllPoints(t)
    end

    MiniMapMailFrame:ClearAllPoints()
    MiniMapMailFrame:SetPoint('TOPRIGHT', Minimap, 2, -33)

    MinimapZoneText:ClearAllPoints()
    MinimapZoneText:SetPoint('TOP', Minimap, -2, 17)

    for _, v in pairs(
        {
            GameTimeFrame,
            MinimapBorderTop,
            MinimapToggleButton,
            MinimapZoomIn,
    	    MinimapZoomOut,
            MiniMapWorldMapButton,
        }
    ) do
        v:Hide()
    end

    --

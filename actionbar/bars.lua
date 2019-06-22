

    local _, ns = ...

    local n = {
        'Action',
        'MultiBarBottomLeft',
        'MultiBarBottomRight',
        'MultiBarLeft',
        'MultiBarRight',
    }

    local x = {
        'Pet',
        'Stance',
    }

    for _, v in pairs(n) do
        for i = 1, 12 do
            local bu = _G[v..'Button'..i]
            if  bu then
                ns.BU(bu, 0, true, bu:GetHeight() - 2, bu:GetWidth() - 2)
                ns.BUBorder(bu, 27)
                ns.BUElements(bu)

                -- placement shit is all for 8.0s wacky bars
                -- and needs sorting for classic
                if  v == 'MultiBarBottomRight' then
                    if  i == 1 then
                        bu:ClearAllPoints()
                        bu:SetPoint('LEFT', ActionButton12, 'RIGHT', 43, 0)
                    end
                end
                if  i > 1 then
                    bu:ClearAllPoints()
                    -- pixel...
                    bu:SetPoint('LEFT', _G[v..'Button'..(i - 1)], 'RIGHT', 8.2, 0)
                    -- PERFECTION!
                    if  i == 7 and v == 'MultiBarBottomRight' then
                        bu:ClearAllPoints()
                        bu:SetPoint('BOTTOMLEFT', _G[v..'Button1'], 'TOPLEFT', 0, 13)
                    end
                end
            end
        end
    end

    for _, v in pairs(x) do
        for i = 1, 10 do
            local bu = _G[v..'Button'..i]
            if bu then
                ns.BU(bu, 0, true, bu:GetHeight() - 2, bu:GetWidth() - 2)
                ns.BUBorder(bu, 24)
                ns.BUElements(bu)
            end
        end
    end

    local caps = CreateFrame('Frame', 'modui_endcaps', UIParent)
    caps:SetAllPoints(MainMenuBarArtFrame)
    caps:SetFrameLevel(1)

    for _, v in pairs(
        {
            MainMenuBarArtFrame.LeftEndCap or MainMenuBarLeftEndCap,
            MainMenuBarArtFrame.RightEndCap or MainMenuBarRightEndCap,
        }
    ) do
        v:SetParent(caps)
    end

    --




    --  api for reskinning frames & buttons
    --

    local _, ns = ...

    local FONT_REGULAR = ns.FONT_REGULAR

    local TEXTURE  = [[Interface\TargetingFrame\UI-StatusBar]]
    local BACKDROP = {
        bgFile     = [[Interface\ChatFrame\ChatFrameBackground]],
        tiled      = false,
        insets     = {left = -3, right = -3, top = -3, bottom = -3}
    }
    local SLOT     = {
        bgFile     = '',
        edgeFile   = [[Interface\Buttons\WHITE8x8]],
        edgeSize   = 3,
    }
    local BORDER   = {
        bgFile     = '',
        edgeFile   = [[Interface\Buttons\WHITE8x8]],
        edgeSize   = 1,
    }

    local t = CreateFont'iipHotKeyFont'
    t:SetFont(STANDARD_TEXT_FONT, 10, 'OUTLINE')

    local AddHighlight = function(bu)
        bu.enter = bu:CreateTexture(nil, 'OVERLAY')
        bu.enter:SetAllPoints()
        bu.enter:SetTexture[[Interface\Buttons\CheckButtonHilight]]
        bu.enter:SetTexCoord(.075, .95, .05, .95)
        bu.enter:SetBlendMode'ADD'
        bu.enter:SetAlpha(0)
    end

    local ToggleHighlight = function(bu, show)
        if not bu.enter then AddHighlight(bu) end
        bu.enter:SetAlpha(show and 1 or 0)
    end

    ns.BD = function(bu, a, ix)               --  build in an anti-fuckup
        local f = bu
        if  f:GetObjectType() == 'Texture' then
            if not bu.BD then
                local parent = bu:GetParent()
                bu.BD = CreateFrame('Frame', nil, parent)
                bu.BD:SetAllPoints(bu)
                bu.BD:SetFrameLevel(parent:GetFrameLevel() - 1)
            end
            f = bu.BD
        end
        f:SetBackdrop(
            {
                bgFile     = [[Interface\ChatFrame\ChatFrameBackground]],
                tiled      = false,
                insets     = {
                    left    = ix or -3,
                    right   = ix or -3,
                    top     = ix or -3,
                    bottom  = ix or -3
                }
            }
        )
        f:SetBackdropColor(0, 0, 0, a or 1)
    end

    ns.BU = function(bu, a, hover, x, y, ix)
        if not bu then return end
        ns.BD(bu, a, ix)
        bu:SetNormalTexture''
        --bu:SetHighlightTexture''
        -- bu:SetPushedTexture''
        if not InCombatLockdown() then bu:SetSize(x or 21, x or y or 21) end
        bu:HookScript('OnEnter', function() if hover then ToggleHighlight(bu, true) end end)
        bu:HookScript('OnLeave', function() if hover then ToggleHighlight(bu, false) end end)
    end

    ns.ItemElements = function(bu)
        local n  = bu:GetName()
        local c  = _G[n..'Count']
        local cd = _G[n..'Cooldown']
        local i  = _G[n..'IconTexture']
        local q  = _G[n..'IconQuestTexture']

        for _, v in pairs({bu.Border, bu.IconBorder}) do
            if v then v:SetAlpha(0) end
        end

        if  c then
            c:ClearAllPoints()
            c:SetPoint('BOTTOM', bu)
            c:SetFont(FONT_REGULAR, 14, 'OUTLINE')
            c:SetShadowOffset(0, 0)
            c:SetJustifyH'CENTER'
            c:SetDrawLayer('OVERLAY', 7)
        end

        if  i then
            i:SetTexCoord(.1, .9, .1, .9)
            i:SetDrawLayer'ARTWORK'
        end

        if  cd then
            cd:ClearAllPoints()
            cd:SetAllPoints()
        end

        if  bu.JunkIcon then
            bu.JunkIcon:ClearAllPoints()
            bu.JunkIcon:SetPoint'CENTER'
        end

        if  bu.NewItemTexture then
            bu.NewItemTexture:SetTexture''
            bu.NewItemTexture:SetSize(28, 28)
        end

        if  q then
            q:SetDrawLayer'BACKGROUND'
            q:SetSize(1, 1)
            bu.forQuest = true
        end
    end

    ns.BUElements = function(bu)
        local c  = bu.Count or _G[bu:GetName()..'Count']
        local cd = bu.Cooldown or _G[bu:GetName()..'Cooldown']
        local i  = bu.icon or bu.Icon or bu.IconTexture or _G[bu:GetName()..'Icon'] or _G[bu:GetName()..'IconTexture']

        for _, v in pairs({bu.Border, bu.FloatingBG}) do
            if v then v:SetAlpha(0) end
        end

        if  bu.FloatingBG and not bu.iid then
            bu.iid = bu:CreateTexture(nil, 'BACKGROUND')
            bu.iid:SetAllPoints(bu.FloatingBG)
            bu.iid:SetBackdrop(SLOT)
            bu.iid:SetBackdropColor(0, 0, 0)
        end


        if  c then
            -- if bu.bo then c:SetParent(bu.bo) end
            c:ClearAllPoints()
            c:SetPoint('CENTER', bu, 'TOP', 0, -1)
            c:SetFont(FONT_REGULAR, 15, 'OUTLINE')
            c:SetShadowOffset(0, 0)
            c:SetJustifyH'CENTER'
            c:SetDrawLayer('OVERLAY', 7)
        end

        if  cd then
            cd:ClearAllPoints()
            cd:SetAllPoints()
        end

        if  bu.HotKey then
            bu.HotKey:ClearAllPoints()
            bu.HotKey:SetPoint('TOPRIGHT', bu, -1, 2)
            NumberFontNormalSmallGray:SetFontObject'iipHotKeyFont'
        end

        if  i then
            i:SetTexCoord(.1, .9, .1, .9)
            i:SetDrawLayer'ARTWORK'
        end

        if  bu.Name then
            bu.Name:SetWidth(bu:GetWidth() + 15)
            bu.Name:SetFontObject'GameFontHighlight'
        end
    end

    ns.BUBorder = function(bu, size, height)
        if bu.bo then return end
        local x, y = (bu:GetWidth()/2) + 6, (bu:GetHeight()/2) + 7

        if  size then
            x = size
            y = size
        end

        if  height then
            y = height
        end

        bu.bo = {}

        bu.bo[1] = bu:CreateTexture(nil, 'BORDER')
        bu.bo[1]:SetTexture[[Interface\Tooltips\UI-Tooltip-Border]]
        bu.bo[1]:SetPoint('TOPLEFT', -6, 7)
        bu.bo[1]:SetSize(x, y)
        bu.bo[1]:SetTexCoord(.5, .673, 0, 1)

        bu.bo[2] = bu:CreateTexture(nil, 'BORDER')
        bu.bo[2]:SetTexture[[Interface\Tooltips\UI-Tooltip-Border]]
        bu.bo[2]:SetPoint('TOPRIGHT', 6, 7)
        bu.bo[2]:SetSize(x, y)
        bu.bo[2]:SetTexCoord(.675, .5, 0, 1)

        bu.bo[3] = bu:CreateTexture(nil, 'BORDER')
        bu.bo[3]:SetTexture[[Interface\Tooltips\UI-Tooltip-Border]]
        bu.bo[3]:SetPoint('BOTTOMLEFT', -6, -7)
        bu.bo[3]:SetSize(x, y)
        bu.bo[3]:SetTexCoord(.75875, .87325, 0, 1)
        bu.bo[3]:SetVertexColor(.9, .9, .9)

        bu.bo[4] = bu:CreateTexture(nil, 'BORDER')
        bu.bo[4]:SetTexture[[Interface\Tooltips\UI-Tooltip-Border]]
        bu.bo[4]:SetPoint('BOTTOMRIGHT', 6, -7)
        bu.bo[4]:SetSize(x, y)
        bu.bo[4]:SetTexCoord(.87325, .75875, 0, 1)
        bu.bo[4]:SetVertexColor(.9, .9, .9)
    end

    ns.BDStone = function(bu, x, path)
        bu.stone = CreateFrame('Frame', nil, bu)
        bu.stone:SetBackdrop({
            bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
            insets = {left = -2, right = -2, top = -2, bottom = -2}
        })
        bu.stone:SetBackdropColor(.05, .05, .05)
        bu.stone:SetPoint('TOPLEFT', bu, x and -x or -4, x and x or 4)
        bu.stone:SetPoint('BOTTOMRIGHT', bu, x and x or 4, x and -x or -4)
        bu.stone:SetFrameLevel(bu:GetFrameLevel() - 1)

        bu.stone.t = bu.stone:CreateTexture(nil, 'ARTWORK')
        bu.stone.t:SetAllPoints()
        bu.stone.t:SetTexture(path or [[Interface/PLAYERACTIONBARALT/STONE]])
        bu.stone.t:SetTexCoord(0, 1, .18, .3)
    end

    ns.SB = function(f)
        if  f:GetObjectType() == 'StatusBar' then
            f:SetStatusBarTexture(TEXTURE)
        else
            f:SetTexture(TEXTURE)
        end
    end


    --

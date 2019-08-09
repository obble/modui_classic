

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

    local bar = CreateFrame('Frame', 'modui_mainbar', MainMenuBar)
    bar:SetSize(1024, 128)
    bar:SetPoint'BOTTOM'

    bar.t = bar:CreateTexture(nil, 'BACKGROUND')
    bar.t:SetAllPoints()

    bar.caps = CreateFrame('Frame', 'modui_endcaps', UIParent)
    bar.caps:SetPoint('BOTTOM', bar)
    bar.caps:SetFrameLevel(1)

    MainMenuExpBar:SetSize(760, 8)
    MainMenuExpBar:ClearAllPoints()
    MainMenuExpBar:SetPoint('BOTTOM', 0, 50)

    MainMenuExpBar.t = MainMenuExpBar:CreateTexture(nil, 'BACKGROUND')
    ns.BD(MainMenuExpBar.t, 1, -.5)
    MainMenuExpBar.t:SetHeight(1)
    MainMenuExpBar.t:SetPoint('BOTTOMLEFT', MainMenuExpBar, 'TOPLEFT')
    MainMenuExpBar.t:SetPoint('BOTTOMRIGHT', MainMenuExpBar, 'TOPRIGHT')

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
                if  i > 1 and v ~= 'MultiBarLeft' then
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

    local MoveBars = function()
        if  not InCombatLockdown() then
    		MultiBarBottomLeftButton1:SetPoint('BOTTOMLEFT', MultiBarBottomLeft, 0, 6)

                MultiBarBottomRight:SetPoint('LEFT', MultiBarBottomLeft, 'RIGHT', 43, 6)

    		SlidingActionBarTexture0:SetPoint('TOPLEFT', PetActionBarFrame, 1, -5)

            StanceBarLeft:SetPoint('BOTTOMLEFT', StanceBarFrame, 0, -5)

            MultiBarBottomRightButton7:ClearAllPoints()
            MultiBarBottomRightButton7:SetPoint('LEFT', MultiBarBottomRight, 0, -2)

            PetActionButton1:ClearAllPoints()
            PetActionButton1:SetPoint('TOP', PetActionBarFrame, 'LEFT', 51, 4)
    	end
    end

    local SetBarLength = function(shorten)
        for i = 0, 3 do
            _G['MainMenuXPBarTexture'..i]:Hide()
            _G['MainMenuBarTexture'..i]:Hide()
        end
        MainMenuBarLeftEndCap:Hide()
        MainMenuBarRightEndCap:Hide()
        ActionBarUpButton:ClearAllPoints()
        ActionBarUpButton:SetPoint('LEFT', ActionButton12, 'RIGHT', -1, 10)
        ActionBarDownButton:ClearAllPoints()
        ActionBarDownButton:SetPoint('TOP', ActionBarUpButton, 'BOTTOM', 0, 10)
        MainMenuBarPageNumber:ClearAllPoints()
        MainMenuBarPageNumber:SetPoint('LEFT', ActionBarUpButton, 'RIGHT', -2, -10)
        if  shorten then
            MainMenuExpBar:SetSize(760, 8)
            bar.t:SetTexture[[Interface/Addons/modui_classic/art/mainbar/ActionBarArtLarge]]
            bar.t:SetPoint('BOTTOM', -111, -11)
            bar.caps:SetSize(950, 64)
            ActionButton1:ClearAllPoints()
            ActionButton1:SetPoint('BOTTOMLEFT', MainMenuBarArtFrame, 120, 7)
        else
            MainMenuExpBar:SetSize(500, 8)
            bar.t:SetTexture[[Interface/Addons/modui_classic/art/mainbar/ActionBarArtSmall]]
            bar.t:SetPoint('BOTTOM', -237, -11)
            bar.caps:SetSize(700, 64)
            ActionButton1:ClearAllPoints()
            ActionButton1:SetPoint('BOTTOMLEFT', MainMenuBarArtFrame, 245, 7)
        end
    end

    local UpdateBars = function()
        SetBarLength(MultiBar2_IsVisible() and true or false)
        if  not InCombatLockdown() then
    		if  MultiBarBottomLeft:IsShown() then
    			PetActionButton1:SetPoint('TOP', PetActionBarFrame, 'LEFT', 51, 4)
    			StanceButton1:SetPoint('LEFT', StanceBarFrame, 2, -4)
    		else
    			PetActionButton1:SetPoint('TOP', PetActionBarFrame, 'LEFT', 51, 7)
    			StanceButton1:SetPoint('LEFT', StanceBarFrame, 12, -2)
    		end

    		if  MultiBarLeft:IsShown() then
    			MultiBarLeft:SetScale(.795)
    			MultiBarRight:SetScale(.795)
    			MultiBarRightButton1:SetPoint('TOPRIGHT', MultiBarRight, -2, 534)
    		else
    			MultiBarLeft:SetScale(1)
    			MultiBarRight:SetScale(1)
    			MultiBarRightButton1:SetPoint('TOPRIGHT', MultiBarRight, -2, 64)
    		end
    	end
    end

    local OnEvent = function()
        MoveBars()
        UpdateBars()
    end

    for i, v in pairs(n) do
        if  i > 1 then -- skip 'action'
            local bar = _G[v]
            bar:HookScript('OnShow', UpdateBars)
            bar:HookScript('OnHide', UpdateBars)
        end
    end

    hooksecurefunc('ActionBarController_UpdateAll', UpdateBars)

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', OnEvent)


    --

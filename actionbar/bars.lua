

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

    local h = {
        'MultiBarLeft',
        'MultiBarRight',
    }

    local events = {
        'PLAYER_LOGIN',
        'PLAYER_XP_UPDATE',
        'UPDATE_EXHAUSTION',
        'PLAYER_LEVEL_UP'
    }

    local MoveBars = function()
        if  not InCombatLockdown() then
            MultiBarBottomLeft:ClearAllPoints()
            MultiBarBottomLeft:SetPoint('BOTTOMLEFT', ActionButton1, 'TOPLEFT', 0, 23)

            MultiBarBottomLeftButton1:ClearAllPoints()
            MultiBarBottomLeftButton1:SetPoint('BOTTOMLEFT', ActionButton1, 'TOPLEFT', 0, ReputationWatchBar:IsShown() and 30 or 23)

            MultiBarBottomRight:SetPoint('LEFT', MultiBarBottomLeft, 'RIGHT', 43, 6)

            SlidingActionBarTexture0:ClearAllPoints()
    		SlidingActionBarTexture0:SetPoint('TOPLEFT', PetActionButton1, -34, 12)

            MultiBarBottomRightButton7:ClearAllPoints()
            MultiBarBottomRightButton7:SetPoint('BOTTOMLEFT', MultiBarBottomRightButton1, 'TOPLEFT', 0, ReputationWatchBar:IsShown() and 31 or 24)

            PetActionButton1:ClearAllPoints()
            PetActionButton1:SetPoint('BOTTOMLEFT', MultiBarBottomLeftButton1, 'TOPLEFT', 20, 8)

            MainMenuBarVehicleLeaveButton:ClearAllPoints()
            MainMenuBarVehicleLeaveButton:SetPoint('BOTTOM', MainMenuBarBackpackButton, 'TOP', -5, 30)
    	end
    end

    local SetBarLength = function(shorten)
        local bar = _G['modui_mainbar']

        ActionBarUpButton:ClearAllPoints()
        ActionBarUpButton:SetPoint('LEFT', ActionButton12, 'RIGHT', -1, 10)

        ActionBarDownButton:ClearAllPoints()
        ActionBarDownButton:SetPoint('TOP', ActionBarUpButton, 'BOTTOM', 0, 10)

        MainMenuBarPageNumber:ClearAllPoints()
        MainMenuBarPageNumber:SetPoint('LEFT', ActionBarUpButton, 'RIGHT', -2, -10)

        if  shorten then
            MainMenuExpBar:SetSize(760, 8)
            ReputationWatchBar:SetSize(760, 6)
            ReputationWatchBar.StatusBar:SetSize(760, 6)
            ExhaustionLevelFillBar:SetSize(760, 6)
            bar.t:SetTexture[[Interface/Addons/modui_classic/art/mainbar/ActionBarArtLarge]]
            bar.t:SetPoint('BOTTOM', -111, -11)
            bar.caps:SetSize(950, 64)
            ActionButton1:ClearAllPoints()
            ActionButton1:SetPoint('BOTTOMLEFT', MainMenuBarArtFrame, 120, 7)
        else
            MainMenuExpBar:SetSize(500, 8)
            ReputationWatchBar:SetSize(500, 6)
            ReputationWatchBar.StatusBar:SetSize(500, 6)
            ExhaustionLevelFillBar:SetSize(500, 6)
            bar.t:SetTexture[[Interface/Addons/modui_classic/art/mainbar/ActionBarArtSmall]]
            bar.t:SetPoint('BOTTOM', -237, -11)
            bar.caps:SetSize(700, 64)
            ActionButton1:ClearAllPoints()
            ActionButton1:SetPoint('BOTTOMLEFT', MainMenuBarArtFrame, 245, 7)
        end
    end

    local UpdateWatchbar = function()
        if not ReputationWatchBar:IsShown() then return end
        local _, index = GetWatchedFactionInfo()
        local min, max = ReputationWatchBar.StatusBar:GetMinMaxValues()
        local v = ReputationWatchBar.StatusBar:GetValue()
        local x = (v/max)*ReputationWatchBar.StatusBar:GetWidth()
        local colour = FACTION_BAR_COLORS[index]

        ReputationWatchBar:ClearAllPoints()
        ReputationWatchBar:SetPoint('BOTTOMLEFT', MainMenuExpBar, 'TOPLEFT')
        ReputationWatchBar:SetPoint('BOTTOMRIGHT', MainMenuExpBar, 'TOPRIGHT')

		ReputationWatchBar.spark:SetPoint('CENTER', ReputationWatchBar.StatusBar, 'LEFT', x, 2)
        ReputationWatchBar.spark:SetVertexColor(colour.r, colour.g, colour.b)

        ReputationWatchBar:HookScript('OnShow', MoveBars)
        ReputationWatchBar:HookScript('OnHide', MoveBars)
    end

    local UpdateExhaustion = function()
        local xp, max = UnitXP'player', UnitXPMax'player'
        local threshold = GetXPExhaustion()
        if  threshold then
            local x = ((xp + threshold)/max)*MainMenuExpBar:GetWidth()
            ExhaustionTick:SetPoint('CENTER', MainMenuExpBar, 'LEFT', x, 0)
        end
    end

    local UpdateXP = function()
        local xp, max = UnitXP'player', UnitXPMax'player'
		local x = (xp/max)*MainMenuExpBar:GetWidth()
        local rest = GetRestState()
        UpdateExhaustion()
        if  _G['modui_mainbar'] then
    		MainMenuExpBar.spark:SetPoint('CENTER', MainMenuExpBar, 'LEFT', x, 2)
            if  rest == 1 then
                MainMenuExpBar.spark:SetVertexColor(0*1.5, .39*1.5, .88*1.5, 1)
            elseif rest == 2 then
                MainMenuExpBar.spark:SetVertexColor(.58*1.5, 0*1.5, .55*1.5, 1)
    	    end
        end
    end

    local UpdatePetBar = function()
        SlidingActionBarTexture0:ClearAllPoints()
        SlidingActionBarTexture0:SetPoint('BOTTOMLEFT', PetActionButton1, -14, -2)

        PetActionBarFrame:ClearAllPoints()
        PetActionButton1:ClearAllPoints()
        if  MODUI_VAR['elements']['mainbar'].horiz and not MODUI_VAR['elements']['mainbar'].enable then
            PetActionBarFrame:SetPoint('BOTTOMLEFT', MultiBarBottomLeftButton1, 'TOPLEFT', 20, MultiBarRight:IsShown() and 56 or MultiBarBottomLeft:IsShown() and 8 or -40)
            PetActionButton1:SetPoint('BOTTOMLEFT', MultiBarBottomLeftButton1, 'TOPLEFT', 20, MultiBarRight:IsShown() and 56 or MultiBarBottomLeft:IsShown() and 8 or -40)
        else
            PetActionBarFrame:SetPoint('BOTTOMLEFT', MultiBarBottomLeftButton1, 'TOPLEFT', 20, MultiBarBottomLeft:IsShown() and 8 or -40)
            PetActionButton1:SetPoint('BOTTOMLEFT', MultiBarBottomLeftButton1, 'TOPLEFT', 20, MultiBarBottomLeft:IsShown() and 8 or -40)
        end
    end

    local UpdateStanceBar = function()
        StanceBarLeft:ClearAllPoints()
        StanceBarLeft:SetPoint('BOTTOMLEFT', StanceButton1, -14, -2)
        StanceButton1:ClearAllPoints()
        if  MODUI_VAR['elements']['mainbar'].horiz and not MODUI_VAR['elements']['mainbar'].enable then
            StanceButton1:SetPoint('BOTTOMLEFT', MultiBarBottomLeftButton1, 'TOPLEFT', 20, MultiBarRight:IsShown() and 56 or MultiBarBottomLeft:IsShown() and 8 or -40)
        else
            StanceButton1:SetPoint('BOTTOMLEFT', MultiBarBottomLeftButton1, 'TOPLEFT', 20, MultiBarBottomLeft:IsShown() and 8 or -40)
        end
    end

    local UpdatePetStance = function()
        if  not InCombatLockdown() then
            UpdatePetBar()
            UpdateStanceBar()
        end
    end

    local UpdateBars = function()
        SetBarLength(MultiBar2_IsVisible() and true or false)
        UpdateXP()
        UpdateWatchbar()
        UpdatePetStance()
    end

    local AddXP = function()
        for i = 0, 3 do
            _G['MainMenuXPBarTexture'..i]:Hide()
            ReputationWatchBar.StatusBar['WatchBarTexture'..i]:SetAlpha(0)
            if  MODUI_VAR['elements']['mainbar'].enable  then
                _G['MainMenuBarTexture'..i]:Hide()
            end
        end

        ReputationWatchBar:SetSize(1024, 6)
        ReputationWatchBar.StatusBar:SetSize(1024, 6)

        ReputationWatchBar.spark = ReputationWatchBar:CreateTexture(nil, 'OVERLAY', nil, 7)
        ReputationWatchBar.spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
        ReputationWatchBar.spark:SetSize(35, 35)
        ReputationWatchBar.spark:SetBlendMode'ADD'

        MainMenuExpBar:SetSize(1024, 6)
        MainMenuExpBar:ClearAllPoints()
        MainMenuExpBar:SetPoint('BOTTOM', 0, MODUI_VAR['elements']['mainbar'].enable and 49 or 40)

        MainMenuExpBar.spark = MainMenuExpBar:CreateTexture(nil, 'OVERLAY', nil, 7)
        MainMenuExpBar.spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
        MainMenuExpBar.spark:SetVertexColor(.58*1.5, 0*1.5, .55*1.5, 1)
        MainMenuExpBar.spark:SetSize(35, 35)
        MainMenuExpBar.spark:SetBlendMode'ADD'

        MainMenuExpBar.sb = MainMenuExpBar:CreateTexture(nil, 'BACKGROUND', nil, -7)
        ns.SB(MainMenuExpBar.sb)
        MainMenuExpBar.sb:SetPoint('TOPLEFT', 0, -1)
        MainMenuExpBar.sb:SetPoint'BOTTOMRIGHT'
        MainMenuExpBar.sb:SetVertexColor(.5, .5, .5)

        MainMenuExpBar.t = MainMenuExpBar:CreateTexture(nil, 'BACKGROUND')
        ns.BD(MainMenuExpBar.t, 1, -.5)
        MainMenuExpBar.t:SetHeight(1)
        MainMenuExpBar.t:SetPoint('BOTTOMLEFT', MainMenuExpBar, 'TOPLEFT')
        MainMenuExpBar.t:SetPoint('BOTTOMRIGHT', MainMenuExpBar, 'TOPRIGHT')

        hooksecurefunc('MainMenuTrackingBar_Configure',     UpdateWatchbar)
        hooksecurefunc('MainMenuBar_UpdateExperienceBars',  UpdateWatchbar)
    end

    local AddButtonSkin = function()
        for _, v in pairs(n) do
            for i = 1, 12 do
                local bu = _G[v..'Button'..i]
                if  bu then
                    ns.BU(bu, .75, true, bu:GetHeight() - 2.25, bu:GetWidth() - 2.25)
                    ns.BUBorder(bu)
                    ns.BUElements(bu)
                end
            end
        end
        for _, v in pairs(x) do
            for i = 1, 10 do
                local bu = _G[v..'Button'..i]
                if  bu then
                    ns.BU(bu, .75, true, bu:GetHeight() - 2.25, bu:GetWidth() - 2.25)
                    ns.BUBorder(bu)
                    ns.BUElements(bu)
                end
            end
        end
    end

    local AddBars = function()
        local bar = CreateFrame('Frame', 'modui_mainbar', MainMenuBar)
        bar:SetSize(1024, 128)
        bar:SetPoint'BOTTOM'

        bar.t = bar:CreateTexture(nil, 'BACKGROUND')
        bar.t:SetAllPoints()
        tinsert(ns.skin, bar.t)

        bar.caps = CreateFrame('Frame', 'modui_endcaps', UIParent)
        bar.caps:SetPoint('BOTTOM', bar)
        bar.caps:SetFrameLevel(1)

        AddXP()

        MainMenuBarVehicleLeaveButton:SetSize(28, 28)
        ns.BUBorder(MainMenuBarVehicleLeaveButton, MainMenuBarVehicleLeaveButton:GetWidth() - 10, MainMenuBarVehicleLeaveButton:GetWidth() - 2, 3.5, 6)

        for _, v in pairs(n) do
            for i = 1, 12 do
                local bu = _G[v..'Button'..i]
                if  bu then
                    -- TODO: all our placement needs *MAJOR* streamlining
                    -- but i dont have time rn
                    if  v == 'MultiBarBottomRight' then
                        if  i == 1 then
                            bu:ClearAllPoints()
                            bu:SetPoint('LEFT', ActionButton12, 'RIGHT', 46, 0)
                        end
                    end

                    if  i > 1 then
                        bu:ClearAllPoints()
                        -- pixel...
                        if v == 'MultiBarRight' or v == 'MultiBarLeft' then
                            bu:SetPoint('TOP', _G[v..'Button'..(i - 1)], 'BOTTOM', 0, -8.5)
                        else
                            bu:SetPoint('LEFT', _G[v..'Button'..(i - 1)], 'RIGHT', 8.5, 0)
                        end
                        -- PERFECTION!
                        if  i == 7 and v == 'MultiBarBottomRight' then
                            bu:ClearAllPoints()
                            bu:SetPoint('BOTTOMLEFT', _G[v..'Button1'], 'TOPLEFT', 0, 17)
                        end
                    end
                end
            end
        end

        for i, v in pairs(n) do
            if  i > 1 then -- skip 'action'
                local bar = _G[v]
                bar:HookScript('OnShow', UpdateBars)
                bar:HookScript('OnHide', UpdateBars)
            end
        end

        for _, v in pairs(
            {
                MultiBarBottomLeft,
                PetActionBarFrame,
                StanceBarFrame,
            }
        ) do
            UIPARENT_MANAGED_FRAME_POSITIONS.v = nil
        end

        for _, v in pairs(
            {
                MainMenuBarLeftEndCap,
                MainMenuBarRightEndCap,
                -- fuck em, im just hiding these textures
                -- until i can be bothered to level hunter
                SlidingActionBarTexture0,
                SlidingActionBarTexture1,
            }
        ) do
            v:Hide()
        end

        hooksecurefunc('MultiActionBar_Update', MoveBars)
        hooksecurefunc('ActionBarController_UpdateAll', UpdateBars)
        hooksecurefunc('ShowPetActionBar', UpdatePetBar)
    end

    local AddHorizBars = function()
        for _, v in pairs(h) do
            for i = 1, 12 do
                local bu = _G[v..'Button'..i]
                if  v == 'MultiBarRight' then
                    if  i == 1 then
                        bu:ClearAllPoints()
                        bu:SetPoint('BOTTOMLEFT', MultiBarBottomLeftButton1, 'TOPLEFT', 0, 8)
                    else
                        bu:ClearAllPoints()
                        bu:SetPoint('LEFT', _G[v..'Button'..(i - 1)], 'RIGHT', 6, 0)
                    end
                else
                    if  i == 1 then
                        bu:ClearAllPoints()
                        bu:SetPoint('BOTTOMLEFT', MultiBarBottomRightButton1, 'TOPLEFT', 0, 8)
                    else
                        bu:ClearAllPoints()
                        bu:SetPoint('LEFT', _G[v..'Button'..(i - 1)], 'RIGHT', 6, 0)
                    end
                end
            end
        end
        for i, v in pairs(n) do
            if  i > 1 then
                local bar = _G[v]
                bar:HookScript('OnShow', UpdatePetStance)
                bar:HookScript('OnHide', UpdatePetStance)
            end
        end
        hooksecurefunc('ActionBarController_UpdateAll', UpdatePetStance)
        hooksecurefunc('ShowPetActionBar', UpdatePetBar)
    end

    local DisableXPBarForMaxLevel = function()
        local level = UnitLevel("player")
        if (level == 60)
            MainMenuMaxLevelBar:Hide()
            MainMenuMaxLevelBar0:Hide()
            MainMenuMaxLevelBar1:Hide()
            MainMenuMaxLevelBar3:Hide()
        end
    end

    local OnEvent = function(self, event)
        if  MODUI_VAR['elements']['mainbar'].enable then
            if  event == 'PLAYER_LOGIN' then
                AddBars()
                AddButtonSkin()
                MoveBars()
                UpdateBars()
                DisableXPBarForMaxLevel()
            else
                UpdateXP()
                DisableXPBarForMaxLevel()
            end
        elseif MODUI_VAR['elements']['mainbar'].xp then
            AddXP()
            UpdateXP()
        end
        if  MODUI_VAR['elements']['mainbar'].horiz and not MODUI_VAR['elements']['mainbar'].enable then
            AddHorizBars()
        end
    end

    local  e = CreateFrame'Frame'
    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnEvent', OnEvent)


    --

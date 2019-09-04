

    local _, ns = ...

    -- todo: statusbar

    GAME_TOOLTIP_BACKDROP_STYLE_DEFAULT['edgeFile'] = ''
    GAME_TOOLTIP_BACKDROP_STYLE_DEFAULT['insets'] = {left = -2, right = -2, top = -2, bottom = -2}

    local tooltips = {
        'GameTooltip',
    	'ShoppingTooltip1',
    	'ShoppingTooltip2',
    	'ItemRefTooltip',
    	'ItemRefShoppingTooltip1',
    	'ItemRefShoppingTooltip2',
    	'WorldMapTooltip',
    }

    local GetMouseoverUnit = function()
        local _, unit = GameTooltip:GetUnit()
        if not unit or not UnitExists(unit) or UnitIsUnit(unit, 'mouseover') then
            return true
        else
            return false
        end
    end

    local AddBackdrop = function(self)
        self:SetFrameLevel(999)
    	self:SetBackdropColor(0, 0, 0, 1)
        if not self.BD then
            self.BD = CreateFrame('Frame', nil, self)
            self.BD:SetPoint('TOPLEFT', -8.5, 10)
            self.BD:SetPoint('BOTTOMRIGHT', 9, -10)
            self.BD:SetBackdrop({
                bgFile     = '',
                edgeFile   = [[Interface\LFGFRAME\LFGBorder]],
                edgeSize   = 18,
            })
            tinsert(ns.skinb, self.BD)

            self.BD.shadow = self:CreateTexture(nil, 'BACKGROUND')
    		self.BD.shadow:SetPoint('TOPLEFT', self.BD, -5, 12)
    		self.BD.shadow:SetPoint('BOTTOMRIGHT', self.BD, 5, -11)
    		self.BD.shadow:SetTexture[[Interface\Scenarios\ScenarioParts]]
    		self.BD.shadow:SetVertexColor(0, 0, 0, .6)
    		self.BD.shadow:SetTexCoord(0, .641, 0, .18)
        end
    end

    local AddStatusBarBG = function(bar)
        bar.bg = bar:CreateTexture(nil, 'BACKGROUND', nil, 7)
        ns.SB(bar.bg)
        bar.bg:SetAllPoints()
        bar.bg:SetVertexColor(.15, .15, .15)
    end

    local AddStatusBar = function(bar, tooltip, vertical)
        --                        we might need to use the ugly unit offset onupdate in this function
        ns.BD(bar)
        ns.SB(bar)
        bar:SetHeight(4)
        bar:ClearAllPoints()   -- reposition hp bar left of tooltip
        if  vertical then
            bar:SetPoint('TOPLEFT', tooltip)
            bar:SetPoint('BOTTOMRIGHT', tooltip, 'BOTTOMLEFT', 5, 0)
            bar:SetOrientation'VERTICAL'
            bar:SetRotatesTexture(true)
        else
            bar:SetPoint('TOPLEFT', tooltip, 0, 0)
            bar:SetPoint('BOTTOMRIGHT', tooltip, 'TOPRIGHT', 0, -5)
            bar:SetOrientation'HORIZONTAL'
            bar:SetRotatesTexture(false)
        end

        if not bar.bg then
            AddStatusBarBG(bar)
        end
    end

    local AddAnchor = function(tooltip, parent)
		--MouseAnchor behavior below
		if MODUI_VAR['elements']['tooltip'].mouseanchor then
			--SmartAnchor behavior here
			if GetMouseFocus() ~= WorldFrame and MODUI_VAR['elements']['tooltip'].smartanchor then
				tooltip:ClearAllPoints()
				tooltip:SetOwner(parent, "ANCHOR_TOP", 0, 10)
				return
			end		
				local x, y = GetCursorPosition()
				local effScale = tooltip:GetEffectiveScale()
				tooltip:ClearAllPoints()
				tooltip:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", (x / effScale + 25), (y / effScale + -25))
		else
		--Standard modui behavior below
			if  not GetMouseoverUnit() then
				tooltip:SetOwner(parent, 'ANCHOR_CURSOR')
			else
				tooltip:ClearAllPoints()
				tooltip:SetPoint('BOTTOMRIGHT', UIParent, -33, 33)
				AddStatusBar(GameTooltipStatusBar, tooltip, false)
			end
		end
	end

	local MouseUpdate = function(tooltip, parent)
		--Don't follow if we aren't in the WorldFrame as it's irritating.
		if GetMouseFocus() ~= WorldFrame then
			return
		end		
		local x, y = GetCursorPosition()
		local effScale = tooltip:GetEffectiveScale()
		tooltip:ClearAllPoints()
		tooltip:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", (x / effScale + 25), (y / effScale + -25))
	end

    local UpdateStyle = function(self)
        local _, link = self:GetItem()
        if  self.BD then
            self.BD:ClearAllPoints()
            self.BD:SetPoint('TOPLEFT', -8.5, 10)
            self.BD:SetPoint('BOTTOMRIGHT', 9, -10)
            self.BD:SetBackdrop({
                bgFile     = '',
                edgeFile   = [[Interface\LFGFRAME\LFGBorder]],
                edgeSize   = 18,
            })
            self.BD:SetBackdropBorderColor(
                MODUI_VAR['theme'].r,
                MODUI_VAR['theme'].g,
                MODUI_VAR['theme'].b
            )
        end
    end

    local OnEvent = function(self, event)
        if  MODUI_VAR['elements']['tooltip'].enable then
            for _, v in next, tooltips do
                local f = _G[v]
                ns.BD(f)
                f:HookScript('OnShow',             AddBackdrop)
                f:HookScript('OnHide',             AddBackdrop)
                f:HookScript('OnTooltipCleared',   AddBackdrop)
            end

            hooksecurefunc('GameTooltip_UpdateStyle',       UpdateStyle)
            hooksecurefunc('GameTooltip_SetBackdropStyle',  UpdateStyle)
            hooksecurefunc('GameTooltip_SetDefaultAnchor',  AddAnchor)
			--OnUpdate hook for mouseanchor
			if MODUI_VAR['elements']['tooltip'].mouseanchor then
				GameTooltip:HookScript('OnUpdate', MouseUpdate)
			end
			
        end
    end

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', OnEvent)


    --

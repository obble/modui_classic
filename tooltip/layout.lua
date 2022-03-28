

    local _, ns = ...

    -- todo: statusbar

    --GAME_TOOLTIP_BACKDROP_STYLE_DEFAULT['edgeFile'] = ''
    --GAME_TOOLTIP_BACKDROP_STYLE_DEFAULT['insets'] = {left = -2, right = -2, top = -2, bottom = -2}



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
        self:SetBackdropColor(0, 0, 0, 0.7)

        if not self.BD then
            self.BD = CreateFrame('Frame', nil, self, "BackdropTemplate")
            self.BD:ClearAllPoints()
            self.BD:SetPoint('TOPLEFT', -8.5, 10)
            self.BD:SetPoint('BOTTOMRIGHT', 9, -10)
            self.BD:SetBackdrop({
                bgFile     = '',
                edgeFile   = [[Interface\LFGFRAME\LFGBorder]],
                edgeSize   = 18,
                insets = {left = -2, right = -2, top = -2, bottom = -2},
            })
            tinsert(ns.skinb, self.BD)
            self.BD:SetBackdropBorderColor(
                            MODUI_VAR['theme'].r,
                            MODUI_VAR['theme'].g,
                            MODUI_VAR['theme'].b
            )

--             self.BD.shadow = self:CreateTexture(nil, 'BACKGROUND')
--     		self.BD.shadow:SetPoint('TOPLEFT', self.BD, 0, 0)
--     		self.BD.shadow:SetPoint('BOTTOMRIGHT', self.BD, 0, 0)
--     		self.BD.shadow:SetTexture[[Interface\Scenarios\ScenarioParts]]
--     		self.BD.shadow:SetVertexColor(0, 0, 0, .6)
--     		self.BD.shadow:SetTexCoord(0, .641, 0, .18)
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

    local MouseUpdate = function(tooltip, parent)
		if  GetMouseFocus() ~= WorldFrame then
			return
		end
		local x, y  = GetCursorPosition()
		local scale = tooltip:GetEffectiveScale()
		tooltip:ClearAllPoints()
		tooltip:SetPoint('TOPLEFT', UIParent, 'BOTTOMLEFT', (x/scale + 25), (y/scale + -5))
	end

    local AddAnchor = function(tooltip, parent)
        local isUnit = GetMouseoverUnit()
        if  MODUI_VAR['elements']['tooltip'].mouseanchor then
            if  GetMouseFocus() ~= WorldFrame then
                tooltip:ClearAllPoints()
                tooltip:SetOwner(parent, 'ANCHOR_TOPRIGHT', 0, 10)
            else
                MouseUpdate(tooltip, parent)
                AddStatusBar(GameTooltipStatusBar, tooltip, false)
            end
        else
            if  not isUnit then
                tooltip:ClearAllPoints()
                tooltip:SetOwner(parent, 'ANCHOR_TOPRIGHT', 0, 10)
            else
                tooltip:ClearAllPoints()
                tooltip:SetPoint('BOTTOMRIGHT', UIParent, -33, 33)
                AddStatusBar(GameTooltipStatusBar, tooltip, false)
            end
        end
    end

    local UpdateStyle = function(self)

        if  self.BD then
            self.BD:ClearAllPoints()
            self.BD:SetPoint('TOPLEFT', -8.5, 10)
            self.BD:SetPoint('BOTTOMRIGHT', 9, -10)
            self.BD:SetBackdrop({
                bgFile     = '',
                edgeFile   = [[Interface\LFGFRAME\LFGBorder]],
                edgeSize   = 16,
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

                f:SetBackdropBorderColor(0, 0, 0, 1)
                f.SetBackdropBorderColor = function() end

                if f.NineSlice then
                    f.NineSlice:SetAlpha(0)
                end

                ns.BD(f)
                f:HookScript('OnShow',             AddBackdrop)
                f:HookScript('OnHide',             AddBackdrop)
                f:HookScript('OnTooltipCleared',   AddBackdrop)
            end


--             hooksecurefunc('GameTooltip_UpdateStyle',       UpdateStyle)
--             hooksecurefunc('SharedTooltip_SetBackdropStyle',  UpdateStyle)
            hooksecurefunc('GameTooltip_SetDefaultAnchor',  AddAnchor)
            if MODUI_VAR['elements']['tooltip'].mouseanchor then
				GameTooltip:HookScript('OnUpdate', MouseUpdate)
            end
            if  MODUI_VAR['elements']['tooltip'].disablefade then
                self.hasUnitTooltip = false
                self:SetScript('OnUpdate', function(self)
                    local mouseoverExists = UnitExists("mouseover")
                    if self.hasUnitTooltip and not mouseoverExists then
                        GameTooltip:Hide()
                        self.hasUnitTooltip = nil
                    elseif not self.hasUnitTooltip and mouseoverExists then
                        self.hasUnitTooltip = true
                    end
                end)
            end
        end
    end

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', OnEvent)


    --

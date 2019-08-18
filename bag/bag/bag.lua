

	local _, ns = ...

	local FONT_REGULAR = ns.FONT_REGULAR

	local AddSparkle = function(bu)
		bu.sparkle = CreateFrame('Button', bu:GetName()..'sparkle', bu, 'AutoCastShineTemplate')
		bu.sparkle:RegisterForClicks'NONE'
		bu.sparkle:SetAllPoints()
		bu.sparkle:Hide()
	end

	local ToggleSparkle = function(i, j, enter)
		local bu = _G['ContainerFrame'..i..'Item'..j]

		if not bu.sparkle then AddSparkle(bu) end

		if enter then
			bu.sparkle:SetFrameStrata'HIGH'
			bu.sparkle:Show()
			AutoCastShine_AutoCastStart(bu.sparkle, 0, 1, 0)
		else
			bu.sparkle:SetFrameStrata'LOW'
			bu.sparkle:Hide()
			AutoCastShine_AutoCastStop(bu.sparkle)
		end
	end

	local IterateForSparkle = function(self, enter)
		if self.isMainBag then
			for j = 1, GetContainerNumSlots(0) do
				ToggleSparkle(1, j, enter)
			end
		else
			local id = self:GetID() - CharacterBag0Slot:GetID() + 1
			for i = 1, NUM_CONTAINER_FRAMES do
				local frame = _G['ContainerFrame'..i]
				if frame:GetID() == id then
					for j = 1, GetContainerNumSlots(id) do
						ToggleSparkle(i, j, enter)
					end
				end
			end
		end
	end

	local OnEnter = function(self)
		if  _G['modbag']:IsShown() then
			self.isMainBag = true
			IterateForSparkle(self, true)
		end
	end

	local OnLeave = function(self)
		IterateForSparkle(self, false)
	end

	local ShowBags = function(self)
        for i = 0, 3 do
            local s = _G['CharacterBag'..i..'Slot']
            s:SetAlpha(1)
            s:EnableMouse(true)
        end
    end

    local HideBags = function(self)
        for i = 0, 3 do
            local s = _G['CharacterBag'..i..'Slot']
            s:SetAlpha(0)
            s:EnableMouse(false)
        end
    end

	local AddBag = function()
		local bag = CreateFrame('Frame', 'modbag', UIParent, 'ButtonFrameTemplate')
		bag:SetPoint('BOTTOMRIGHT', -27, 240)
		bag:SetFrameLevel(3)
		bag:Hide()
		for _, v in pairs({bag:GetRegions()}) do tinsert(ns.skin, v) end

		bag.portrait = bag:CreateTexture(nil, 'BORDER', nil, 7)
		bag.portrait:SetSize(64, 64)
		bag.portrait:SetPoint('TOPLEFT', -8, 8)
		bag.portrait:SetAlpha(1)
		SetPortraitToTexture(bag.portrait, [[Interface\ICONS\Inv_misc_bag_08]])

		bag.name = bag:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		bag.name:SetFont(FONT_REGULAR, 10)
		bag.name:SetText'Bag'
		bag.name:SetPoint('TOPLEFT', 63, -6)
		bag.name:SetTextColor(1, .7, 0)

		bag.bd = CreateFrame('Frame', nil, bag)
		ns.BD(bag.bd)
		bag.bd:SetPoint('TOPLEFT', 8, -58)
		bag.bd:SetPoint('BOTTOMRIGHT', -10, 27)

		bag.bd.t = bag.bd:CreateTexture(nil, 'ARTWORK')
		bag.bd.t:SetAllPoints()
		bag.bd.t:SetTexture([[Interface/Garrison/ClassHallBackground]], true, true)
		bag.bd.t:SetHorizTile(true)
		bag.bd.t:SetVertTile(true)
		bag.bd.t:SetVertexColor(.8, .8, .8)

		bag.topstrip = CreateFrame('Frame', nil, bag)
		bag.topstrip:SetHeight(25)
		bag.topstrip:SetPoint('TOPLEFT', bag, 60, -28)
		bag.topstrip:SetPoint('TOPRIGHT', -10, -28)

		local money = ContainerFrame1MoneyFrame
		money:SetParent(bag)
		money:ClearAllPoints()
		money:SetPoint('BOTTOMRIGHT', 0, 7)
		money:SetFrameStrata'MEDIUM'
		money:SetFrameLevel(3)

		for _, v in pairs(
			{
				ContainerFrame1MoneyFrameCopperButtonText,
				ContainerFrame1MoneyFrameSilverButtonText,
				ContainerFrame1MoneyFrameGoldButtonText
			}
		) do
			v:SetFont(FONT_REGULAR, 10, 'OUTLINE')
			v:SetShadowOffset(0, 0)
		end

		if  MODUI_VAR['elements']['mainbar'].enable then
			for i = 0, 3 do
				local slot = _G['CharacterBag'..i..'Slot']
				local icon = _G['CharacterBag'..i..'SlotIconTexture']

				slot:UnregisterEvent'ITEM_PUSH'
				slot:SetNormalTexture''
				slot:SetCheckedTexture''
				slot:SetHighlightTexture''
				slot:SetSize(16, 12)
				slot:SetFrameStrata'MEDIUM'
				slot:SetParent(bag.topstrip)
				slot:ClearAllPoints()

				ns.BD(slot)
				ns.BDStone(slot, 5)

				slot.IconBorder:SetAlpha(0)

				icon:SetTexCoord(.1, .9, .4, .6)

				if  i == 0 then
					slot:SetPoint('RIGHT', bag.topstrip, 0, 3)
				else
					slot:SetPoint('RIGHT', _G['CharacterBag'..(i - 1)..'Slot'], 'LEFT', -9, 0)
				end

				slot:SetScript('OnEnter', function(self)
					IterateForSparkle(self, true)
				end)
				slot:SetScript('OnLeave', function(self)
					IterateForSparkle(self, false)
				end)

				slot:SetScript('OnClick', nil)
			end
		end

		MainMenuBarBackpackButton:HookScript('OnEnter', OnEnter)
		MainMenuBarBackpackButton:HookScript('OnLeave', OnLeave)
	end

	local AddBagSlots = function()
		for i = 0, 3 do
			local slot = _G['CharacterBag'..i..'Slot']
			local icon = _G['CharacterBag'..i..'SlotIconTexture']

			slot:UnregisterEvent'ITEM_PUSH'
			slot:SetNormalTexture''
			slot:SetCheckedTexture''
			slot:SetHighlightTexture''
			slot:SetSize(16, 16)
			slot:SetFrameStrata'MEDIUM'
			slot:ClearAllPoints()

			local mask = slot:CreateMaskTexture()
	        mask:SetTexture[[Interface\Minimap\UI-Minimap-Background]]
	        mask:SetPoint('TOPLEFT', -3, 3)
	        mask:SetPoint('BOTTOMRIGHT', 3, -3)

	        icon:AddMaskTexture(mask)

	        if  not slot.bo then
	            slot.bo = slot:CreateTexture(nil, 'OVERLAY')
	            slot.bo:SetSize(36, 36)
	            slot.bo:SetTexture[[Interface\Artifacts\Artifacts]]
	            slot.bo:SetPoint'CENTER'
	            slot.bo:SetTexCoord(.5, .58, .8775, .9575)
	            slot.bo:SetDesaturated(1)
	        end

			slot.IconBorder:SetAlpha(0)

			icon:SetTexCoord(.1, .9, .4, .6)

			if  i == 0 then
				slot:SetPoint('BOTTOM', MainMenuBarBackpackButton, 'TOP', 0, 15)
			else
				slot:SetPoint('BOTTOM', _G['CharacterBag'..(i - 1)..'Slot'], 'TOP', 0, 3)
			end

			slot:SetScript('OnEnter', function(self)
				IterateForSparkle(self, true)
				ShowBags()
			end)
			slot:SetScript('OnLeave', function(self)
				IterateForSparkle(self, false)
				HideBags()
			end)

			slot:SetScript('OnClick', nil)
		end

		local bu = MainMenuBarBackpackButton
		bu.mouseover = CreateFrame('Button', nil, bu)
		bu.mouseover:SetSize(30, 100)
		bu.mouseover:SetPoint('BOTTOM', bu, 'TOP')
		bu.mouseover:SetFrameLevel(10)
		bu.mouseover:SetScript('OnEnter', ShowBags)
		bu.mouseover:SetScript('OnLeave', HideBags)

		bu:HookScript('OnEnter', function()
			IterateForSparkle(self, true)
			ShowBags()
		end)
		bu:HookScript('OnLeave', function(self)
			IterateForSparkle(self, false)
			HideBags()
		end)
	end

	local OnEvent = function()
		if  MODUI_VAR['elements']['onebag'].enable then
			AddBag()
		elseif  MODUI_VAR['elements']['mainbar'].enable then
			AddBagSlots()
		end
	end

	local e = CreateFrame'Frame'
	e:RegisterEvent'PLAYER_LOGIN'
	e:SetScript('OnEvent', OnEvent)


	--

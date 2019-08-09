

	local _, ns = ...

	local FONT_REGULAR = ns.FONT_REGULAR

	local bag = CreateFrame('Frame', 'iipbag' , UIParent, 'ButtonFrameTemplate')
	bag:SetPoint('BOTTOMRIGHT', -27, 240)
	bag:SetFrameLevel(3)
	bag:Hide()

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

	local AddBagElements = function()
		local money = ContainerFrame1MoneyFrame
		money:SetParent(bag)
		money:ClearAllPoints()
		money:SetPoint('BOTTOMRIGHT', 0, 7)
		money:SetFrameStrata'MEDIUM'
		money:SetFrameLevel(3)

		--[[local sort = BagItemAutoSortButton
		sort:SetParent(bag.topstrip)
		sort:ClearAllPoints()
		sort:SetPoint('TOPRIGHT', -5, -5)
		SetSortBagsRightToLeft(true)
		SetInsertItemsLeftToRight(false)
		sort:SetSize(12, 12)
		ns.BD(sort)
		ns.BDStone(sort, 5)]]

		--[[local search = BagItemSearchBox
		search:SetSize(68, 12)
		search:SetParent(bag.topstrip)
		search:ClearAllPoints()
		search:SetPoint('RIGHT', _G['CharacterBag3Slot'], 'LEFT', -8, 0)
		ns.BD(search)
		ns.BDStone(search, 5)]

		search.Instructions:ClearAllPoints()
		search.Instructions:SetPoint('TOPLEFT', 16, 0)
		search.Instructions:SetPoint('BOTTOMRIGHT', -8, 0)

		search.clearButton:ClearAllPoints()
		search.clearButton:SetPoint('RIGHT', 2, 0)

		search.searchIcon:ClearAllPoints()
		search.searchIcon:SetPoint('LEFT', 1, -1)

		--BagItemSearchBoxText:SetWidth(100)

		BackpackTokenFrame:GetRegions():Hide()]]

		for _, v in pairs({
			ContainerFrame1MoneyFrameCopperButtonText,
			ContainerFrame1MoneyFrameSilverButtonText,
			ContainerFrame1MoneyFrameGoldButtonText}) do
			v:SetFont(FONT_REGULAR, 10, 'OUTLINE')
			v:SetShadowOffset(0, 0)
		end

		--[[for i = 1, MAX_WATCHED_TOKENS do
			local token = _G['BackpackTokenFrameToken'..i]
			local count = _G['BackpackTokenFrameToken'..i..'Count']
			local icon  = _G['BackpackTokenFrameToken'..i..'Icon']

			token:SetParent(bag)
			token:SetFrameStrata'HIGH'
			token:ClearAllPoints()

			count:SetFont(FONT_REGULAR, 10, 'OUTLINE')
			count:SetShadowOffset(0, 0)
			count:ClearAllPoints()
			count:SetPoint'LEFT'

			if i == 1 then
				token:SetPoint('BOTTOMLEFT', 0, 8)
			else
				token:SetPoint('LEFT', _G['BackpackTokenFrameToken'..(i - 1)], 'RIGHT', -7, 0)
			end
		end]]
	end

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

	for i = 0, 3 do
		local slot = _G['CharacterBag'..i..'Slot']
		local icon = _G['CharacterBag'..i..'SlotIconTexture']

		slot:UnregisterEvent'ITEM_PUSH'
		slot:SetNormalTexture''
		-- slot:SetCheckedTexture''
		slot:SetHighlightTexture''
		slot:SetParent(bag)
		slot:SetSize(16, 12)
		slot:SetFrameStrata'MEDIUM'
		slot:SetParent(bag.topstrip)
		slot:ClearAllPoints()

		ns.BD(slot)
		ns.BDStone(slot, 5)

		slot.IconBorder:SetAlpha(0)

		icon:SetTexCoord(.1, .9, .225, .775)

		if  i == 0 then
			slot:SetPoint('RIGHT', BagItemAutoSortButton, 'LEFT', -8, 0)
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

	MainMenuBarBackpackButton:HookScript('OnEnter', function(self)
		if  bag:IsShown() then
			self.isMainBag = true
			IterateForSparkle(self, true)
		end
	end)

	MainMenuBarBackpackButton:HookScript('OnLeave', function(self)
		IterateForSparkle(self, false)
	end)

	AddBagElements()
	hooksecurefunc('ContainerFrame_Update', AddBagElements)


	--



	local _, ns = ...

	local size, spacing = 28, 9
	local buttons, bankbuttons = {}, {}

	local ibag  = _G['iipbag']
	local ibank = _G['iipbank']

	SetSortBagsRightToLeft(true)
	SetInsertItemsLeftToRight(false)

	local grab_slots = function()
		local numBags = 1
		for i = 1, NUM_BAG_FRAMES do
			local bagName = 'ContainerFrame'..i + 1
			if  _G[bagName]:IsShown() and not _G[bagName..'BackgroundTop']:GetTexture():find'Bank' then
				numBags = numBags + 1
			end
		end
		return numBags
	end

	local BagSpace = function()
		local ct = 0
		for bag = 0, NUM_BAG_SLOTS do
			for slot = 1, GetContainerNumSlots(bag) do
				local  link = GetContainerItemLink(bag, slot)
				if not link then ct = ct + 1 end
			end
		end
		return ct
	end

	local BagMaxSpace = function()
		local ct = 0
		for bag = 0, NUM_BAG_SLOTS do
			for slot = 1, GetContainerNumSlots(bag) do
				ct = ct + 1
			end
		end
		return ct
	end

	local BankSpace = function()
		local ct = 0
		for i = 1, 28 do
		    local  id   = BankButtonIDToInvSlotID(i)
			local  link = GetInventoryItemLink('player', id)
			if not link then ct = ct + 1 end
		end
		for bag = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
			for slot = 1, GetContainerNumSlots(bag) do
				local  link = GetContainerItemLink(bag, slot)
				if not link then ct = ct + 1 end
			end
		end
		return ct
	end

	local BankMaxSpace = function()
		local ct = 28	--  account for standard bank slots
		for bag = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
			for slot = 1, GetContainerNumSlots(bag) do
				ct = ct + 1
			end
		end
		return ct
	end

	local HideBags = function(bagName)
		local  bag = _G[bagName]
		if not bag.stripped then
			for i = 1, 7 do select(i, bag:GetRegions()):SetAlpha(0) end
			bag:EnableMouse(false)
			bag.ClickableTitleFrame:EnableMouse(false)
			_G[bagName..'CloseButton']:Hide()
			_G[bagName..'PortraitButton']:EnableMouse(false)
			bag.stripped = true
		end
	end

	local HideBagSmall = function()
		local hidden = nil
		for i = 0, 3 do
			local slot = _G['CharacterBag'..i..'Slot']
			if  GetInventoryItemTexture('player', slot:GetID()) then
				slot:Show()
			else
				slot:Hide()
				hidden = true
			end
		end
		if  hidden then
			BagItemSearchBox:Hide()
		else
			BagItemSearchBox:Show()
		end
	end

	local AddBankSlotPurchase = function()
		local num, full = GetNumBankSlots()
		local cost      = GetBankSlotCost(num)

		ibank.purchase:Hide()

		if not full then
			ibank.purchase:Show()

			_G['iipBankPurchaseSilverButton']:Hide()
			_G['iipBankPurchaseCopperButton']:Hide()

			MoneyFrame_Update(ibank.purchase, cost)

			ibank.purchase:SetScript('OnClick', function()
				PlaySound'igMainMenuOption'
				StaticPopup_Show'CONFIRM_BUY_BANK_SLOT'
			end)
		end
	end

	local HideBank = function()
		BankFrame:EnableMouse(false)
		BankFrame:DisableDrawLayer'BACKGROUND'
		BankFrame:DisableDrawLayer'BORDER'
		BankFrame:DisableDrawLayer'OVERLAY'

		BankSlotsFrame:DisableDrawLayer'BORDER'

		BankItemAutoSortButton:EnableMouse(false)
		BankItemAutoSortButton:SetAlpha(0)

		BankPortraitTexture:SetTexture''

		for _,  v in pairs({BankFrame:GetRegions()}) do
			if  v:GetObjectType() == 'Texture' then
				v:SetTexture''
				v:SetAlpha(0)
			end
		end

		for _, v in pairs({
			BankFrameCloseButton,
			BankFrameMoneyFrame,
			BankItemSearchBox,
			BankPortraitTexture,
			BankFramePurchaseInfo,
			BankFrame.NineSlice
		}) do
			v:Hide()
		end
	end

	local HideReagentBank = function()
		ReagentBankFrame:DisableDrawLayer'BACKGROUND'
		ReagentBankFrame:DisableDrawLayer'BORDER'
		ReagentBankFrame:DisableDrawLayer'ARTWORK'
		ReagentBankFrame:DisableDrawLayer'OVERLAY'
	end

	local HideBankArt = function()	-- previously bankArtToggle(x) (we dont need x)
		AddBankSlotPurchase()
		HideBank()
		HideReagentBank()

		if  ibank:GetWidth() < 200 then
			ibank.RBname.t:SetText'R.B.'
		end

		if  BankFrame:IsShown() then
			ibank.name.t:SetTextColor(1, 1, 1)
			ibank.RBname.t:SetTextColor(1, .7, 0)
			for i = 1, 2 do
				local tab = _G['BankFrameTab'..i]
				tab:Hide()
			end
		end

		for _, v in pairs({BankFrameMoneyFrameInset, BankFrameMoneyFrameBorder}) do
			v:Hide()
		end
	end

	local AddBG = function(bu)
		bu.bg = bu:CreateTexture(nil, 'BACKGROUND', nil, 7)
		bu.bg:SetTexture[[Interface\PaperDoll\UI-Backpack-EmptySlot]]
		bu.bg:SetTexCoord(.1, .9, .1, .9)
		bu.bg:SetAlpha(.5)
		bu.bg:SetAllPoints()
	end

	local bu, con, bag, col, row
	local MoveButtons = function(table, frame)
		local columns = ceil(sqrt(#table))
		col, row = 0, 0

		for i = 1, #table do
			bu = table[i]
			bu:SetSize(size, size)
			bu:ClearAllPoints()
			bu:SetPoint('TOPLEFT', frame, col*(size + spacing) + 9, -1*row*(size + spacing) - 58)

			if not bu.bg then AddBG(bu) end

			if col > (columns - 2) then
				col = 0
				row = row + 1
			else
				col = col + 1
			end
		end

		frame:SetHeight((row + (col == 0 and 0 or 1))*(size + spacing) + 83)
		frame:SetWidth(columns*size + spacing*(columns - 1) + 20)
		col, row = 0, 0
	end

	local ReAnchor = function()
		wipe(buttons)
		HideBagSmall()
		for f = 1, grab_slots() do
			con = 'ContainerFrame'..f
			HideBags(con)
			for i = GetContainerNumSlots(_G[con]:GetID()), 1, -1 do
				bu = _G[con..'Item'..i]
				tinsert(buttons, bu)
				ns.AddButtonStyle(bu)
			end
			ns.ColourUpdate(_G[con])
		end
		MoveButtons(buttons, ibag)
		ibag:Show()
	end

	local cachedBankWidth, cachedBankHeight				-- setup bank
	local ReAnchorBank = function(noMoving)
		for _, button in pairs(bankbuttons) do button:Hide() end

		wipe(bankbuttons)

		for i = 1, 28 do
			local bu = _G['BankFrameItem'..i]
			tinsert(bankbuttons, bu)
			ns.AddButtonStyle(bu)
			ns.BankColourUpdate(bu)
			bu:Show()
		end

		local bagNameCount = 0
		for f = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
			bagNameCount = bagNameCount + 1
			con = 'ContainerFrame'..grab_slots() + bagNameCount
			HideBags(con)
			for i = GetContainerNumSlots(f), 1, -1  do
				bu = _G[con..'Item'..i]
				tinsert(bankbuttons, bu)
				ns.AddButtonStyle(bu)
				ns.BankColourUpdate(bu)
				bu:Show()
			end
		end

		if not noMoving then
			MoveButtons(bankbuttons, ibank)
			cachedBankWidth  = ibank:GetWidth()
			cachedBankHeight = ibank:GetHeight()
		else
			ibank:SetWidth(cachedBankWidth)
			ibank:SetHeight(cachedBankHeight)
		end

		if ibank:GetWidth() < 200 then
			for i = 1, 7 do BankSlotsFrame['Bag'..i]:SetScale(.85) end
		end

		ibank:Show()
		ibank.purchase:Show()
		for i = 1, 7 do
			BankSlotsFrame['Bag'..i]:Show()
		end
	end

	local reagentMoved = false
	local cachedReagentBankWidth, cachedReagentBankHeight
	local ReAnchorReagentBank = function()
		for _, button in pairs(bankbuttons) do button:Hide() end

		wipe(bankbuttons)

		for i = 1, 98 do
			local bu = _G['ReagentBankFrameItem'..i]
			tinsert(bankbuttons, bu)
			ns.AddButtonStyle(bu)
			ns.BankColourUpdate(bu)
			bu:Show()
		end

		if not reagentMoved then
			MoveButtons(bankbuttons, ibank)
			ReagentBankFrameUnlockInfo:SetParent(_G['ReagentBankFrameItem1'])
			ReagentBankFrameUnlockInfo:SetFrameStrata'HIGH'
			ReagentBankFrameUnlockInfo:ClearAllPoints()
			ReagentBankFrameUnlockInfo:SetPoint('TOPLEFT', ibank, 0, -55)
			ReagentBankFrameUnlockInfo:SetPoint('BOTTOMRIGHT', ibank, -2, 20)
			ReagentBankFrameUnlockInfoText:SetSize(200, 64)
			ReagentBankFrameUnlockInfoText:SetFontObject'GameFontHighlight'
			cachedReagentBankWidth  = ibank:GetWidth()
			cachedReagentBankHeight = ibank:GetHeight()
			reagentMoved = true
		else
			ibank:SetSize(cachedReagentBankWidth, cachedReagentBankHeight)
		end

		ReagentBankFrame.DespositButton:ClearAllPoints()	-- lolwat typo
		ReagentBankFrame.DespositButton:SetPoint('BOTTOM', ibank, 0, 6)
		ReagentBankFrame.DespositButton:SetScale(.8)

		ibank:Show()
		ibank.purchase:Hide()
		for i = 1, 7 do
			BankSlotsFrame['Bag'..i]:Hide()
		end
	end

	local CloseBags = function()					-- toggle functions
		HideBankArt()
		for i = 0, 11 do CloseBag(i) end
		for _, v in pairs({ibag, ibank}) do v:Hide() end
	end

	local CloseBags2 = function()
		CloseBankFrame()
		for _, v in pairs({ibag, ibank}) do v:Hide() end
	end

	local OpenBags = function()
		HideBankArt()
		for i = 0, 4 do OpenBag(i) end
	end

	local ToggleBags = function()
		if  IsBagOpen(0) then
			CloseBankFrame()
			CloseBags()
		else OpenBags() end
	end

	for i = 1, 5 do
		local bag = _G['ContainerFrame'..i]
		hooksecurefunc(bag, 'Show', ReAnchor)
		hooksecurefunc(bag, 'Hide', CloseBags2)
	end

	hooksecurefunc(BankFrame, 'Show', function()
		for i = 0, 11 do OpenBag(i) end
		ReAnchorBank()
		HideBankArt()
	end)

	hooksecurefunc(BankFrame, 'Hide', function()
		CloseBags()
		HideBankArt()
	end)

	BagSlotButton_OnClick = function(self)
		local id = self:GetID()
		local hadItem = PutItemInBag(id)
		return
	end

	BankFrameItemButtonBag_OnClick = function(self, button)
		local id = self:GetInventorySlot()
		local hadItem = PutItemInBag(id)
		if not hadItem then return end
	end

	local HideBank = function()
		for i = 1, 28 do
			_G['BankFrameItem'..i]:Hide()
		end
		for i = 5, 11 do CloseBag(i) end
		ibank:Hide()
		ReAnchor()
	end

	ReagentBankFrame:HookScript('OnShow', ReAnchorReagentBank)
	ReagentBankFrame:HookScript('OnHide', function()
		if  BankFrame:IsShown() then
			for i = 0, 11 do OpenBag(i) end
			HideBankArt()
			ReAnchorBank()
		end
	end)

	function UpdateContainerFrameAnchors() end
	ToggleBackpack = ToggleBags
	ToggleBag      = ToggleBags
	OpenAllBags    = OpenBags
	OpenBackpack   = OpenBags
	CloseAllBags   = CloseBags

	hooksecurefunc('ContainerFrame_Update', HideBagSmall)

	ibag.CloseButton:SetScript('OnClick', ToggleBags)
	ibank.CloseButton:SetScript('OnClick', function() HideBank() CloseBankFrame() HideBankArt() end)

	--

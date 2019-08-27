

	local _, ns = ...

	local size, spacing = 28, 9
	local buttons, bankbuttons = {}, {}

	--SetSortBagsRightToLeft(true)
	-- SetInsertItemsLeftToRight(false)

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
		--[[if  hidden then
			BagItemSearchBox:Hide()
		else
			BagItemSearchBox:Show()
		end]]
	end

	local AddBankSlotPurchase = function()
		local bank 		= _G['modbank']
		local num, full = GetNumBankSlots()
		local cost      = GetBankSlotCost(num)

		bank.purchase:Hide()

		if not full then
			bank.purchase:Show()

			_G['modBankPurchaseSilverButton']:Hide()
			_G['modBankPurchaseCopperButton']:Hide()

			MoneyFrame_Update(bank.purchase, cost)

			bank.purchase:SetScript('OnClick', function()
				--PlaySound'igMainMenuOption'
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

		--BankItemAutoSortButton:EnableMouse(false)
		--BankItemAutoSortButton:SetAlpha(0)

		BankCloseButton:Hide()
		BankPortraitTexture:SetTexture''

		for _,  v in pairs({BankFrame:GetRegions()}) do
			if  v:GetObjectType() == 'Texture' then
				v:SetTexture''
				v:SetAlpha(0)
			elseif v:GetObjectType() == 'FontString' then
				v:SetText''
				v:Hide()
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
		--HideReagentBank()

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

	local FixSlots = function(bag)
		for i = 0, 3 do
			local bu = _G['CharacterBag'..i..'Slot']
			local icon = _G['CharacterBag'..i..'SlotIconTexture']
			if  MODUI_VAR['elements']['mainbar'].enable then
				bu:SetSize(18, 12)
				icon:SetTexCoord(.1, .9, .2, .8)
			end
		end
	end

	local ReAnchor = function()
		local bag = _G['modbag']
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
		MoveButtons(buttons, bag)
		FixSlots(bag)
		bag:Show()
	end

	local cachedBankWidth, cachedBankHeight				-- setup bank
	local ReAnchorBank = function(noMoving)
		local bank = _G['modbank']
		for _, button in pairs(bankbuttons) do button:Hide() end

		wipe(bankbuttons)

		for i = 1, 24 do
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
			MoveButtons(bankbuttons, bank)
			cachedBankWidth  = bank:GetWidth()
			cachedBankHeight = bank:GetHeight()
		else
			bank:SetWidth(cachedBankWidth)
			bank:SetHeight(cachedBankHeight)
		end

		if bank:GetWidth() < 200 then
			for i = 1, 6 do BankSlotsFrame['Bag'..i]:SetScale(.85) end
		end

		bank:Show()
		bank.purchase:Show()
		for i = 1, 6 do
			BankSlotsFrame['Bag'..i]:Show()
		end
	end

	local CloseBags = function()					-- toggle functions
		local bag  = _G['modbag']
		local bank  = _G['modbank']
		HideBankArt()
		for i = 0, 11 do CloseBag(i) end
		for _, v in pairs({bag, bank}) do v:Hide() end
	end

	local CloseBags2 = function()
		local bag  = _G['modbag']
		local bagnk = _G['modbank']
		CloseBankFrame()
		for _, v in pairs({bag, bank}) do v:Hide() end
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

	local HideBank = function()
		local bank = _G['modbank']
		for i = 1, 24 do
			_G['BankFrameItem'..i]:Hide()
		end
		for i = 5, 11 do CloseBag(i) end
		bank:Hide()
		ReAnchor()
	end

	local AddUpdates = function()
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

		function UpdateContainerFrameAnchors() end
		ToggleBackpack = ToggleBags
		ToggleBag      = ToggleBags
		OpenAllBags    = OpenBags
		OpenBackpack   = OpenBags
		CloseAllBags   = CloseBags

		hooksecurefunc('ContainerFrame_Update', HideBagSmall)

		_G['modbag'].CloseButton:SetScript('OnClick', ToggleBags)
		_G['modbank'].CloseButton:SetScript('OnClick', function() HideBank() CloseBankFrame() HideBankArt() end)
	end

	local OnEvent = function()
		if  MODUI_VAR['elements']['onebag'].enable then
			AddUpdates()
		end
	end

	local e = CreateFrame'Frame'
	e:RegisterEvent'PLAYER_LOGIN'
	e:SetScript('OnEvent', OnEvent)

	--

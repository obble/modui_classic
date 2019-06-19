

	local _, ns = ...

	local FONT_REGULAR = ns.FONT_REGULAR

	local bag = _G['iipbag']

	local bank = CreateFrame('Button', 'iipbank', UIParent, 'ButtonFrameTemplate')
	bank:SetPoint('BOTTOMRIGHT', bag, 'BOTTOMLEFT', -20, 0)
	bank:SetFrameLevel(5)
	bank:Hide()

	bank.portrait = bank:CreateTexture(nil, 'BORDER', nil, 7)
	bank.portrait:SetSize(64, 64)
	bank.portrait:SetPoint('TOPLEFT', -8, 8)
	bank.portrait:SetAlpha(1)
	SetPortraitToTexture(bank.portrait, UnitFactionGroup'player' == 'Alliance' and [[Interface\ICONS\Garrison_goldchestalliance]] or [[Interface\ICONS\Garrison_goldchesthorde]])

	bank.name = CreateFrame('Button', nil, bank)
	bank.name:SetPoint('TOPLEFT', 65, -5)

	bank.name.t = bank.name:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
	bank.name.t:SetText'Bank'
	bank.name.t:SetAllPoints()
	bank.name:SetSize(35, 12)

	bank.RBname = CreateFrame('Button', nil, bank)
	bank.RBname:SetPoint('LEFT', bank.name, 'RIGHT', 6,  0)

	bank.RBname.t = bank.RBname:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
	bank.RBname.t:SetFont(STANDARD_TEXT_FONT, 12)
	bank.RBname.t:SetText'Reagent Bank'
	bank.RBname.t:SetPoint'LEFT'
	bank.RBname:SetSize(bank.RBname.t:GetStringWidth(), 12)

	bank.bd = CreateFrame('Frame', nil, bank)
	ns.BD(bank.bd)
	bank.bd:SetPoint('TOPLEFT', 8, -58)
	bank.bd:SetPoint('BOTTOMRIGHT', -10, 27)

	bank.bd.t = bank.bd:CreateTexture(nil, 'ARTWORK')
	bank.bd.t:SetAllPoints()
	bank.bd.t:SetTexture([[Interface/BankFrame/Bank-Background]], true, true)
	bank.bd.t:SetHorizTile(true)
	bank.bd.t:SetVertTile(true)
	bank.bd.t:SetVertexColor(.8, .8, .8)

	bank.space = CreateFrame('StatusBar', nil, bank.bd)
	ns.SB(bank.space)
	ns.BD(bank.space)
	bank.space:SetHeight(5)
	bank.space:SetPoint('TOPLEFT', bank, 9, -58)
	bank.space:SetPoint('TOPRIGHT', bank, -10, -58)
	bank.space:SetMinMaxValues(0, 100)
	bank.space:SetValue(100)
	bank.space:SetStatusBarColor(245/255, 172/255, 144/255)

	bank.purchase = CreateFrame('Button', 'iipBankPurchase', bank, 'SmallMoneyFrameTemplate')
	bank.purchase:SetSize(30, 20)
	bank.purchase:SetPoint('BOTTOMRIGHT', bank, -10, 10)
	bank.purchase:SetScale(.7)
	SmallMoneyFrame_OnLoad(bank.purchase)
	MoneyFrame_SetType(bank.purchase, 'STATIC')

	bank.purchase.t = bank.purchase:CreateFontString(nil, 'OVERLAY', 'NumberFontNormalRight')
	bank.purchase.t:SetPoint('RIGHT', bank.purchase, 'LEFT', -6, 0)
	bank.purchase.t:SetText'Buy New Bank Slot   +'

	local AddSparkle = function(bu)
		bu.sparkle = CreateFrame('Button', bu:GetName()..'sparkle', bu, 'SecureActionButtonTemplate, SecureHandlerStateTemplate, SecureHandlerEnterLeaveTemplate, AutoCastShineTemplate')
		bu.sparkle:RegisterForClicks'NONE'
		bu.sparkle:SetAllPoints()
		bu.sparkle:Hide()
	end

	local ToggleSparkle = function(self, isEnter)
		local id = self:GetID() + NUM_BAG_SLOTS
		for i = 1, NUM_CONTAINER_FRAMES do
			local frame = _G['ContainerFrame'..i]
			if frame:GetID() == id then
				for j = 1, GetContainerNumSlots(frame:GetID()) do
					local bu = _G['ContainerFrame'..i..'Item'..j]

					if not bu.sparkle then AddSparkle(bu) end

					if isEnter then
						bu.sparkle:SetFrameStrata'HIGH'
						bu.sparkle:Show()
						AutoCastShine_AutoCastStart(bu.sparkle, .25*i, .2/i, .2/i)
					else
						bu.sparkle:SetFrameStrata'LOW'
						bu.sparkle:Hide()
						AutoCastShine_AutoCastStop(bu.sparkle)
					end
				end
			end
		end
	end

	for i = 1, 7 do
		local slot = BankSlotsFrame['Bag'..i]
		local _, highlight = slot:GetChildren()

		ns.BD(slot)
		ns.BDStone(slot, 5)

		slot:UnregisterEvent'ITEM_PUSH'
		slot:SetNormalTexture''
		slot:SetHighlightTexture''
		slot:SetParent(bank)
		slot:SetSize(16, 12)
		slot:ClearAllPoints()
		slot:SetParent(bank)
		slot:SetFrameStrata'MEDIUM'

		slot.IconBorder:SetAlpha(0)

		slot.icon:SetTexCoord(.1, .9, .225, .775)

		if highlight then highlight:Hide() end

		if i == 1 then
			slot:SetPoint('TOPRIGHT', bank, -15, -32)
		else
			slot:SetPoint('RIGHT', BankSlotsFrame['Bag'..(i - 1)], 'LEFT', -3, 0)
		end

		slot:HookScript('OnEnter', function(self)
			ToggleSparkle(self, true)
		end)

		slot:HookScript('OnLeave', function(self)
			ToggleSparkle(self, false)
		end)
	end

	for i, v in pairs({bank.name, bank.RBname}) do
		v:SetScript('OnClick', function(self)
			BankFrame_ShowPanel(BANK_PANELS[i].name)
			bank.name.t:SetTextColor(1, self == bank.name and 1 or .7, self == bank.name and 1 or 0)
			bank.RBname.t:SetTextColor(1, self == bank.RBname and 1 or .7, self == bank.RBname and 1 or 0)
		end)
	end


	--

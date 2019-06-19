

	local _, ns = ...

	local bu = MainMenuBarBackpackButton

	_G['MicroButtonAndBagsBar']:Hide()
	_G['MicroButtonAndBagsBar']:UnregisterAllEvents()

	bu:SetParent(MainMenuBarArtFrame)
	bu:ClearAllPoints()
	bu:SetPoint('CENTER', MainMenuBarArtFrame.RightEndCap, -10, -5)
	bu:SetSize(21, 21)
	bu:GetNormalTexture():SetTexture''
	ns.BUElements(bu)

	bu.Count:ClearAllPoints()
	bu.Count:SetPoint('BOTTOM', bu, 1, 0)

	bu.space = CreateFrame('StatusBar', 'modui_bagspace', bu)
	ns.BD(bu.space, 1, -2)
	ns.SB(bu.space)
	bu.space:SetSize(22, 3)
	bu.space:SetPoint('TOP', bu, 'BOTTOM', 1, -5)
	bu.space:SetStatusBarColor(1, 1, 1)
	bu.space:SetFrameLevel(bu:GetFrameLevel())

	local mask = bu:CreateMaskTexture()
	mask:SetTexture[[Interface\Minimap\UI-Minimap-Background]]
	mask:SetPoint('TOPLEFT', -3, 3)
	mask:SetPoint('BOTTOMRIGHT', 3, -3)

	-- bu:GetCheckedTexture():SetTexture''

	MainMenuBarBackpackButtonIconTexture:AddMaskTexture(mask)

	if  not bu.bo then
		bu.bo = bu:CreateTexture(nil, 'OVERLAY')
		bu.bo:SetSize(36, 36)
		bu.bo:SetTexture[[Interface\Artifacts\Artifacts]]
		bu.bo:SetPoint'CENTER'
		bu.bo:SetTexCoord(.25, .34, .86, .9475)
		bu.bo:SetVertexColor(.7, .7, .7)
	end

	local ShowBags = function()
		for i = 0, 3 do
			local s = _G['CharacterBag'..i..'Slot']
			s:SetAlpha(1)
			s:EnableMouse(true)
		end
	end

	local HideBags = function()
		for i = 0, 3 do
			local s = _G['CharacterBag'..i..'Slot']
			s:SetAlpha(0)
			s:EnableMouse(false)
		end
	end

	local UpdateFreeSlots = function()
		local free, total = 0, 0
		for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
			local slots, type = GetContainerNumFreeSlots(i)
			if  type == 0 then
				free, total = free + slots, total + GetContainerNumSlots(i)
			end
		end
		bu.space:SetMinMaxValues(0, total)
		bu.space:SetValue(free)
		MainMenuBarBackpackButtonCount:SetText''
		ns.GRADIENT_COLOUR(bu.space, free, 0, total)
	end

	UpdateFreeSlots()
	hooksecurefunc('MainMenuBarBackpackButton_UpdateFreeSlots', UpdateFreeSlots)

	--

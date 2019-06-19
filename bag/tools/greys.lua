

	local _, ns = ...

	local bag = _G['iipbag']

	local bu = CreateFrame('Button', nil, MerchantFrame, 'ActionButtonTemplate')
	ns.BU(bu)
	ns.BUBorder(bu, 16, 16)
	bu:SetSize(17, 17)
	bu:SetPoint('TOPLEFT', MerchantFrame, 70, -34)
	bu:SetFrameStrata'MEDIUM'
	bu:Hide()

	bu.i = bu:CreateTexture(nil, 'ARTWORK')
	bu.i:SetAllPoints()
	bu.i:SetTexture[[Interface\ICONS\inv_ore_tin_01]]
	bu.i:SetTexCoord(.1, .9, .1, .9)

	bu:SetScript('OnEnter', function(self)
		GameTooltip:SetOwner(self, 'ANCHOR_CURSOR')
 		GameTooltip:SetText'Sell Poor Quality Items & Rubbish'
		GameTooltip:Show()
	end)

	bu:SetScript('OnLeave', function() GameTooltip:Hide() end)

	bu:SetScript('OnClick', function()
		for i = 0, 4 do
			for j = 1, GetContainerNumSlots(i) do
				local _, _, _, q = GetContainerItemInfo(i, j)
				if q == LE_ITEM_QUALITY_POOR then
					UseContainerItem(i, j)
				end
			end
		end
	end)

	MerchantFrame:HookScript('OnShow', function() bu:Show() end)
	MerchantFrame:HookScript('OnHide', function() bu:Hide() end)

	--



	local _, ns = ...

	local AddAutoSort = function()
		local bag  = _G['modbag']
		local bank = _G['modbank']

		local sort = CreateFrame('Frame', 'modui_AutoSort', bag)
		sort:SetSize(14, 14)
		sort:SetPoint('LEFT', bag.topstrip, 10, 4)
		ns.BDStone(sort, 5)

		sort.t = CreateFrame('Button', 'modui_AudioSortButton', sort)
		sort.t:SetAllPoints()
		ns.BD(sort.t)

		sort.t.icon = sort.t:CreateTexture(nil, 'OVERLAY')
		sort.t.icon:SetAllPoints()
		sort.t.icon:SetAtlas'bags-button-autosort-up'
		sort.t.icon:SetTexCoord(.2, .8, .2, .8)

		sort.t:SetScript('OnEnter', function(self)
			GameTooltip:SetOwner(self)
			GameTooltip:SetText(BAG_CLEANUP_BAGS)
			GameTooltip:Show()
		end)

		sort.t:SetScript('OnLeave', GameTooltip_Hide)

		sort.t:SetScript('OnClick', function()
			if  bank:IsShown() then
				SetSortBagsRightToLeft(true)
				SortBankBags()
			else
				SetSortBagsRightToLeft(false)
				SortBags()
			end
		end)

	end

	local OnEvent = function()
		if  MODUI_VAR['elements']['onebag'].enable then
			AddAutoSort()
		end
	end

	local e = CreateFrame'Frame'
	e:RegisterEvent'PLAYER_LOGIN'
	e:SetScript('OnEvent', OnEvent)

	--

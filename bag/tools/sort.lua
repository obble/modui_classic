

	local _, ns = ...

	local AddAutoSort = function()
		local bag  = _G['modbag'] or ContainerFrame1
		local bank = _G['modbank'] or BankFrame

		local sort = CreateFrame('Frame', 'modui_AutoSort', bag)
		sort:SetSize(14, 12)
		if   MODUI_VAR['elements']['onebag'].enable then
			sort:SetPoint('LEFT', bag.topstrip, 7, 4)
		else
			sort:SetPoint('TOPLEFT', ContainerFrame1, 50, -32)
		end
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

	local OnEvent = function(self, event, ...)
		AddAutoSort()
	end

	local e = CreateFrame'Frame'
	e:RegisterEvent'PLAYER_LOGIN'
	e:SetScript('OnEvent', OnEvent)

	--

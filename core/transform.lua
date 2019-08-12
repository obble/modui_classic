

	local _, ns = ...

	local events = {
		'UI_ERROR_MESSAGE',
		'GOSSIP_SHOW'
	}

	local tip = CreateFrame('GAMETOOLTIP', 'modmount', nil, 'GameTooltipTemplate')
    tip:SetOwner(UIParent, 'ANCHOR_NONE')

    local dismount = function()
        for i = -1, 16 do
            local j = GetPlayerBuff(i)
            tip:ClearLines()
            tip:SetPlayerBuff(j)
            local t = _G['modmountTextLeft2']:GetText()
            if  t then
                local _, _, speed = string.find(t, 'Increases speed by (.+)%%')
                if speed then CancelPlayerBuff(i) return end
            end
        end
    end

    local fishing = function()
        for bag = 0, NUM_BAG_SLOTS do
            for slot = 1, GetContainerNumSlots(bag) do
                local link = GetContainerItemLink(bag, slot)
                if  link then
                    local _, _, istring = string.find(link, '|H(.+)|h')
                    local n = GetItemInfo(istring)
                    if  n and (string.find(n, 'Fishing Pole') or string.find(n, 'FC-5000')) then
                        UseContainerItem(bag, slot)
                        print'|cff4c8d00Your Fishing Pole has been equipped.|r'
                        break
                    end
                end
            end
        end
    end

    local shapeshift = function()
        for i = 1, GetNumShapeshiftForms() do
            local _, name, active = GetShapeshiftFormInfo(i)
            if  active ~= nil then
                CastShapeshiftForm(i)
                break
            end
        end
    end

	local OnEvent = function(self, event, msg)
        if  event =='UI_ERROR_MESSAGE' then
            if string.find(msg, 'mounted') or string.find(msg, 'while silenced') then
                dismount()
            elseif string.find(msg, 'Fishing Pole') then
                fishing()
            elseif string.find(msg, 'shapeshift') then
                shapeshift()
            end
        else
            local _, g1 = GetGossipOptions()
            if g1 == 'taxi' then dismount() end
        end
    end

    local e = CreateFrame'Frame'
	for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnEvent', OnEvent)


	--



	local URL

	local events = {
		'CHAT_MSG_BN_CONVERSATION',
		'CHAT_MSG_BN_WHISPER',
		'CHAT_MSG_BN_WHISPER_INFORM',
		'CHAT_MSG_CHANNEL',
		'CHAT_MSG_GUILD',
		'CHAT_MSG_INSTANCE_CHAT',
		'CHAT_MSG_INSTANCE_CHAT_LEADER',
		'CHAT_MSG_OFFICER',
		'CHAT_MSG_PARTY',
		'CHAT_MSG_PARTY_LEADER',
		'CHAT_MSG_RAID',
		'CHAT_MSG_RAID_LEADER',
		'CHAT_MSG_RAID_WARNING',
		'CHAT_MSG_SAY',
		'CHAT_MSG_SYSTEM',
		'CHAT_MSG_WHISPER',
		'CHAT_MSG_WHISPER_INFORM',
		'CHAT_MSG_YELL'
	}

	local patterns = {
		'(https://%S+%.%S+)',
		'(http://%S+%.%S+)',
		'(www%.%S+%.%S+)',
		'(%S+%.%S+%.%S+)',
		'(%d+%.%d+%.%d+%.%d+:?%d*/?%S*)',
	}

	StaticPopupDialogs['URL_COPY_DIALOG'] = {
        text = 'URL',
        button2 = CLOSE,
        timeout = 0,
        hasEditBox = 1,   maxLetters = 1024,   editBoxWidth = 350,
        whileDead = true, hideOnEscape = true,
        OnShow = function(self)
            (self.icon or _G[self:GetName()..'AlertIcon']):Hide()

            local edit = self.editBox or _G[self:GetName()..'EditBox']
            edit:SetText(URL)
            edit:SetFocus()
            edit:HighlightText(0)

            local b2 = self.button2 or _G[self:GetName()..'Button2']
            b2:ClearAllPoints()
            b2:SetPoint('TOP', edit, 'BOTTOM', 0, -6)
            b2:SetWidth(150)

            URL = nil
        end,
    }

	for _, e in next, events do
		ChatFrame_AddMessageEventFilter(e, function(self, event, t, ...)
			for i = 1, #patterns do
				local text, match = string.gsub(t, patterns[i], '|cfffade94|Hurl:%1|h%1|h|r')
				if match > 0 then return false, text, ... end
			end
		end)
	end

	local hook = ItemRefTooltip.SetHyperlink
	ItemRefTooltip.SetHyperlink = function(self, link, ...)
		if  tostring(link):sub(1, 4) == 'url:' then
			URL = string.sub(link, 5)
			StaticPopup_Show'URL_COPY_DIALOG'
			return
		end
		hook(self, link, ...)
	end


	--

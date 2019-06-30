

    local tip = CreateFrame('GameTooltip', 'modquestTip', UIParent, 'GameTooltipTemplate')
    tip:EnableMouse(true)
    tip:SetMovable(true)
    tip:RegisterForDrag'LeftButton'
    tip:SetSize(128, 64)
    tip:SetPoint('CENTER', 0, 0)
    tip:SetPadding(16)
    tip:SetScript('OnLoad', GameTooltip_OnLoad)
    tip:SetScript('OnDragStart', function() tip:StartMoving() end)
    tip:SetScript('OnDragStop',  function() tip:StopMovingOrSizing() ValidateFramePosition(tip) end)

    local x = CreateFrame('Button', 'modquestTipCloseButton', tip)
    x:SetSize(32, 32)
    x:SetPoint('TOPRIGHT', -1, -1)
    x:SetNormalTexture[[Interface\Buttons\UI-Panel-MinimizeButton-Up]]
    x:SetPushedTexture[[Interface\Buttons\UI-Panel-MinimizeButton-Down]]
    x:SetHighlightTexture[[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]]
    x:SetScript('OnClick', function() HideUIPanel(tip) end)

    local OnHyperlinkShow = function(link, text, button)
       if  link:sub(1, 6) == 'quest2' then
           if  text then
               local  ds = string.find(text, 'quest2:', 1, true)
               local  ns = string.find(text, '\124h', 1, true)
               local  ne = string.find(text, '\124h\124r', 1, true)
               if not ns or not ne then return end
               local name = '\124cffffff00'..strsub(text, ns + 2, ne - 1)..'\124r'
               local desc = nil
               if ds then desc = strsub(text, ds + 7, ns - 1) end
               ShowUIPanel(QuestLinkTooltip) -- was this support for some private server thing?
               if  not tip:IsVisible() then
                   tip:SetOwner(UIParent, 'ANCHOR_PRESERVE')
               end
               tip:SetText(name)
               if  desc then
                   tip:AddLine(desc, 255, 255, 255, 255, 1)
                   tip:Show()
               end
           end
           return
       end
    end

    local OnClick = function(button)
       if  IsShiftKeyDown() then
           local i = self:GetID() + FauxScrollFrame_GetOffset(QuestLogListScrollFrame)
           -- if header then return
           if self.isHeader then return end
           -- otherwise try to track it or put it into chat
           if  ChatFrameEditBox:IsVisible() then
               local msg            = '\124cffffff00\124Hquest2'
               local name           = gsub(this:GetText(), ' *(.*)', '%1')
               local _, desc        = GetQuestLogQuestText()
               local _, lvl, tag    = GetQuestLogTitle(i))
               if  desc then
                   msg = msg .. ':'
                   if  strlen(name) + strlen(desc) > 225 then
                       msg = msg..desc:sub(1, 250)..'...'
                   else
                       msg = msg..desc
                   end
               end
               msg = msg..'\124h'..'['..lvl..(tag ~= nil and '+' or '')..'] '..name..'\124h\124r'
               ChatFrameEditBox:Insert(msg)
           end
       end
    end

    hooksecurefunc('ChatFrame_OnHyperlinkShow', OnHyperlinkShow)
    HookScript(QuestLogTitleButton, 'OnClick',  OnClick)

    --

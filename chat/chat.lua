

    local _, ns = ...

    local FONT_REGULAR = ns.FONT_REGULAR

    DEFAULT_CHATFRAME_ALPHA  = .25
    CHAT_FRAME_FADE_OUT_TIME = .1
    CHAT_FRAME_FADE_TIME     = .1
    CHAT_FONT_HEIGHTS        = {
        [1]  = 8,  [2]  = 9,  [3]  = 10,
        [4]  = 11, [5]  = 12, [6]  = 13,
        [7]  = 14, [8]  = 15, [9]  = 16,
        [10] = 17, [11] = 18, [12] = 19,
        [13] = 20, [14] = 21, [15] = 22,
    }

    local HideChatElements = function(v)
        for _, j in pairs({
            _G[v..'ButtonFrameUpButton'], _G[v..'ButtonFrameDownButton'],
            _G[v..'ConversationButton'],  _G[v..'ButtonFrameMinimizeButton'],
            _G[v..'EditBoxFocusLeft'],    _G[v..'EditBoxFocusRight'], _G[v..'EditBoxFocusMid'],
            ChatFrameMenuButton,          FriendsMicroButton,         QuickJoinToastButton
        })  do
            if  j then
                j:SetAlpha(0)
                if  not j:GetName():find'Edit' then
                    j:EnableMouse(false)
                    if  j:HasScript'OnEvent' then j:UnregisterAllEvents() end
                end
            end
        end
        for _, j in pairs({
            'ButtonFrameBackground',
            'ButtonFrameTopLeftTexture',    'ButtonFrameTopRightTexture',
            'ButtonFrameBottomLeftTexture', 'ButtonFrameBottomRightTexture',
            'ButtonFrameLeftTexture',       'ButtonFrameRightTexture',
            'ButtonFrameBottomTexture',     'ButtonFrameTopTexture',
        })  do
            _G[v..j]:SetTexture(nil)
        end
    end

    local AddChat = function()
        ChatFrameChannelButton:ClearAllPoints()
        ChatFrameChannelButton:SetPoint('BOTTOM', ChatFrame1ButtonFrame)

        ChatFrameToggleVoiceDeafenButton:ClearAllPoints()
        ChatFrameToggleVoiceDeafenButton:SetPoint('BOTTOM', ChatFrameChannelButton, 'TOP', 0, 2)

        ChatFrameToggleVoiceMuteButton:ClearAllPoints()
        ChatFrameToggleVoiceMuteButton:SetPoint('BOTTOM', ChatFrameToggleVoiceDeafenButton, 'TOP', 0, 2)

        for i, v in pairs(CHAT_FRAMES) do
            local chat = _G[v]
            local edit = _G[v..'EditBox']
            local header = _G[v..'EditBoxHeader']
            local suffix = _G[v..'EditBoxHeaderSuffix']

            SetChatWindowAlpha(i, 0)
            HideChatElements(v)

            chat:SetFrameLevel(99)
            chat:SetFrameStrata'MEDIUM'
            chat:SetShadowOffset(1, -1)
            chat:SetClampedToScreen(false)
            chat:SetClampRectInsets(0, 0, 0, 0)
            chat:SetMaxResize(UIParent:GetWidth(), UIParent:GetHeight())
            chat:SetMinResize(150, 25)

            edit:SetFrameLevel(0)
            edit:Hide()
            edit:SetSize(320, 20)
            edit:SetAltArrowKeyMode(false)
            edit:SetFont(FONT_REGULAR, 12)
            edit:SetTextInsets(11 + header:GetWidth() + (suffix:IsShown() and suffix:GetWidth() or 0), 11, 0, 0)

            if not edit.f then
                edit.f = CreateFrame('Frame', nil, edit)
                ns.BD(edit.f)
                edit.f:SetPoint('TOPLEFT', 12, -6)
                edit.f:SetPoint('BOTTOMRIGHT', -12, 6)

                edit.shadow = edit:CreateTexture(nil, 'BACKGROUND', nil, -3)
                edit.shadow:SetPoint('TOPLEFT', edit,  -9, 7)
                edit.shadow:SetPoint('BOTTOMRIGHT', edit,  9, -7)
                edit.shadow:SetTexture[[Interface\Scenarios\ScenarioParts]]
                edit.shadow:SetVertexColor(0, 0, 0, 1)
                edit.shadow:SetTexCoord(0, .641, 0, .18)
            end

            for _,  j in pairs({edit:GetRegions()}) do
                if  j:GetObjectType() == 'FontString' then
                    j:SetParent(edit.f)
                    j:SetFont(STANDARD_TEXT_FONT, 11)
                end
            end

            ChatFrameMenuButton:SetAlpha(0)
            ChatFrameMenuButton:EnableMouse(false)
        end
    end

    hooksecurefunc('FCF_OpenTemporaryWindow', AddChat)

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_ENTERING_WORLD'
    e:SetScript('OnEvent', AddChat)

    --

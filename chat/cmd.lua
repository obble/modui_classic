

    --  reload ui
    SLASH_RELOADUI1 = '/rl'
    SlashCmdList.RELOADUI = ReloadUI

    -- framestack
    SLASH_FSTACK1 = '/fs'
    SlashCmdList.FSTACK = function(msg)
        UIParentLoadAddOn'Blizzard_DebugTools'
        FrameStackTooltip_Toggle()
    end

    --  event trace
    SLASH_ETTRACE1 = '/et'
    SlashCmdList.ETTRACE = function(msg)
        UIParentLoadAddOn'Blizzard_DebugTools'
        EventTraceFrame_HandleSlashCmd(msg)
    end

    --  clear chat
    SLASH_CLEAR_CHAT1 = '/clear'
    SlashCmdList.CLEAR_CHAT = function()
        for i = 1, NUM_CHAT_WINDOWS do _G['ChatFrame'..i]:Clear() end
    end

    --  UI options list
    SLASH_UIFORM1 = '/iip'   SLASH_UIFORM2 = '/lip'
    SLASH_UIFORM3 = '/iipui' SLASH_UIFORM4 = '/lipui'
    SlashCmdList.UIFORM = function(msg)
        DEFAULT_CHAT_FRAME:AddMessage('|cff01DFD7lip ui:|r options can be found in the portrait menu at the bottom-right of your action bar', 254/255, 193/255, 192/255)
    end


    --

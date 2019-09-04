

    local _, ns = ...

    local hooks = {}

    local AddStringsAndChannelLabels = function()
        FOREIGN_SERVER_LABEL            = '—'

        CHAT_GUILD_GET                  = '|Hchannel:Guild|hG|h. %s:\32'
        CHAT_OFFICER_GET                = '|Hchannel:o|hO|h. %s:\32'
        CHAT_RAID_GET                   = '|Hchannel:raid|hR|h. %s:\32'
        CHAT_RAID_WARNING_GET           = 'RW. %s:\32'
        CHAT_RAID_LEADER_GET            = '|Hchannel:raid|hRL|h. %s:\32'
        CHAT_INSTANCE_CHAT_GET          = '|Hchannel:INSTANCE_CHAT|hIns|h. %s:\32'
        CHAT_INSTANCE_CHAT_LEADER_GET   = '|Hchannel:INSTANCE_CHAT|hIL|h. %s:\32'
        CHAT_BATTLEGROUND_GET           = '|Hchannel:Battleground|hBG|h. %s:\32'
        CHAT_BATTLEGROUND_LEADER_GET    = '|Hchannel:Battleground|hBL|h. %s:\32'
        CHAT_PARTY_GET                  = '|Hchannel:party|hP|h. %s:\32'
        CHAT_PARTY_GUIDE_GET            = '|Hchannel:party|hDG|h. %s:\32'
        CHAT_MONSTER_PARTY_GET          = '|Hchannel:raid|hR|h. %s:\32'

            -- this is a global change, affects lootframe etc. too.
        _G.GOLD_AMOUNT   = '|cffffffff%d|r|TInterface\\MONEYFRAME\\UI-GoldIcon:14:14:2:0|t'
        _G.SILVER_AMOUNT = '|cffffffff%d|r|TInterface\\MONEYFRAME\\UI-SilverIcon:14:14:2:0|t'
        _G.COPPER_AMOUNT = '|cffffffff%d|r|TInterface\\MONEYFRAME\\UI-CopperIcon:14:14:2:0|t'
    end

    local events = {
        CHAT_MSG_AFK = {
        },
        CHAT_MSG_CHANNEL_JOIN = {
            ['Joined Channel: (.+)'] = '',
        },
        CHAT_MSG_COMBAT_FACTION_CHANGE = {
            ['Reputation with (.+) increased by (.+).']                         = '+ %2 %1 rep.',
            ['You are now (.+) with (.+).']                                     = '%2 standing is now %1.',
        },
        CHAT_MSG_COMBAT_XP_GAIN = {
            ['(.+) dies, you gain (.+) experience. %(%+(.+)exp Rested bonus%)'] = '+ %2 (+%3) xp from %1.',
            ['(.+) dies, you gain (.+) experience.']                            = '+ %2 xp from %1.',
            ['You gain (.+) experience.']                                       = '+ %1 xp.',
        },
        CHAT_MSG_CURRENCY = {
            ['You receive currency: (.+)%.']                                    = '+ %1.',
            ['You\'ve lost (.+)%.']                                             = '- %1.',
        },
        CHAT_MSG_GUILD_ACHIEVEMENT = {
            ['(.+) has earned the achievement (.+)!']                           = '%1 achieved %2.',
        },
        CHAT_MSG_ACHIEVEMENT = {
            ['(.+) has earned the achievement (.+)!']                           = '%1 achieved %2.',
        },
        CHAT_MSG_LOOT = {
            ['You receive item: (.+)%.']                                        = '+ %1.',
            ['You receive loot: (.+)%.']                                        = '+ %1.',
            ['You receive bonus loot: (.+)%.']                                  = '+ bonus %1.',
            ['You create: (.+)%.']                                              = '+ %1.',
            ['You are refunded: (.+)%.']                                        = '+ %1.',
            ['You have selected (.+) for: (.+)']                                = 'Selected %1 for %2.',
            ['Received item: (.+)%.']                                           = '+ %1.',
            ['(.+) receives item: (.+)%.']                                      = '+ %2 for %1.',
            ['(.+) receives loot: (.+)%.']                                      = '+ %2 for %1.',
            ['(.+) receives bonus loot: (.+)%.']                                = '+ bonus %2 for %1.',
            ['(.+) creates: (.+)%.']                                            = '+ %2 for %1.',
            ['(.+) was disenchanted for loot by (.+).']                         = '%2 disenchanted %1.',
        },
        CHAT_MSG_SKILL = {
            ['Your skill in (.+) has increased to (.+).']                       = '%1 lvl %2.'
        },
        CHAT_MSG_SYSTEM = {
            ['Received (.+), (.+).']                                            = '+ %1, %2.',
            ['Received (.+).']                                                  = '+ %1.',
            ['Received (.+) of item: (.+).']                                    = '+ %2x%1.',
            ['(.+) is now your follower.']                                      = '+ follower %1.',
            ['(.+) completed.']                                                 = '- Quest |cfff86256%1|r.',
            ['Quest accepted: (.+)']                                            = '+ Quest |cfff86256%1|r.',
            ['Received item: (.+)%.']                                           = '+ %1.',
            ['Experience gained: (.+).']                                        = '+ %1 xp.',
            ['(.+) has come online.']                                           = '|cff40fb40%1|r logged on.',
            ['(.+) has gone offline.']                                          = '|cff40fb40%1|r logged off.',
            ['You are now Busy: in combat']                                     = '+ Combat.',
            ['You are no longer marked Busy.']                                  = '- Combat.',
            ['Discovered (.+): (.+) experience gained']                         = '+ %2 xp, found %1.',
            ['You are now (.+) with (.+).']                                     = '+ %2 faction, now %1.',
            ['Quest Accepted (.+)']                                             = '+ quest |cfff86256%1|r.',
            ['You are now Away: AFK']                                           = '+ AFK.',
            ['You are no longer Away.']                                         = '- AFK.',
            ['You are no longer rested.']                                       = '- Rested.',
            ['You don\'t meet the requirements for that quest.']                = '|cffff000!|r Quest requirements not met.',
            ['(.+) has joined the raid group.']                                 = '+ Raider |cffff7d00%1|r.',
            ['(.+) has left the raid group.']                                   = '- Raider |cffff7d00%1|r.',
            ['You have earned the title \'(.+)\'.']                             = '+ Title %1.',
        },
        CHAT_MSG_TRADESKILLS = {
            ['(.+) creates (.+).']                                              = '%1 |cffffff00->|r %2.',
        },
    }

    local AddMessage = function(self, t, ...)
        local _, size   = self:GetFont()
        local _, class  = UnitClass'player'
        local colour    = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class].colorStr
        local var       = GetCVar'timeMgrUseMilitaryTime'
        local d = var == '1' and date'%H.%M' or date'%I.%M'..string.lower(date'%p')

        if  string.find(t, 'Left Channel:') then                        --   global channels being left should be indentifiable
            t = gsub(t, '%[(%d0?)%. (.-)%]', '|cffffffff%1|r %2   ')    --   [2. trade] > 2: Trade
        else                                                            --   otherwise:
            t = gsub(t, '%[(%d0?)%. (.-)%]', '|cffffffff%1|r   ')       --   globals channels: [2. trade] > 2
        end
                                                                --  'square'-off string icons
        t = gsub(t, '|TInterface\\Icons\\(.+):(.+)|t', '|TInterface\\Icons\\%1:'..size..':'..size..':0:0:64:64:8:56:8:56|t')
        t = gsub(t, '(|HBNplayer.-|h)%[(.-)%]|h', '%1%2|h')     --   battlenet player name
        t = gsub(t, '(|Hplayer.-|h)%[(.-)%]|h', '%1%2|h')       --   player name
        t = gsub(t, 'Guild Message of the Day:', 'GMOTD   ')    --   message of the day
        t = gsub(t, 'To (|HBNplayer.+|h):', '%1 >   ')          --   whisper to bnet
        t = gsub(t, 'To (|Hplayer.+|h):', '%1 >   ')            --   whisper to
        t = gsub(t, ' whispers:', ' <   ')                      --   whisper from
        t = gsub(t, 'Joined Channel:', '>')                     --   channel join
        t = gsub(t, 'Left Channel:', 'Left ')                   --   channel left
        t = gsub(t, '|H(.-)|h%[(.-)%]|h', '|H%1|h%2|h')         --   strip brackets off've items iilinks style

        d = gsub(d, '0*(%d+)', '%1', 1)
        t = string.format('|cffffc800%s|r    %s', d, t)

        if string.find(t, 'Changed Channel') then return end

        return hooks[self](self, t, ...)
    end

    local AddEventFilters = function()
        for event, filters in pairs(events) do
            ChatFrame_AddMessageEventFilter(event, function(f, event, t, ...)
                for k, v in pairs(filters) do
                    if  t:match(k) then
                        t = t:gsub(k, v)
                        return nil, t, ...
                    end
                end
            end)
        end
    end

    local AddNewMessage = function(chat)
        hooks[chat] = chat.AddMessage
        chat.AddMessage = AddMessage
    end

    local AddMessageHooks = function()
        for i, v in pairs(CHAT_FRAMES) do
            if  not v:find'2' then
                local chat = _G[v]
                AddNewMessage(chat)
            end
        end
        hooksecurefunc('FCF_SetTemporaryWindowType', AddNewMessage)
    end

    local OnEvent = function()
        if  MODUI_VAR['elements']['chat'].enable then
            if  MODUI_VAR['elements']['chat'].events then
                AddEventFilters()
                AddMessageHooks()
                AddStringsAndChannelLabels()
            end
        end
    end

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', OnEvent)


    --

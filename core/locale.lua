

	local _, ns = ...

	local L = {}

	-- AURA
	L['h'] = '' -- "h" hours on aura timers
	L['m'] = '' -- "m" minutes on aura timers
	L['s'] = '' -- "s" seconds on aura timers

	-- BAG
	L['Bag'] = ''
	L['Bank'] = ''
	L['Sell Poor Quality Items & Rubbish'] = ''

	-- MAP
	L['Mouse'] = ''

	-- MENU
	L['Your new settings require a UI reload to take effect.'] = ''
	L['Toggle All modui Elements.    |cffff0000Note: Overrides Selections.|r'] = ''
	L['Actionbar'] = ''
	L['Aura'] = ''
	L['Statusbars on Auras'] = ''
	L['Custom Value Formatting on Auras'] ''
	L['Chat'] = ''
	L['Events & Custom Chat Text'] = ''
	L['Chat Style'] = ''
	L['URLs'] = ''
	L['Inventory'] = ''
	L['Button For Selling Grey Items at Vendor'] = ''
	L['Enemy Castbars'] = ''
	L['Nameplates'] = ''
	L['Show Auras on Nameplates'] = ''
	L['Show Combo Points on Nameplate'] = ''
	L['Class Colours on Friendly Nameplates'] = ''
	L['Icon-based Nameplates for Totems'] = ''
	L['Quest Tracker (Click-through to Quest Log)'] = ''
	L['Tooltip'] = ''
	L['Unitframes'] = ''
	L['Player'] = ''
	L['Target'] = ''
	L['Party'] = ''
	L['Target of Target'] = ''
	L['Pet'] = ''
	L['Value Colours on Text'] = ''
	L['Elite/Rare Dragons in Colour (for dark theme UIs)'] = ''

	-- TOOLTIP
	L[' Boss'] = ''
	L[' Rare Elite'] = ''
	L[' Rare'] = ''
	L[' Elite' = ''

	-- TRANSFORM
	L['Increases speed by (.+)%%'] = '' -- tooltip string on mount items
	L['Fishing Pole'] = ''
	L['Your Fishing Pole has been equipped'] = ''
	L['while silenced'] = '' -- UI_ERROR_MESSAGE return, used to check if we're in combat (and dismount)
	L['shapeshift'] = '' -- UI_ERROR_MESSAGE return, used to check if we're shapeshifted (and shift out)

	-- CHAT CHANNELS
	L['|Hchannel:Guild|hG|h. %s:\32'] = ''            -- "G. Obble:" guild chat
	L['|Hchannel:o|hO|h. %s:\32'] = ''                -- "O. Obble:" officer chat
	L['|Hchannel:raid|hR|h. %s:\32'] = ''             -- "R. Obble:" raid chat
	L['RW. %s:\32'] = ''                              -- "RW. Obble:" raid warning
	L['|Hchannel:raid|hRL|h. %s:\32'] = ''            -- "RL. Obble:" raid leader
	L['|Hchannel:INSTANCE_CHAT|hIns|h. %s:\32'] - ''  -- "Ins. Obble:" instance chat
	L['|Hchannel:INSTANCE_CHAT|hIL|h. %s:\32'] = ''   -- "IL. Obble:" instance leader
	L['|Hchannel:Battleground|hBG|h. %s:\32'] = ''    -- "BG. Obble:" battleground chat
	L['|Hchannel:Battleground|hBL|h. %s:\32'] = ''     -- "BL. Obble:" battleground leader
	L['|Hchannel:party|hP|h. %s:\32'] = ''              -- "P. Obble:" party chat
	L['|Hchannel:party|hDG|h. %s:\32'] = ''             -- "DG. Obble:" party guide
	L['|Hchannel:raid|hR|h. %s:\32'] == ''              -- "R. Obble:" CHAT_MONSTER_PARTY_GET

	-- CHAT EVENTS
	L['Joined Channel: (.+)'] = ''
	L['Reputation with (.+) increased by (.+).'] = ''
	L['You are now (.+) with (.+).'] = ''
	L['(.+) dies, you gain (.+) experience. %(%+(.+)exp Rested bonus%)'] = ''
	L['(.+) dies, you gain (.+) experience.'] = ''
	L['You gain (.+) experience.'] = ''
	L['You receive currency: (.+)%.'] = ''
	L['You\'ve lost (.+)%.'] = ''
	L['(.+) has earned the achievement (.+)!'] = ''
	L['(.+) has earned the achievement (.+)!'] = ''
	L['You receive item: (.+)%.'] = ''
	L['You receive loot: (.+)%.'] = ''
	L['You receive bonus loot: (.+)%.'] = ''
	L['You create: (.+)%.'] = ''
	L['You are refunded: (.+)%.'] = ''
	L['You have selected (.+) for: (.+)'] = ''
	L['Received item: (.+)%.'] = ''
	L['(.+) receives item: (.+)%.'] = ''
	L['(.+) receives loot: (.+)%.'] = ''
	L['(.+) receives bonus loot: (.+)%.'] = ''
	L['(.+) creates: (.+)%.'] = ''
	L['(.+) was disenchanted for loot by (.+).'] = ''
	L['Your skill in (.+) has increased to (.+).'] = ''
	L['Received (.+), (.+).'] = ''
	L['Received (.+).'] = ''
	L['Received (.+) of item: (.+).'] = ''
	L['(.+) is now your follower.'] = ''
	L['(.+) completed.'] = ''
	L['Quest accepted: (.+)'] = ''
	L['Received item: (.+)%.'] = ''
	L['Experience gained: (.+).'] = ''
	L['(.+) has come online.'] = ''
	L['(.+) has gone offline.'] = ''
	L['You are now Busy: in combat'] =  ''
	L['You are no longer marked Busy.'] = ''
	L['Discovered (.+): (.+) experience gained']  = ''
	L['You are now (.+) with (.+).'] = ''
	L['Quest Accepted (.+)'] = ''
	L['You are now Away: AFK'] = ''
	L['You are no longer Away.'] = ''
	L['You are no longer rested.'] = ''
	L['You don\'t meet the requirements for that quest.']  = ''
	L['(.+) has joined the raid group.'] = ''
	L['(.+) has left the raid group.'] = ''
	L['You have earned the title \'(.+)\'.'] = ''
	L['(.+) creates (.+).'] = ''

	L['Guild Message of the Day:'] = ''     --   guild message of the day
	L['To (|HBNplayer.+|h):'] = ''          --   whisper to bnet
	L['To (|Hplayer.+|h):'] = ''            --   whisper to
	L[' whispers:'] = ''                    --   whisper from
	L['Joined Channel:' = ''                --   channel join
	L['Left Channel:'] = 'Left '            --   channel left


	--

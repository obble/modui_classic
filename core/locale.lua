

	local _, ns = ...

	local L = {}
	local locale = GetLocale()
	
	-- MENU
	L['UI Colour'] = ''
	L['Toggle Elements'] = ''

	-- AURA
	L['h'] = 'h' -- "h" hours on aura timers
	L['m'] = 'm' -- "m" minutes on aura timers
	L['s'] = 's' -- "s" seconds on aura timers

	-- BAG
	L['Bag'] = ''
	L['Bank'] = ''
	L['Sell Poor Quality Items & Rubbish'] = ''

	-- MAP
	L['Mouse'] = ''

	-- MENU
	L['Your new settings require a UI reload to take effect.'] = 'Your new settings require a UI reload to take effect.'
	L['Toggle All modui Elements.    |cffff0000Note: Overrides Selections.|r'] = 'Toggle All modui Elements.    |cffff0000Note: Overrides Selections.|r'
	L['Actionbar'] = ''
	L['Exp & Reputation Bar'] = ''
	L['Horizontal Third Row (Classic Layout only)'] = ''
	L['Aura'] = ''
	L['Statusbars on Auras'] = ''
	L['Custom Value Formatting on Auras'] = ''
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
	L['Mouse Anchor'] = ''
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
	L[' Elite'] = ''

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
	L['|Hchannel:INSTANCE_CHAT|hIns|h. %s:\32'] = ''  -- "Ins. Obble:" instance chat
	L['|Hchannel:INSTANCE_CHAT|hIL|h. %s:\32'] = ''   -- "IL. Obble:" instance leader
	L['|Hchannel:Battleground|hBG|h. %s:\32'] = ''    -- "BG. Obble:" battleground chat
	L['|Hchannel:Battleground|hBL|h. %s:\32'] = ''     -- "BL. Obble:" battleground leader
	L['|Hchannel:party|hP|h. %s:\32'] = ''              -- "P. Obble:" party chat
	L['|Hchannel:party|hDG|h. %s:\32'] = ''             -- "DG. Obble:" party guide
	L['|Hchannel:raid|hR|h. %s:\32'] = ''              -- "R. Obble:" CHAT_MONSTER_PARTY_GET

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
	L['Joined Channel:'] = ''                --   channel join
	L['Left Channel:'] = 'Left '            --   channel left
	
	if locale == "zhTW" then

		-- MENU
		L['UI Colour'] = '介面顏色'
		L['Toggle Elements'] = '切換選項'
		
		-- BAG
		L['Bag'] = '背包' -- or use BAGSLOT
		L['Bank'] = '銀行' -- or use BANK
		L['Sell Poor Quality Items & Rubbish'] = '賣垃圾'

		-- MAP
		L['Mouse'] = '滑鼠'

		-- MENU
		L['Your new settings require a UI reload to take effect.'] = '你的新設定需要重載介面才會生效。'
		L['Toggle All modui Elements.    |cffff0000Note: Overrides Selections.|r'] = '全局切換開關。|cffff0000注意：會覆蓋掉你現有的設定。|r'
		L['Actionbar'] = '快捷列'
		L['Exp & Reputation Bar'] = '經驗聲望條'
		L['Horizontal Third Row (Classic Layout only)'] = '橫式的第三排快捷列，僅在經典布局生效'
		L['Cast Spells on Button Down'] = '按下按鍵時施法'
		L['Aura'] = '光環'
		L['Statusbars on Auras'] = '在光環上顯示計時條'
		L['Custom Value Formatting on Auras'] = '修改光環計時文本格式'
		L['Chat'] = '聊天'
		L['Events & Custom Chat Text'] = '修改聊天文本格式'
		L['Chat Style'] = '修改聊天框架外觀'
		L['URLs'] = '網址'
		L['Inventory'] = '行囊'
		L['Button For Selling Grey Items at Vendor'] = '在商人介面顯示賣垃圾的按鈕'
		L['Enemy Castbars'] = '敵方施法條'
		L['Nameplates'] = '名條'
		L['Show Auras on Nameplates'] = '在名條上顯示光環'
		L['Show Combo Points on Nameplate'] = '在名條上顯示連擊點'
		L['Class Colours on Friendly Nameplates'] = '替友方名條職業著色'
		L['Icon-based Nameplates for Totems'] = '圖騰圖示'
		L['Quest Tracker (Click-through to Quest Log)'] = '點擊任務追蹤開啟任務日誌'
		L['Tooltip'] = '滑鼠提示'
		L['Mouse Anchor'] = '錨點於滑鼠位置'
		L['Unitframes'] = '單位框架'
		L['Player'] = '玩家'
		L['Target'] = '目標'
		L['Party'] = '隊伍'
		L['Target of Target'] = '目標的目標'
		L['Pet'] = '寵物'
		L['Value Colours on Text'] = '數值著色'
		L['Elite/Rare Dragons in Colour (for dark theme UIs)'] = '使用黑色主題時著色稀有和精英的金銀龍'

		-- TOOLTIP
		L[' Boss'] = ' 首領' -- or use BOSS
		L[' Rare Elite'] = ' 稀有精英'
		L[' Rare'] = ' 稀有' -- or use ELITE
		L[' Elite'] = ' 精英'
	
	elseif locale == "zhCN" then
		-- MENU
		L['UI Colour'] = '界面颜色'
		L['Toggle Elements'] = '配置选项'
		
		-- BAG
		L['Bag'] = '背包' -- or use BAGSLOT
		L['Bank'] = '银行' -- or use BANK
		L['Sell Poor Quality Items & Rubbish'] = '卖垃圾'

		-- MAP
		L['Mouse'] = '鼠标'

		-- MENU
		L['Your new settings require a UI reload to take effect.'] = '你的新设置需要重载界面才会生效。'
		L['Toggle All modui Elements.    |cffff0000Note: Overrides Selections.|r'] = '全局切换开关。|cffff0000注意：会复盖掉你现有的设置。|r'
		L['Actionbar'] = '动作条'
		L['Exp & Reputation Bar'] = '经验声望条'
		L['Horizontal Third Row (Classic Layout only)'] = '横式的第三排动作条，仅在经典布局生效'
		L['Cast Spells on Button Down'] = '按下按键时施法'
		L['Aura'] = '光环'
		L['Statusbars on Auras'] = '在光环上显示计时条'
		L['Custom Value Formatting on Auras'] = '修改光环计时文本格式'
		L['Chat'] = '聊天'
		L['Events & Custom Chat Text'] = '修改聊天文本格式'
		L['Chat Style'] = '修改聊天框架外观'
		L['URLs'] = '网址'
		L['Inventory'] = '行囊'
		L['Button For Selling Grey Items at Vendor'] = '在商人接口显示卖垃圾的按钮'
		L['Enemy Castbars'] = '敌对施法条'
		L['Nameplates'] = '姓名板'
		L['Show Auras on Nameplates'] = '在姓名板上显示光环'
		L['Show Combo Points on Nameplate'] = '在姓名板上显示连击点'
		L['Class Colours on Friendly Nameplates'] = '友方姓名板职业染色'
		L['Icon-based Nameplates for Totems'] = '图腾图示'
		L['Quest Tracker (Click-through to Quest Log)'] = '点击任务追踪开启任务日志'
		L['Tooltip'] = '鼠标提示'
		L['Mouse Anchor'] = '锚点于鼠标'
		L['Unitframes'] = '单位框体'
		L['Player'] = '玩家'
		L['Target'] = '目标'
		L['Party'] = '队伍'
		L['Target of Target'] = '目标的目标'
		L['Pet'] = '宠物'
		L['Value Colours on Text'] = '数值染色'
		L['Elite/Rare Dragons in Colour (for dark theme UIs)'] = '使用黑色主题时着色稀有和精英的金银龙'

		-- TOOLTIP
		L[' Boss'] = ' 首领' -- or use BOSS
		L[' Rare Elite'] = ' 稀有精英'
		L[' Rare'] = ' 稀有' -- or use ELITE
		L[' Elite'] = ' 精英'
		
	else
		return
	end

	-- German Translation
	if locale == "deDE" then
		-- MENU
		L['UI Colour'] = 'UI Farbe'
		L['Toggle Elements'] = 'Elemente umschalten'

		-- AURA
		L['h'] = 'h' -- "h" hours on aura timers
		L['m'] = 'm' -- "m" minutes on aura timers
		L['s'] = 's' -- "s" seconds on aura timers

		-- BAG
		L['Bag'] = 'Beutel'
		L['Bank'] = ''
		L['Sell Poor Quality Items & Rubbish'] = 'Verkaufe Gegenstände von schelchter Qualität & Gerümpel'

		-- MAP
		L['Mouse'] = 'Maus'

		-- MENU
		L['Your new settings require a UI reload to take effect.'] = 'Deine neuen Einstellungen sind erst nach einem Reload aktiv.'
		L['Toggle All modui Elements.    |cffff0000Note: Overrides Selections.|r'] = 'Schalte alle modui Elemente um.    |cffff0000Hinweis: Überschreibt einzelne Auswahlen.|r'
		L['Actionbar'] = 'Aktionsleiste'
		L['Exp & Reputation Bar'] = 'Erfahrungs- & Ruf-Leiste'
		L['Horizontal Third Row (Classic Layout only)'] = 'Horizontale dritte Leiste (nur im classischen Layout)'
		L['Aura'] = 'Auren'
		L['Statusbars on Auras'] = 'Statusleisten auf Auren'
		L['Custom Value Formatting on Auras'] = 'Individuelle Werte Formatierung für Auren'
		L['Chat'] = 'Chat'
		L['Events & Custom Chat Text'] = 'Ereignisse & angepasster Chat Text'
		L['Chat Style'] = 'Chat Darstellung'
		L['URLs'] = 'Links'
		L['Inventory'] = 'Inventar'
		L['Button For Selling Grey Items at Vendor'] = 'Knopf zum Verkaufen von grauen Gegenständen beim Händler'
		L['Enemy Castbars'] = 'Gegnerische Zauberleisten'
		L['Nameplates'] = 'Namensbalken'
		L['Show Auras on Nameplates'] = 'Zeige Auren auf den Namensbalken'
		L['Show Combo Points on Nameplate'] = 'Zeiuge Kombo-Punkte auf den Namensbalken'
		L['Class Colours on Friendly Nameplates'] = 'Freundliche Namensbalken in Klassenfarbe'
		L['Icon-based Nameplates for Totems'] = 'Symbol basierte Namenbalken für Totems'
		L['Quest Tracker (Click-through to Quest Log)'] = ''
		L['Tooltip'] = ''
		L['Mouse Anchor'] = 'An der Maus fixiert'
		L['Unitframes'] = ''
		L['Player'] = 'Spieler'
		L['Target'] = 'Ziel'
		L['Party'] = 'Gruppe'
		L['Target of Target'] = 'Ziel des Ziels'
		L['Pet'] = 'Haustier'
		L['Value Colours on Text'] = ''
		L['Elite/Rare Dragons in Colour (for dark theme UIs)'] = ''

		-- TOOLTIP
		L[' Boss'] = 'Boss'
		L[' Rare Elite'] = 'Seltener Elite'
		L[' Rare'] = 'Selten'
		L[' Elite'] = 'Elite'

		-- TRANSFORM
		L['Increases speed by (.+)%%'] = 'erhöht die Geschwindigkeit um (.+)%%' -- tooltip string on mount items
		L['Fishing Pole'] = 'Angelrute'
		L['Your Fishing Pole has been equipped'] = 'Deine Angelrute wurde angelegt'
		L['while silenced'] = '' -- UI_ERROR_MESSAGE return, used to check if we're in combat (and dismount)
		L['shapeshift'] = '' -- UI_ERROR_MESSAGE return, used to check if we're shapeshifted (and shift out)

		-- CHAT CHANNELS
		L['|Hchannel:Guild|hG|h. %s:\32'] = ''            -- "G. Obble:" guild chat
		L['|Hchannel:o|hO|h. %s:\32'] = ''                -- "O. Obble:" officer chat
		L['|Hchannel:raid|hR|h. %s:\32'] = ''             -- "R. Obble:" raid chat
		L['RW. %s:\32'] = ''                              -- "RW. Obble:" raid warning
		L['|Hchannel:raid|hRL|h. %s:\32'] = ''            -- "RL. Obble:" raid leader
		L['|Hchannel:INSTANCE_CHAT|hIns|h. %s:\32'] = ''  -- "Ins. Obble:" instance chat
		L['|Hchannel:INSTANCE_CHAT|hIL|h. %s:\32'] = ''   -- "IL. Obble:" instance leader
		L['|Hchannel:Battleground|hBG|h. %s:\32'] = ''    -- "BG. Obble:" battleground chat
		L['|Hchannel:Battleground|hBL|h. %s:\32'] = ''     -- "BL. Obble:" battleground leader
		L['|Hchannel:party|hP|h. %s:\32'] = ''              -- "P. Obble:" party chat
		L['|Hchannel:party|hDG|h. %s:\32'] = ''             -- "DG. Obble:" party guide
		L['|Hchannel:raid|hR|h. %s:\32'] = ''              -- "R. Obble:" CHAT_MONSTER_PARTY_GET

		-- CHAT EVENTS
		L['Joined Channel: (.+)'] = 'Kanal betreten: (.+)'
		L['Reputation with (.+) increased by (.+).'] = 'Ruf mit (.+) um (.+) erhöht.'
		L['You are now (.+) with (.+).'] = 'Du bist jetzt (.+) mit (.+).'
		L['(.+) dies, you gain (.+) experience. %(%+(.+)exp Rested bonus%)'] = '(.+) stirbt, Du erhälst (.+) Erfahrung. %(%+(.+)Exp erholt-Bonus%)'
		L['(.+) dies, you gain (.+) experience.'] = '(.+) stirbt, Du erhälst (.+) Erfahrung.'
		L['You gain (.+) experience.'] = 'Du erhälst (.+) Erfahrung.'
		L['You receive currency: (.+)%.'] = 'Du erhälst: (.+)%.'
		L['You\'ve lost (.+)%.'] = 'Du verlierst (.+)%.'
		L['(.+) has earned the achievement (.+)!'] = '(.+) hat den Erfolg (.+) errungen!'
		L['You receive item: (.+)%.'] = 'Du hast folgenden Gegenstand erhalten: (.+)%.'
		L['You receive loot: (.+)%.'] = 'Du hast folgenden Beute erhalten: (.+)%.'
		L['You receive bonus loot: (.+)%.'] = 'Du hast folgende zusätzliche Beute erhalten: (.+)%.'
		L['You create: (.+)%.'] = 'Du erstellst: (.+)%.'
		L['You are refunded: (.+)%.'] = 'Du bekommst erstattet: (.+)%.'
		L['You have selected (.+) for: (.+)'] = 'Du hast (.+) gewählt für: (.+)'
		L['Received item: (.+)%.'] = 'Gegenstand erhalten: (.+)%.'
		L['(.+) receives item: (.+)%.'] = '(.+) erhält Gegenstand: (.+)%.'
		L['(.+) receives loot: (.+)%.'] = '(.+) erhält Beute: (.+)%.'
		L['(.+) receives bonus loot: (.+)%.'] = '(.+) erhält zusätzliche Beute: (.+)%.'
		L['(.+) creates: (.+)%.'] = '(.+) erstellt: (.+)%.'
		L['(.+) was disenchanted for loot by (.+).'] = '(.+) wurde durch (.+) für Beute entzaubert.'
		L['Your skill in (.+) has increased to (.+).'] = 'Deine Fähigkeit in (.+) hat sich auf (.+) erhöht.'
		L['Received (.+), (.+).'] = 'Du erhälst (.+), (.+).'
		L['Received (.+).'] = 'Du erhälst (.+).'
		L['Received (.+) of item: (.+).'] = 'Du erhälst (.+) von: (.+).'
		L['(.+) is now your follower.'] = '(.+) ist jetzt dein Gefolge.'
		L['(.+) completed.'] = '(.+) abgeschlossen.'
		L['Quest accepted: (.+)'] = 'Aufgabe angenommen: (.+)'
		L['Received item: (.+)%.'] = 'Gegenstand erhalten: (.+)%.'
		L['Experience gained: (.+).'] = 'Erfahrung erhalten: (.+).'
		L['(.+) has come online.'] = '(.+) ist jetzt online.'
		L['(.+) has gone offline.'] = '(.+) ist jetzt offline.'
		L['You are now Busy: in combat'] =  'Du bist jetzt als Beschäftigt markiert: Im Kampf'
		L['You are no longer marked Busy.'] = 'Du bist nicht länger als Beschäftigt markiert'
		L['Discovered (.+): (.+) experience gained']  = '(.+) entdeckt: (.+) Erfahrung erhalten'
		L['You are now (.+) with (.+).'] = 'Du bist jetzt (.+) mit (.+).'
		L['Quest Accepted (.+)'] = 'Aufgabe angenommen (.+)'
		L['You are now Away: AFK'] = 'Du bist jetzt abwesend: AFK'
		L['You are no longer Away.'] = 'Du bist nicht länger abwesend'
		L['You are no longer rested.'] = 'Du bist nicht länger ausgeruht.'
		L['You don\'t meet the requirements for that quest.']  = 'Du erfüllst nicht die Voraussetzungen für diese Aufgabe.'
		L['(.+) has joined the raid group.'] = '(.+) ist dem Schlachtzug beigetreten.'
		L['(.+) has left the raid group.'] = '(.+) hat den Schlachtzug verlassen.'
		L['You have earned the title \'(.+)\'.'] = 'Du hast den Titel \'(.+)\' erlangt.'
		L['(.+) creates (.+).'] = '(.+) erstellt (.+).'

		L['Guild Message of the Day:'] = 'Gildennachricht des Tages'     --   guild message of the day
		L['To (|HBNplayer.+|h):'] = 'An (|HBNplayer.+|h):'          --   whisper to bnet
		L['To (|Hplayer.+|h):'] = 'An (|Hplayer.+|h):'            --   whisper to
		L[' whispers:'] = ' flüstert:'                    --   whisper from
		L['Joined Channel:'] = 'Kanal betreten:'                --   channel join
		L['Left Channel:'] = 'Kanal verlassen:'            --   channel left
	end

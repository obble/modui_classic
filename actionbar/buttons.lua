

    local _, ns = ...

    local bars = {
		['bar1'] = {
			buttons				= 'Action',
			flyout				= 'UP',
			grid				= true,
			name				= 'iipActionBar1',
			num 				= 12,
			padding 			= 9,
			positions			= {'BOTTOM', UIParent, 'BOTTOM', 0, 	80},
			wrappositions		= {'BOTTOM', UIParent, 'BOTTOM', -120, 	80},
			row					= 12,
			size 				= x,
			type				= 'ACTIONBUTTON',
			visibility 			= '[vehicleui][petbattle][possessbar] hide; show',
			textureL			= {.02, .5, 0, 1},
			textureR			= {.5, .98, 0, 1},
			textureLpositionsT	= {'TOPLEFT', nil, 'TOPLEFT', -11, 14},	-- parent (textureLpositions[2]) is defined in function
			textureLpositionsB	= {'BOTTOMRIGHT', nil, 'BOTTOM', 0, -16},
			textureRpositionsT	= {'TOPRIGHT', nil, 'TOPRIGHT', 11, 14},
			textureRpositionsB	= {'BOTTOMLEFT', nil, 'BOTTOM', 0, -16},
			textureShadowT		= {'TOPLEFT', nil, 'TOPLEFT', -32, 14},
			textureShadowB		= {'BOTTOMRIGHT', nil, 'BOTTOMRIGHT', 6, -14},
		},
		['bar2'] = {
			buttons				= 'MultiBarBottomLeft',
			flyout				= 'UP',
			grid				= true,
			name				= 'iipActionBar2',
			num 				= 12,
			padding 			= 9,
			page				= 6,
			positions			= {'BOTTOM', UIParent, 'BOTTOM', 0, 119},
			wrappositions		= {'BOTTOM', UIParent, 'BOTTOM', -120, 	119},
			row					= 12,
			size 				= x,
			type				= 'MULTIACTIONBAR1BUTTON',
			visibility 			= '[vehicleui][petbattle][overridebar][possessbar] hide; show',
			textureL			= {.018, .5, 0, .8},
			textureR			= {.5, .982, 0, .8},
			textureLpositionsT	= {'TOPLEFT', nil, 'TOPLEFT', -12, 14},
			textureLpositionsB	= {'BOTTOMRIGHT', nil, 'BOTTOM', 0, -2},
			textureRpositionsT	= {'TOPRIGHT', nil, 'TOPRIGHT', 12, 14},
			textureRpositionsB	= {'BOTTOMLEFT', nil, 'BOTTOM', 0, -2},
			textureShadowT		= {'TOPLEFT', nil, 'TOPLEFT', -28, 14},
			textureShadowB		= {'BOTTOMRIGHT', nil, 'BOTTOMRIGHT', 6, -14},
		},
		['bar3'] = {
			buttons				= 'MultiBarBottomRight',
			flyout				= 'UP',
			grid				= true,
			name				= 'iipActionBar3',
			num 				= 12,
			padding 			= 9,
			page				= 5,
			positions			= {'BOTTOM', UIParent, 'BOTTOM', 231, 80},
			row					= 6,
			size 				= x,
			type				= 'MULTIACTIONBAR2BUTTON',
			visibility 			= '[vehicleui][petbattle][overridebar][possessbar] hide; show',
			textureL			= {.2, 1, 0, 1},
			textureR			= {.2, 1, 0, 1},
			textureLpositionsT	= {'TOPLEFT', nil, 'TOPLEFT', -2, 14},
			textureLpositionsB	= {'BOTTOMRIGHT', nil, 'RIGHT', 15, -10},
			textureRpositionsT	= {'TOPRIGHT', nil, 'LEFT', -2, 12},
			textureRpositionsB	= {'BOTTOMLEFT', nil, 'BOTTOMRIGHT', 15, -15},
			textureShadowT		= {'TOPLEFT', nil, 'TOPLEFT', -28, 14},
			textureShadowB		= {'BOTTOMRIGHT', nil, 'BOTTOMRIGHT', 20, -14},
		},
		['bar4'] = {
			buttons				= 'MultiBarLeft',
			flyout				= 'RIGHT',
			grid				= true,
			name				= 'iipActionBar4',
			num 				= 12,
			padding 			= 9,
			page				= 4,
			positions			= {'BOTTOMLEFT', UIParent, 'BOTTOMRIGHT', -130, 232},
			row					= 1,
			size 				= x,
			type				= 'MULTIACTIONBAR4BUTTON',
			visibility 			= '[vehicleui][petbattle][overridebar][possessbar] hide; show',
		},
		['bar5'] = {
			buttons				= 'MultiBarRight',
			flyout				= 'RIGHT',
			grid				= true,
			name				= 'iipActionBar5',
			num 				= 12,
			padding 			= 9,
			page				= 3,
			positions			= {'BOTTOMLEFT', UIParent, 'BOTTOMRIGHT', -91, 232},
			row					= 1,
			size 				= x,
			type				= 'MULTIACTIONBAR3BUTTON',
			visibility 			= '[vehicleui][petbattle][overridebar][possessbar] hide; show',
		},
	}

    local PAGES = {
		['DEFAULT'] = '[vehicleui][possessbar] 12; [shapeshift] 13; [overridebar] 14; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;',
		['DRUID'] 	= '[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:3] 9; [bonusbar:4] 10;',
		['ROGUE'] 	= '[bonusbar:1] 7;',
	}

    local rebindable = {
		bar1 = true,
		bar2 = true,
		bar3 = true,
		bar4 = true,
		bar5 = true,
	}

    local keys = {
        KEY_NUMPADDECIMAL     = 'Nu.',
        KEY_NUMPADDIVIDE      = 'Nu/',
        KEY_NUMPADMINUS       = 'Nu-',
        KEY_NUMPADMULTIPLY    = 'Nu*',
		KEY_NUMPADPLUS        = 'Nu+',
		KEY_MOUSEWHEELUP      = '^U',
		KEY_MOUSEWHEELDOWN    = '⌄D',
		KEY_NUMLOCK           = 'NuLk',
		KEY_PAGEUP            = 'PU',
		KEY_PAGEDOWN          = 'PD',
		KEY_SPACE             = 'Space',
		KEY_INSERT            = 'Ins',
		KEY_HOME              = 'Hm',
		KEY_DELETE            = 'Del',
	}

    local add = function(bu)
		if not ns.bar_elements[bu] then
			tinsert(ns.bar_elements, bu)
		end
	end

	local remove = function(bu)
		for i, v in pairs(ns.bar_elements) do
			if  bu:GetName() == v:GetName() then
				tremove(ns.bar_elements, i)
			end
		end
	end

    local AddBarPage = function()
        local _, class 	= UnitClass'player'
        local condition = PAGES['DEFAULT']
        local page 		= PAGES[class]
        if  page then
            condition = condition..' '..page
        end
        return condition..' [form] 1; 1'
    end

    local AddConfig = function(self)
		if  not self.buttonConfig then
			self.buttonConfig = {
				tooltip = 'enabled',
				colors = {},
				desaturation = {},
				hideElements = {
					equipped = false,
				},
			}
		end

		self.buttonConfig.clickOnDown = false
		self.buttonConfig.desaturateOnCooldown 	= true
		self.buttonConfig.drawBling = true
		self.buttonConfig.flyout = bars[self._id].flyout
		self.buttonConfig.desaturation = {
			cooldown = false,
			mana = false,
			range = false,
			unusable = false,
		}
		self.buttonConfig.outOfManaColoring = 'button'
		self.buttonConfig.outOfRangeColoring = 'button'
		self.buttonConfig.showGrid = tonumber(GetCVar'alwaysShowActionBars')

		self.buttonConfig.desaturation = {
			cooldown = true,
			mana = true,
			range = false,
			unusable = true,
		}

		self.buttonConfig.colors.range = { 141/255, 28/255, 22/255 }
		self.buttonConfig.colors.mana = { .8, .8, .8 }
		self.buttonConfig.colors.unusable = { .4, .4, .4 }


		self.buttonConfig.hideElements.hotkey = false
		self.buttonConfig.hideElements.macro = false

		for i, bu in pairs(self._buttons) do
			self.buttonConfig.keyBoundTarget = bu._command
			bu.keyBoundTarget = self.buttonConfig.keyBoundTarget
			bu:UpdateConfig(self.buttonConfig)
			bu:SetAttribute('buttonlock', tonumber(GetCVar'lockActionBars') == 1 and true or false)
			bu:SetAttribute('checkselfcast',  true)
			bu:SetAttribute('checkfocuscast', true)
			bu:SetAttribute('*unit2', 'player') -- 'player' or nil
		end
	end

    local UpdateButtons = function(self, method, ...)
        for _,  button in next, self._buttons do
            if  button[method] then
                button[method](button, ...)
            end
        end
    end

    local UpdateBars = function(_, method, ...)
        for _,  bar in next, ABARS do
            if  bar[method] then
                bar[method](bar, ...)
            end
        end
    end

    local UpdateVisibility = function()
        local states = {
            ['bar1'] = true,
            ['bar2'] = SHOW_MULTI_ACTIONBAR_1,
            ['bar3'] = SHOW_MULTI_ACTIONBAR_2,
            ['bar4'] = SHOW_MULTI_ACTIONBAR_3,
            ['bar5'] = SHOW_MULTI_ACTIONBAR_3 and SHOW_MULTI_ACTIONBAR_4,
        }
        for id,  bar in next, ABARS do
            RegisterStateDriver(bar, 'visibility', states[id] and bars[id].visibility or 'hide')
        end
    end

    local ShortenBindings = function(self)
        local t = self._command and GetBindingKey(self._command) or nil
        if  t then
            t = gsub(t, 'SHIFT%-', 'S·')
            t = gsub(t, "CTRL%-",  'C·')
            t = gsub(t, 'ALT%-',   'A·')
            t = gsub(t, 'BUTTON',  'M·')
            t = gsub(t, 'NUMPAD',  'Nu')
            for i, v in pairs(keys) do
                t = gsub(t, i, v)
            end
        end
        return t or ''
    end


    --

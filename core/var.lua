

	local _, ns = ...

	-- TODO:
    --      combat text (todo)
    --          formatting
    --          modifiers on strings
    --          style
    --          url
    --      pvp
    --      raid

	MODUI_VAR = {
		['elements'] = {
			all = true,
			aura = {
				enable 			= true,
				statusbars 		= true,
				values			= true,
			},
			chat = {
				enable			= true,
				events			= true,
				style			= true,
				url				= true,
				sysmsg			= false, -- objective text goes in chat window
			},
			ecastbar = {
				enable			= true,
			},
			error = {
				enable			= false,
				quick			= true,
			},
			mainbar = {
				enable			= true,
				keypress		= true,
			},
			nameplate = {
				enable			= true,
				aura			= true,
				combo			= true,
				friendlyclass 	= false,
				totem			= true,
			},
			onebag = {
				enable			= true,
				greys			= true,
			},
			tooltip = {
				enable			= true,
			},
			tracker = {
				enable 			= true,
			},
			unit = {
				enable 			= true,
				player 			= true,
				target 			= true,
				party 			= true,
				tot				= true,
				pet 			= true,
				vcolour			= true,
				rcolour 		= true,
			},
		},
		['statusbar'] = {
			smooth = true,
		},
		['theme'] 		= {r =  0, g =  0, b =  0},
		['theme_bu']	= {r = .4, g = .4, b = .4},
	}


	--

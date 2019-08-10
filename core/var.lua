

	local _, ns = ...

	--  colour wheel for skin (default: dark?)
    --  toggle:
    --      aura:
    --          statusbars
    --          numerics
    --      chat:
    --      combat text (todo)
    --          formatting
    --          modifiers on strings
    --          style
    --          url
    --      mainbar
    --      one-bag
    --      nameplate
    --          castbar (nb: not working rn)
    --          combo
    --          totem
    --      pvp (todo)
    --      raid (todo)
    --      tooltip
    --      tracker for quest
    --      unit frame (to finish):
    --          display options
    --          text numeric options
    --          smooth bars (?)
    --          class colour biz

	MODUI_VAR = {
		['elements'] = {
			unit = {
				enable 	= true,
				player 	= true,
				target 	= true,
				party 	= true,
				tot		= true,
				pet 	= true,
				--raid (tbd)
				vcolour	= true,
				rcolour = true,
			},
		},
		['statusbar'] = {
			smooth = true,
		},
		['theme'] = {r = 0, g = 0, b = 0},
	}


	--



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
				colornames      = true,
			},
			ecastbar = {
				enable			= true,
			},
			error = {
				enable			= true,
				quick			= true,
			},
			mainbar = {
				enable			= true,
				keypress		= true,
				xp				= true,
				horiz			= false,
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
			statusbar = {
				health 			= {r = 0, g =  1, b =   0},
				mana 			= {r = 0, g =  0, b =   1},
				rage			= {r = 1, g =  0, b =   0},
				focus			= {r = 1, g = .5, b = .25},
				energy			= {r = 1, g =  1, b =   0},
			},
			tooltip = {
				enable			= true,
				mouseanchor		= false,
				disablefade		= false,
			},
			tracker = {
				enable 			= true,
			},
			unit = {
				enable 			= true,
				castbar			= true,
				player 			= true,
				target 			= true,
				party 			= true,
				tot				= true,
				pet 			= true,
				auras			= true,
				vcolour			= true,
				rcolour 		= true,
			},
			talentbuilds = {
				enable 			= false,
			}
		},
		['statusbar'] = {
			smooth = true,
		},
		['theme'] 		= {r =  0, g =  0, b =  0},
		['theme_bu']	= {r = .4, g = .4, b = .4},
	}
	MODUI_VAR_DEFAULTS = MODUI_VAR

	local OnEvent = function(self, event, addon)
		-- Copies default values to the saved variables
		-- This makes sure existing saved variables get newly added options
		local function MergeTable(source, destination)
			if destination == nil then
				destination = {}
			end

			for key, value in pairs(source) do
				if type(value) == 'table' then
					destination[key] = MergeTable(value, destination[key])
				elseif destination[key] == nil then
					destination[key] = value
				end
			end

			return destination
		end

		MODUI_VAR = MergeTable(MODUI_VAR_DEFAULTS, MODUI_VAR)
	end
	
	local e = CreateFrame'Frame'
	e:RegisterEvent'VARIABLES_LOADED'
	e:SetScript('OnEvent', OnEvent)

	--

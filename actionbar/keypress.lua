

	local _, ns = ...

	local time = nil

	local SetButtonColour = function(self, r, g, b)
		for i = 1, 4 do
			self.bo[i]:SetVertexColor(r, g, b)
		end
	end

	local AddBorderColour = function(self, newtime)
		if  self:GetChecked() then
			self.checked = true
			SetButtonColour(self, 255/255, 240/255, 0/255)
		end
		if  self.keypress then
			local i = (newtime - self.keypress)*5
			SetButtonColour(self, .3*i, .3*i, .3*i)
		end
		if  self.checked and not self:GetChecked() then
			SetButtonColour(self, MODUI_VAR['theme_bu'].r, MODUI_VAR['theme_bu'].g, MODUI_VAR['theme_bu'].b)
			self.checked = nil
		end
		if  self.keypress and newtime > (self.keypress + .4) then
			SetButtonColour(self, MODUI_VAR['theme_bu'].r, MODUI_VAR['theme_bu'].g, MODUI_VAR['theme_bu'].b)
			self.keypress = nil
		end
	end

	local AddPetBorderColour = function()
		for i = 1, 10 do
			local bu = _G['PetActionButton'..i]
			local _, _, _, _, active = GetPetActionInfo(i)
			if  active then
				SetButtonColour(bu, 255/255, 240/255, 0/255)
			else
				SetButtonColour(bu, MODUI_VAR['theme_bu'].r, MODUI_VAR['theme_bu'].g, MODUI_VAR['theme_bu'].b)
			end
		end
	end

	local AddKeyDown = function(bu)
		if  not bu.keydown then
			local buttontype =  string.upper(bu:GetName()) or bu:GetAttribute'binding'
			buttontype = replace(buttontype, 'BOTTOMLEFT', '1')
			buttontype = replace(buttontype, 'BOTTOMRIGHT', '2')
			buttontype = replace(buttontype, 'RIGHT', '3')
			buttontype = replace(buttontype, 'LEFT', '4')
			buttontype = replace(buttontype, 'MULTIBAR', 'MULTIACTIONBAR')

			local key = GetBindingKey(buttontype)
			if  key then
				bu:RegisterForClicks'AnyDown'
				SetOverrideBinding(bu, true, key, 'CLICK '..bu:GetName()..':LeftButton')
			end

			bu.keydown = true
		end
	end

	local ButtonDown = function(id)
		local time 	= GetTime()
		local bu	= GetActionButtonForID(id)
		if  bu:GetButtonState() == 'PUSHED' then
			bu.keypress = time
		end
	end

	local OnUpdate = function(self, elapsed)
		if  self.bo then
			AddBorderColour(self, GetTime())
		end
	end

	local PetOnUpdate = function(self, elapsed)
		if  self.bo then
			AddPetBorderColour(self, GetTime())
		end
	end

	local OnEvent = function(self, event)
		hooksecurefunc('ActionButtonDown', ButtonDown)
		hooksecurefunc('ActionButton_OnUpdate', OnUpdate)
		hooksecurefunc('PetActionBarFrame_OnUpdate', PetOnUpdate)

		if  MODUI_VAR['elements']['mainbar'].keypress then
			hooksecurefunc('ActionButton_Update', AddKeyDown)
		end

    end

	local e = CreateFrame'Frame'
	e:RegisterEvent'PLAYER_LOGIN'
	e:SetScript('OnEvent', OnEvent)


	--

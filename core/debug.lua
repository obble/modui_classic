

	local _, ns = ...

	local EnableErrors = function()
		if  GetCVar'ScriptErrors' == '0' then
			SetCVar('ScriptErrors', 1)
		end
	end

	local e = CreateFrame'Frame'
	e:RegisterEvent'PLAYER_LOGIN'
	e:SetScript('OnEvent', EnableErrors)


	--

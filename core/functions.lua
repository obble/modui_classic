

	local _, ns = ...

	ns.IsClassic = function()
		local build = tonumber(string.sub(GetBuildInfo() , 1, 2))
		if  build < 2 then
			return true -- it's wow: classic, baby
		else
			return false
		end
	end


	--

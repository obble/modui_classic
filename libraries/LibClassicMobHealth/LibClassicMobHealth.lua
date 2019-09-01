--[[
Name: LibClassicMobHealth-1.0
Current Author: Pneumatus
Original Author: Cameron Kenneth Knight (ckknight@gmail.com)
Inspired By: MobHealth3 by Neronix
Description: Estimate a mob's health
License: LGPL v2.1
]]

local MAJOR_VERSION = "LibClassicMobHealth-1.0"
local MINOR_VERSION = 1

-- #AUTODOC_NAMESPACE lib

local lib, oldMinor = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not lib then
	return
end
local oldLib
if oldMinor then
	oldLib = {}
	for k,v in pairs(lib) do
		oldLib[k] = v
		lib[k] = nil
	end
end

local _G = _G
local UnitLevel = _G.UnitLevel
local UnitIsPlayer = _G.UnitIsPlayer
local UnitPlayerControlled = _G.UnitPlayerControlled
local UnitName = _G.UnitName
local UnitHealth = _G.UnitHealth
local UnitHealthMax = _G.UnitHealthMax
local UnitIsFriend = _G.UnitIsFriend
local UnitIsDead = _G.UnitIsDead
local UnitCanAttack = _G.UnitCanAttack
local math_floor = _G.math.floor
local setmetatable = _G.setmetatable
local type = _G.type
local pairs = _G.pairs
local next = _G.next

local frame
if oldLib then
	frame = oldLib.frame
	frame:UnregisterAllEvents()
	frame:SetScript("OnEvent", nil)
	frame:SetScript("OnUpdate", nil)
	_G.LibClassicMobHealth10DB = nil
end
frame = oldLib and oldLib.frame or _G.CreateFrame("Frame", MAJOR_VERSION .. "_Frame")

frame:RegisterEvent("UNIT_COMBAT")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("UNIT_HEALTH")
frame:RegisterEvent("ADDON_LOADED")

frame:SetScript("OnEvent", function(this, event, ...)
	this[event](lib, ...)
end)

local mt = {__index = function(self, key)
	if key == nil then
		return nil
	end
	local t = {}
	self[key] = t
	return t
end}

local data = oldLib and oldLib.data
if not data then
	data = {
		npc = setmetatable({}, mt),
		pc = setmetatable({}, mt),
		pet = setmetatable({}, mt)
	}
end
lib.data = data -- stores the maximum health of mobs that will actually be shown to the user
data.revision = MINOR_VERSION

local accumulatedHP = setmetatable({}, mt) -- Keeps Damage-taken data for mobs that we've actually poked during this session
local accumulatedPercent = setmetatable({}, mt) -- Keeps Percentage-taken data for mobs that we've actually poked during this session
local calculationUnneeded = setmetatable({}, mt) -- Keeps a list of things that don't need calculation (e.g. Beast Lore'd mobs)

local currentAccumulatedHP = nil
local currentAccumulatedPercent = nil
local currentName = nil
local currentLevel = nil
local recentDamage = nil
local lastPercent = nil


_G.hash_SlashCmdList["LIBCLASSICMOBHEALTHONE"] = nil
_G.SlashCmdList["LIBCLASSICMOBHEALTHONE"] = nil

function frame:ADDON_LOADED(name)
	if name == "Tukui" then
		-- if we're not an embedded library, then use a saved variable
		frame:RegisterEvent("PLAYER_LOGOUT")
		if type(_G.LibClassicMobHealth10DB) == "table" then
			data = _G.LibClassicMobHealth10DB
			setmetatable(data.npc, mt)
			setmetatable(data.pc, mt)
			setmetatable(data.pet, mt)
			lib.data = data
		else
			_G.LibClassicMobHealth10DB = data
		end
		
		local options = _G.LibClassicMobHealth10Opt
		if type(options) ~= "table" then
			options = {
				save = true,
				prune = 1000,
			}
			_G.LibClassicMobHealth10Opt = options
		end
		
		_G.hash_SlashCmdList["LIBCLASSICMOBHEALTHONE"] = nil
		_G.SlashCmdList["LIBCLASSICMOBHEALTHONE"] = function(text)
			text = text:lower():trim()
			local alpha, bravo = text:match("^([^%s]+)%s+(.*)$")
			if not alpha then
				alpha = text
			end
			if alpha == "" or alpha == "help" then
				DEFAULT_CHAT_FRAME:AddMessage(("|cffffff7f%s|r"):format(MAJOR_VERSION))
				DEFAULT_CHAT_FRAME:AddMessage((" - |cffffff7f%s|r [%s] - %s"):format("save", options.save and "|cff00ff00On|r" or "|cffff0000Off|r", "whether to save mob health data"))
				DEFAULT_CHAT_FRAME:AddMessage((" - |cffffff7f%s|r [%s] - %s"):format("prune", options.prune == 0 and "|cffff0000Off|r" or "|cff00ff00" .. options.prune .. "|r", "how many data points until data is pruned, 0 means no pruning"))
			elseif alpha == "save" then
				options.save = not options.save
				DEFAULT_CHAT_FRAME:AddMessage(("|cffffff7f%s|r"):format(MAJOR_VERSION))
				DEFAULT_CHAT_FRAME:AddMessage((" - |cffffff7f%s|r [%s]"):format("save", options.save and "|cff00ff00On|r" or "|cffff0000Off|r"))
			elseif alpha == "prune" then
				local bravo_num = tonumber(bravo)
				if bravo_num then
					options.prune = math.floor(bravo_num+0.5)
					DEFAULT_CHAT_FRAME:AddMessage(("|cffffff7f%s|r"):format(MAJOR_VERSION))
					DEFAULT_CHAT_FRAME:AddMessage((" - |cffffff7f%s|r [%s]"):format("prune", options.prune == 0 and "|cffff0000Off|r" or "|cff00ff00" .. options.prune .. "|r"))
				else
					DEFAULT_CHAT_FRAME:AddMessage(("|cffffff7f%s|r - prune must take a number, %q is not a number"):format(MAJOR_VERSION, bravo or ""))
				end
			else
				DEFAULT_CHAT_FRAME:AddMessage(("|cffffff7f%s|r - unknown command %q"):format(MAJOR_VERSION, alpha))
			end
		end
		
		_G.SLASH_LIBCLASSICMOBHEALTHONE1 = "/lcmh1"
		_G.SLASH_LIBCLASSICMOBHEALTHONE2 = "/lcmh"
		_G.SLASH_LIBCLASSICMOBHEALTHONE3 = "/libclassicmobhealth1"
		_G.SLASH_LIBCLASSICMOBHEALTHONE4 = "/libclassicmobhealth"
		
		function frame:PLAYER_LOGOUT()
			if not options.save then
				_G.LibClassicMobHealth10DB = nil
				return
			end
			local count = 0
			setmetatable(data.npc, nil)
			setmetatable(data.pc, nil)
			setmetatable(data.pet, nil)
			for _, kind in ipairs({ 'npc', 'pc', 'pet' }) do
				for k,v in pairs(data[kind]) do
					if not next(v) then
						data[kind][k] = nil
					else
						for _ in pairs(v) do
							count = count + 1
						end
					end
				end
			end
			local prune = options.prune
			if not prune or prune <= 0 then
				return
			end
			if count <= prune then
				return
			end
			
			-- let's try to only have one mob-level, don't have duplicates for each level, since they can be estimated, and for players/pets, this will get rid of old data
			local mobs = {}
			for _, kind in ipairs({ 'npc', 'pc', 'pet' }) do
				for level, d in pairs(data[kind]) do
					for mob, health in pairs(d) do
						if mobs[mob] then
							d[mob] = nil
							count = count - 1
						end
						mobs[mob] = level
					end	
					if next(d) == nil then
						data[kind][level] = nil
					end
				end
			end
			mobs = nil
			if count <= prune then
				return
			end
			-- still too much data, let's get rid of low-level non-bosses until we're at `prune`
			local playerLevel = UnitLevel("player")
			local maxLevel = playerLevel*3/4
			if maxLevel > playerLevel - 5 then
				maxLevel = playerLevel - 5
			end
			for level = 1, maxLevel do
				for _, kind in ipairs({ 'npc', 'pet', 'pc' }) do
					local d = data[kind][level]
					if d then
						for mob, health in pairs(d) do
							d[mob] = nil
							count = count - 1
						end
						data[kind][level] = nil
						if count <= prune then
							return
						end
					end
				end
			end
		end
	end
	frame:UnregisterEvent("ADDON_LOADED")
	frame.ADDON_LOADED = nil
end


function frame:UNIT_COMBAT(unit, _, _, damage)
	if unit ~= "target" or not currentAccumulatedHP then
		return
	end
	recentDamage = recentDamage + damage
end

local function PLAYER_unit_CHANGED(unit)
	if not UnitCanAttack("player", unit) or UnitIsDead(unit) or UnitIsFriend("player", unit) then
		-- don't store data on friends and dead men tell no tales
		currentAccumulatedHP = nil
		currentAccumulatedPercent = nil
		return
	end
	
	local name, server = UnitName(unit)
	if server and server ~= "" then
		name = name .. "-" .. server
	end
	local isPlayer = UnitIsPlayer(unit)
	local isPet = UnitPlayerControlled(unit) and not isPlayer -- some owners name their pets the same name as other people, because they're think they're funny. They're not.
	currentName = name
	local level = UnitLevel(unit)
	currentLevel = level
	
	recentDamage = 0
	lastPercent = UnitHealth(unit)
	
	currentAccumulatedHP = accumulatedHP[level][name]
	currentAccumulatedPercent = accumulatedPercent[level][name]
	
	if not isPlayer and not isPet then
		-- Mob
		if not currentAccumulatedHP then
			local saved = data.npc	[level][name]
			if saved then
				-- We claim that the saved value is worth 100%
				accumulatedHP[level][name] = saved
				accumulatedPercent[level][name] = 100
			else
				-- Nothing previously known. Start fresh.
				accumulatedHP[level][name] = 0
				accumulatedPercent[level][name] = 0
			end
			currentAccumulatedHP = accumulatedHP[level][name]
			currentAccumulatedPercent = accumulatedPercent[level][name]
		end
		
		if currentAccumulatedPercent > 200 then
			-- keep accumulated percentage below 200% in case we hit mobs with different hp
			currentAccumulatedHP = currentAccumulatedHP / currentAccumulatedPercent * 100
			currentAccumulatedPercent = 100
		end
	else
		-- Player health can change a lot. Different gear, buffs, etc.. we only assume that we've seen 10% knocked off players previously
		if not currentAccumulatedHP then
			local saved = data[isPet and 'pet' or 'pc'][level][name]
			if saved then
				-- We claim that the saved value is worth 10%
				accumulatedHP[level][name] = saved/10
				accumulatedPercent[level][name] = 10
			else
				accumulatedHP[level][name] = 0
				accumulatedPercent[level][name] = 0
			end
			currentAccumulatedHP = accumulatedHP[level][name]
			currentAccumulatedPercent = accumulatedPercent[level][name]
		end

		if currentAccumulatedPercent > 10 then
			currentAccumulatedHP = currentAccumulatedHP / currentAccumulatedPercent * 10
			currentAccumulatedPercent = 10
		end
	end
end

function frame:PLAYER_TARGET_CHANGED()
	PLAYER_unit_CHANGED("target")
end

function frame:UNIT_HEALTH(unit)
	if unit ~= "target" or not currentAccumulatedHP then
		return
	end
	
	local current = UnitHealth(unit)
	local max = UnitHealthMax(unit)
	local name = currentName
	local level = currentLevel
	local kind
	if UnitIsPlayer(unit) then
		kind = 'pc'
	elseif UnitPlayerControlled(unit) then
		kind = 'pet'
	else
		kind = 'npc'
	end
	
	if calculationUnneeded[level][name] then
		return
	elseif current == 0 then
		-- possibly targetting a dead person
	elseif max ~= 100 then
		-- beast lore, don't need to calculate.
		if kind == 'npc' then
			data.npc[level][name] = max
		else
			data[kind][level][name] = max
		end
		calculationUnneeded[level][name] = true
	elseif current > lastPercent or lastPercent > 100 then
		-- it healed, so let's reset our ephemeral calculations
		lastPercent = current
		recentDamage = 0
	elseif recentDamage > 0 then
		if current ~= lastPercent then
			currentAccumulatedHP = currentAccumulatedHP + recentDamage
			currentAccumulatedPercent = currentAccumulatedPercent + (lastPercent - current)
			recentDamage = 0
			lastPercent = current
			
			if currentAccumulatedPercent >= 10 then
				local num = currentAccumulatedHP / currentAccumulatedPercent * 100
				if kind == 'npc' then
					data.npc[level][name] = num
				else
					data[kind][level][name] = num
				end
			end
		end
	end
end

local function guessAtMaxHealth(name, level, kind, known)
	-- if we have data on a mob of the same name but a different level, check within two levels and guess from there.
	if not kind then
		return guessAtMaxHealth(name, level, 'npc') or guessAtMaxHealth(name, level, 'pc') or guessAtMaxHealth(name, level, 'pet')
	end
	
	local value = data[kind][level][name]
	if value or level <= 0 or known then
		return value
	end
	if level > 1 then
		value = data[kind][level - 1][name]
		if value then
			return value * level/(level - 1)
		end
	end
	value = data[kind][level + 1][name]
	if value then
		return value * level/(level + 1)
	end
	if level > 2 then
		value = data[kind][level - 2][name]
		if value then
			return value * level/(level - 2)
		end
	end
	value = data[kind][level + 2][name]
	if value then
		return value * level/(level + 2)
	end
	return nil
end

--[[
Arguments:
	string - name of the unit in question in the form of "Someguy", "Someguy-Some Realm"
	number - level of the unit in question
	string - kind of unit, can be "npc", "pc", "pet"
	[optional] boolean - whether not to guess at the mob's health based on other levels of said mob.
Returns:
	number or nil - the maximum health of the unit or nil if unknown
Example:
	local hp = LibStub("LibClasicMobHealth-1.0"):GetMaxHP("Young Wolf", 2)
]]
function lib:GetMaxHP(name, level, kind, known)
	local value = guessAtMaxHealth(name, level, kind, known)
	if value then
		return math_floor(value + 0.5)
	else
		return nil
	end
end

--[[
Arguments:
	string - a unit ID
Returns:
	number, boolean - the maximum health of the unit, whether the health is known or not
Example:
	local maxhp, found = LibStub("LibClasicMobHealth-1.0"):GetUnitMaxHP("target")
]]
function lib:GetUnitMaxHP(unit)
	local max = UnitHealthMax(unit)
	if max ~= 100 then
		return max, true
	end
	local name, server = UnitName(unit)
	if server and server ~= "" then
		name = name .. "-" .. server
	end
	local level = UnitLevel(unit)
	
	local kind
	if UnitIsPlayer(unit) then
		kind = 'pc'
	elseif UnitPlayerControlled(unit) then
		kind = 'pet'
	else
		kind = 'npc'
	end
	
	local value = guessAtMaxHealth(name, level, kind)
	if value then
		return math_floor(value + 0.5), true
	else
		return max, false
	end
end

--[[
Arguments:
	string - a unit ID
Returns:
	number, boolean - the current health of the unit, whether the health is known or not
Example:
	local curhp, found = LibStub("LibClasicMobHealth-1.0"):GetUnitCurrentHP("target")
]]
function lib:GetUnitCurrentHP(unit)
	local current, max = UnitHealth(unit), UnitHealthMax(unit)
	if max ~= 100 then
		return current, true
	end
	
	local name, server = UnitName(unit)
	if server and server ~= "" then
		name = name .. "-" .. server
	end
	local level = UnitLevel(unit)
	
	local kind
	if UnitIsPlayer(unit) then
		kind = 'pc'
	elseif UnitPlayerControlled(unit) then
		kind = 'pet'
	else
		kind = 'npc'
	end
	
	local value = guessAtMaxHealth(name, level, kind)
	if value then
		return math_floor(current/max * value + 0.5), true
	else
		return current, false
	end
end

--[[
Arguments:
	string - a unit ID
Returns:
	number, number, boolean - the current health of the unit, the maximum health of the unit, whether the health is known or not
Example:
	local curhp, maxhp, found = LibStub("LibClasicMobHealth-1.0"):GetUnitHealth("target")
]]
function lib:GetUnitHealth(unit)
	local current, max = UnitHealth(unit), UnitHealthMax(unit)
	if max ~= 100 then
		return current, max, true
	end

	local name, server = UnitName(unit)
	if server and server ~= "" then
		name = name .. "-" .. server
	end
	local level = UnitLevel(unit)
	
	local kind
	if UnitIsPlayer(unit) then
		kind = 'pc'
	elseif UnitPlayerControlled(unit) then
		kind = 'pet'
	else
		kind = 'npc'
	end
	
	local value = guessAtMaxHealth(name, level, kind)
	if value then
		return math_floor(current/max * value + 0.5), math_floor(value + 0.5), true
	else
		return current, max, false
	end
end

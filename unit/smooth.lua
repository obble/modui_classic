---------------------------------------------------------------------
-- Smooth animations -- Ls

local smoothing = {}
local pairs = pairs
local floor = math.floor
local mabs = math.abs
local UnitGUID = UnitGUID
local TARGET_FPS = 60
local AMOUNT = .33
local smoothframe = CreateFrame("Frame")

local barstosmooth = {
    PlayerFrameHealthBar = "player",
    PlayerFrameManaBar = "player",
    TargetFrameHealthBar = "target",
    TargetFrameManaBar = "target",
    FocusFrameHealthBar = "focus",
    FocusFrameManaBar = "focus",
}

local function clamp(v, min, max)
    min = min or 0
    max = max or 1

    if v > max then
        return max
    elseif v < min then
        return min
    end

    return v
end

local function lerp(startValue, endValue, amount)
    return (1 - amount) * startValue + amount * endValue
end

local function isCloseEnough(new, target, range)
    if range > 0 then
        return mabs((new - target) / range) <= 0.001
    end

    return true
end

local function AnimationTick(_, elapsed)
    for unitFrame, info in next, smoothing do
        local newValue = lerp(unitFrame._value, info, clamp(AMOUNT * elapsed * TARGET_FPS))

        if isCloseEnough(newValue, info, unitFrame._max - unitFrame._min) then
            newValue = info
            smoothing[unitFrame] = nil
        end

        unitFrame:SetValue_(floor(newValue))
        unitFrame._value = newValue
    end
end

local function SetSmoothedValue(self, value)
    value = tonumber(value)
    self.finalValue = value

    if self.unit then
        local guid = UnitGUID(self.unit)
        if guid ~= self.guid then
            smoothing[self] = nil
            self:SetValue_(floor(value))
        end
        self.guid = guid
    end

    self._value = self:GetValue()
    smoothing[self] = clamp(value, self._min, self._max)
end

local function SmoothSetValue(self, min, max)
    min, max = tonumber(min), tonumber(max)

    self:SetMinMaxValues_(min, max)

    if self._max and self._max ~= max then
        local ratio = 1
        if max ~= 0 and self._max and self._max ~= 0 then
            ratio = max / (self._max or max)
        end

        local target = smoothing[self]
        if target then
            smoothing[self] = target * ratio
        end

        local cur = self._value
        if cur then
            self:SetValue_(cur * ratio)
            self._value = cur * ratio
        end
    end

    self._min = min
    self._max = max
end


local function SmoothBar(bar)
    bar._min, bar._max = bar:GetMinMaxValues()
    bar._value = bar:GetValue()

    if not bar.SetValue_ then
        bar.SetValue_ = bar.SetValue
        bar.SetValue = SetSmoothedValue
    end
    if not bar.SetMinMaxValues_ then
        bar.SetMinMaxValues_ = bar.SetMinMaxValues
        bar.SetMinMaxValues = SmoothSetValue
    end
end

local function onUpdate()
    for _, plate in pairs(C_NamePlate.GetNamePlates(true)) do
        if not plate:IsForbidden() and plate:IsVisible() and plate.UnitFrame:IsShown() then
            SmoothBar(plate.UnitFrame.healthBar)
        end
    end
    AnimationTick()
end

local function init()
    for k,v in pairs (barstosmooth) do
        if _G[k] then
            SmoothBar(_G[k])
            _G[k]:HookScript("OnHide", function()
                _G[k].guid = nil;
                _G[k].max_ = nil
                _G[k].min_ = nil
            end)
            if v ~= "" then
                _G[k].unit = v
            end
        end
    end
end



smoothframe:RegisterEvent("ADDON_LOADED")
smoothframe:SetScript("OnEvent", function(self, event)
    if event == "ADDON_LOADED" then
        init()
        smoothframe:SetScript("OnUpdate", AnimationTick)
    end
    self:UnregisterEvent("ADDON_LOADED")
    self:SetScript("OnEvent", nil)
end)

local _, ns = ...
local skin = ns.skin
local addons = ns.addon_skins

local function load()
    QuestLogFrame.Material:ClearAllPoints()
    QuestLogFrame.Material:SetPoint('TOPLEFT', QuestLogDetailScrollFrame, 'TOPLEFT', -10, 0)
    QuestLogFrame.Material:SetSize(520, 552)
    local _, _, _, _, _, _, _, _, _, _, _, _, a, b = QuestLogFrame:GetRegions()
    for _, v in pairs({a, b}) do
        tinsert(skin, v)
    end
end

tinsert(addons, {name = 'WideQuestLog', load = load})

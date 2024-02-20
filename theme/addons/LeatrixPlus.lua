local _, ns = ...
local addons = ns.addon_skins

local function load()
    if LeaPlusDB['EnhanceQuestLog'] == 'On' then
        QuestLogFrame.Material:SetSize(510, 512)
    end
end

tinsert(addons, {name = 'Leatrix_Plus', load = load})

local _, ns = ...

local f = CreateFrame'Frame'
local build = tonumber(string.sub(GetBuildInfo() , 1, 2))
local UpdateSkins = nil

ns.colour   = {MODUI_VAR['theme'].r, MODUI_VAR['theme'].g, MODUI_VAR['theme'].b}
ns.colour_bu = {MODUI_VAR['theme_bu'].r, MODUI_VAR['theme_bu'].g, MODUI_VAR['theme_bu'].b}

ns.addon_skins = {}
ns.skin     = {
    MinimapBorder,
    MiniMapTrackingBorder,
    MiniMapMailBorder,
    MiniMapBattlefieldBorder,

    PlayerFrameTexture,
    TargetFrameTextureFrameTexture,
    FocusFrameTextureFrameTexture,
    PetFrameTexture,
    PartyMemberFrame1Texture,
    PartyMemberFrame2Texture,
    PartyMemberFrame3Texture,
    PartyMemberFrame4Texture,
    PartyMemberFrame1PetFrameTexture,
    PartyMemberFrame2PetFrameTexture,
    PartyMemberFrame3PetFrameTexture,
    PartyMemberFrame4PetFrameTexture,

    StanceBarLeft,
    StanceBarMiddle,
    StanceBarRight,

    SlidingActionBarTexture0,
    SlidingActionBarTexture1,

    CastingBarFrame.Border,

    _G['TargetFrameToTTextureFrameTexture'],
    _G['FocusFrameToTTextureFrameTexture'],
}
ns.skinbu   = {}
ns.skinb    = {}
ns.skinmenu = {}

-- 8.0?
if  build > 1 then
    for _, v in pairs(
        {
            -- MainMenuBarArtFrameBackground.BackgroundLarge,
            -- MainMenuBarArtFrameBackground.BackgroundSmall,
            -- MainMenuBarArtFrame.LeftEndCap,
            -- MainMenuBarArtFrame.RightEndCap,
            -- MicroButtonAndBagsBar.MicroBagBar,
        }
        ) do
        tinsert(ns.skin, v)
    end
else
    for _, v in pairs(
        {
            MainMenuBarTexture0,
            MainMenuBarTexture1,
            MainMenuBarTexture2,
            MainMenuBarTexture3,
            MainMenuMaxLevelBar0,
            MainMenuMaxLevelBar1,
            MainMenuMaxLevelBar2,
            MainMenuMaxLevelBar3,
            MainMenuXPBarTextureLeftCap,
            MainMenuXPBarTextureRightCap,
            MainMenuXPBarTextureMid,
            BonusActionBarTexture0,
            BonusActionBarTexture1,
            MainMenuBarLeftEndCap,
            MainMenuBarRightEndCap,
        }
        ) do
        tinsert(ns.skin, v)
    end
end

-- BAGS
for i = 1, 12 do
    local bagName = 'ContainerFrame'..i
    local _, a, b, _, c, _, d = _G[bagName]:GetRegions()
    for _, v in pairs({a, b, c, d}) do tinsert(ns.skin, v) end
end

-- BANK
local _, a = BankFrame:GetRegions()
tinsert(ns.skin, a)

-- item text (books etc)
local _, a, b, c, d = ItemTextFrame:GetRegions()
for _, v in pairs({a, b, c, d}) do
    tinsert(ns.skin, v)
end

ItemTextFrame.Material = ItemTextFrame:CreateTexture(nil, 'OVERLAY', nil, 7)
ItemTextFrame.Material:SetTexture[[Interface\AddOns\modui_classic\art\quest\QuestBG.tga]]
ItemTextFrame.Material:SetSize(506, 506)
ItemTextFrame.Material:SetPoint('TOPLEFT', ItemTextFrame, 24, -82)
ItemTextFrame.Material:SetVertexColor(.9, .9, .9)

local a, b, c, d, e, f, g = HelpFrame:GetRegions()
for _, v in pairs({a, b, c, d, e, f, g}) do
    tinsert(ns.skin, v)
end

if HonorFrame then
    local a, b, c, d = HonorFrame:GetRegions()
    for _, v in pairs({a, b, c, d}) do
        tinsert(ns.skin, v)
    end
end

for _,  v in pairs({LootFrame:GetRegions()}) do
    if  v:GetObjectType() == 'Texture' and v ~= LootFramePortraitOverlay then
        tinsert(ns.skin, v)
    end
end
for _,  v in pairs({LootFrameInset:GetRegions()}) do
    if  v:GetObjectType() == 'Texture' then
        tinsert(ns.skin, v)
    end
end

if  LFGParentFrame then
    local _, a = LFGParentFrame:GetRegions()
    for _, v in pairs({a}) do tinsert(ns.skin, v) end
end

for _, v in pairs({MerchantFrame:GetRegions()}) do
    if v:GetObjectType() == 'Texture' and v ~= MerchantFramePortrait then
        tinsert(ns.skin, v)
    end
end
for _,  v in pairs({MerchantFrameInset:GetRegions()}) do
    if  v:GetObjectType() == 'Texture' then
        tinsert(ns.skin, v)
    end
end


tinsert(ns.skin, MerchantBuyBackItemNameFrame)

-- pet stable
for _,  v in pairs({PetStableFrame:GetRegions()}) do
    if  v:GetObjectType() == 'Texture' and v ~= PetStableFramePortrait then
        tinsert(ns.skin, v)
    end
end

-- mail
for _,  v in pairs({MailFrame:GetRegions()}) do
    if  v:GetObjectType() == 'Texture' and v:GetTexture() ~= [[Interface\MailFrame\Mail-Icon]] then
        tinsert(ns.skin, v)
    end
end
for _,  v in pairs({MailFrameInset:GetRegions()}) do
    if  v:GetObjectType() == 'Texture' then
        tinsert(ns.skin, v)
    end
end
for _,  v in pairs({OpenMailFrame:GetRegions()}) do
    if  v:GetObjectType() == 'Texture' and v ~= OpenMailFrameIcon then
        tinsert(ns.skin, v)
    end
end
for _,  v in pairs({OpenMailFrameInset:GetRegions()}) do
    if  v:GetObjectType() == 'Texture' then
        tinsert(ns.skin, v)
    end
end

for i = 1, MIRRORTIMER_NUMTIMERS do
    local m = _G['MirrorTimer'..i]
    local _, _, a = m:GetRegions()
    tinsert(ns.skin, a)
end


-- PAPERDOLL
local a, b, c, d, _, e = PaperDollFrame:GetRegions()
for _, v in pairs({a, b, c, d, e}) do
    tinsert(ns.skin, v)
end

local a, b, c, d = ReputationFrame:GetRegions()
for _, v in pairs({a, b, c, d}) do
    tinsert(ns.skin, v)
end

local a, b, c, d = SkillFrame:GetRegions()
for _, v in pairs({a, b, c ,d}) do
    tinsert(ns.skin, v)
end
for _, v in pairs({ReputationDetailCorner, ReputationDetailDivider}) do
    tinsert(ns.skin, v)
end

--local a, b, c, d = QuestLogFrame:GetRegions()
--for _, v in pairs({a, b, c, d}) do
--    tinsert(ns.skin, v)
--end

--QuestLogFrame.Material = QuestLogFrame:CreateTexture(nil, 'OVERLAY', nil, 7)
--QuestLogFrame.Material:SetTexture[[Interface\AddOns\modui_classic\art\quest\QuestBG.tga]]
--QuestLogFrame.Material:SetSize(510, 398)
--QuestLogFrame.Material:SetPoint('TOPLEFT', QuestLogDetailScrollFrame)
--QuestLogFrame.Material:SetVertexColor(.9, .9, .9)

for _, v in pairs({FriendsFrame:GetRegions()}) do
    if v:GetObjectType() == 'Texture' and v ~= FriendsFrameIcon then
        tinsert(ns.skin, v)
    end
end

local _, a, b, c, d = SpellBookFrame:GetRegions()
for _, v in pairs({a, b, c, d}) do
    tinsert(ns.skin, v)
end

local _, a, b, c, d = TabardFrame:GetRegions()
for _, v in pairs({a, b, c, d, e}) do
    tinsert(ns.skin, v)
end

-- TAXI
local _, a, b, c, d = TaxiFrame:GetRegions()
for _, v in pairs({a, b, c, d}) do
    tinsert(ns.skin, v)
end

-- scoreboard
local a, b, c, d, e, f, _, _, _, _, _, _, g = WorldStateScoreFrame:GetRegions()
for _, v in pairs({a, b, c, d, e, f, g}) do
    tinsert(ns.skin, v)
end

-- worldmap
for _, v in pairs({WorldMapFrame.BorderFrame:GetRegions()}) do
    if v:GetObjectType() == 'Texture' then
        tinsert(ns.skin, v)
    end
end



-- TRADE
local _, _, a, b, c, d = TradeFrame:GetRegions()
for _, v in pairs({a, b, c, d, e}) do
    tinsert(ns.skin, v)
end


-- WARDROBE
local _, a, b, c, d = DressUpFrame:GetRegions()
for _, v in pairs({a, b, c, d, e}) do
    tinsert(ns.skin, v)
end

-- WORLDMAP
local _, a, b, c, d, e, _, _, f, g, h, j, k = WorldMapFrame:GetRegions()
for _, v in pairs({a, b, c, d, e, f, g, h, j, k}) do
    tinsert(ns.skin, v)
end

local ADDON_LOADED = function(self, event, addon)
    local function CheckForAddOn(name)
        if addon == name then
            return true
        elseif addon == 'modui_classic' then
            return IsAddOnLoaded(name)
        end
    end

    for _, v in pairs(ns.addon_skins) do
        if CheckForAddOn(v.name) then
            v.load()
        end
    end

    if addon == 'Blizzard_TimeManager' then
        local a = TimeManagerClockButton:GetRegions()
        tinsert(ns.skin, a)
    elseif addon == 'Blizzard_AuctionUI' then
        local _, a, b, c, d, e, f = AuctionFrame:GetRegions()
        for _, v in pairs({a, b, c, d, e, f}) do
            tinsert(ns.skin, v)
        end
        local a, b = SideDressUpFrame:GetRegions()
        for _, v in pairs({a, b}) do
            tinsert(ns.skin, v)
        end
        local _, _, _, _, a = SideDressUpModelCloseButton:GetRegions()
        tinsert(ns.skin, a)
        for i = 1, 15 do
            local a = _G['AuctionFilterButton'..i]:GetNormalTexture()
            tinsert(ns.skin, a)
        end
        for _, v in pairs({BidCloseButton, BidBidButton, BidBuyoutButton}) do
            local a = v:GetRegions()
            tinsert(ns.skin, a)
        end
    elseif addon == 'Blizzard_CraftUI' then
        local _, a, b, c, d = CraftFrame:GetRegions()
        for  _, v in pairs({a, b, c, d}) do
            tinsert(ns.skin, v)
        end
    elseif addon == 'Blizzard_InspectUI' then
        local a, b, c, d = InspectPaperDollFrame:GetRegions()
        for _, v in pairs({a, b, c, d}) do
            tinsert(ns.skin, v)
        end
        --local a, b, c, d = InspectHonorFrame:GetRegions()
        --for _, v in pairs({a, b, c, d}) do
        --    tinsert(ns.skin, v)
        --end
    elseif addon == 'Blizzard_MacroUI' then
        local _, a, b, c, d = MacroFrame:GetRegions()
        for _, v in pairs({a, b, c, d}) do
            tinsert(ns.skin, v)
        end
        local a, b, c, d = MacroPopupFrame:GetRegions()
        for _, v in pairs({a, b, c, d}) do
            tinsert(ns.skin, v)
        end
    elseif addon == 'Blizzard_RaidUI' then
        local _, a = ReadyCheckFrame:GetRegions()
        tinsert(ns.skin, a)
    elseif addon == 'Blizzard_TalentUI' then
        local _, a, b, c, d = PlayerTalentFrame:GetRegions()
        for _, v in pairs({a, b, c, d}) do
            tinsert(ns.skin, v)
        end
    elseif addon == 'Blizzard_TradeSkillUI' then
        local _, a, b, c, d = TradeSkillFrame:GetRegions()
        for _, v in pairs({a, b, c, d}) do
            tinsert(ns.skin, v)
        end
    elseif addon == 'Blizzard_TrainerUI' then
        local _, a, b, c, d = ClassTrainerFrame:GetRegions()
        for _, v in pairs({a, b, c, d}) do
            tinsert(ns.skin, v)
        end
    end
end

-- QUESTS
for _, v in pairs(
    {
        QuestFrameGreetingPanel,
        QuestFrameDetailPanel,
        QuestFrameProgressPanel,
        QuestFrameRewardPanel,
        GossipFrameGreetingPanel
    }
    ) do
    for _, j in pairs({v:GetRegions()}) do
        tinsert(ns.skin, j)
    end

    v.Material = v:CreateTexture(nil, 'OVERLAY', nil, 7)
    v.Material:SetTexture[[Interface\AddOns\modui_classic\art\quest\QuestBG.tga]]
    v.Material:SetSize(506, 506)
    v.Material:SetPoint('TOPLEFT', v, 24, -82)
    v.Material:SetVertexColor(.9, .9, .9)

    if  v == GossipFrameGreetingPanel or v == QuestFrameGreetingPanel then
        v.Corner = v:CreateTexture(nil, 'OVERLAY', nil, 7)
        v.Corner:SetTexture[[Interface\QuestFrame\UI-Quest-BotLeftPatch]]
        v.Corner:SetSize(132, 64)
        v.Corner:SetPoint('BOTTOMLEFT', v, 21, 68)
        tinsert(ns.skin, v.Corner)
    end
end

-- POP-UP (border)
for i = 1, 4 do
    local v = _G['StaticPopup'..i]
    tinsert(ns.skinb, v)
end

-- COLOUR PICKER
tinsert(ns.skinb, ColorPickerFrame)
tinsert(ns.skin, ColorPickerFrameHeader)


-- MENU
tinsert(ns.skinb, GameMenuFrame)
tinsert(ns.skin, GameMenuFrameHeader)


-- GRAPHICS MENU
tinsert(ns.skinb, OptionsFrame)
tinsert(ns.skin, OptionsFrameHeader)


-- SOUND MENU
tinsert(ns.skinb, SoundOptionsFrame)
tinsert(ns.skin, SoundOptionsFrameHeader)

-- QUEST TIMER
tinsert(ns.skinb, QuestTimerFrame)
tinsert(ns.skin, QuestTimerHeader)

UpdateSkins = function()
    for _,  v in pairs(ns.skin) do
        if  v and v:GetObjectType() == 'Texture' and v:GetVertexColor() then
            v:SetVertexColor(
            MODUI_VAR['theme'].r,
            MODUI_VAR['theme'].g,
            MODUI_VAR['theme'].b
            )
        end
    end
    for _,  v in pairs(ns.skinb) do
        if  v and v:GetBackdropBorderColor() then
            v:SetBackdropBorderColor(
            MODUI_VAR['theme'].r,
            MODUI_VAR['theme'].g,
            MODUI_VAR['theme'].b
            )
        end
    end
    for _,  v in pairs(ns.skinbu) do
        if  v and v:GetObjectType() == 'Texture' and v:GetVertexColor() then
            v:SetVertexColor(
            MODUI_VAR['theme'].r,
            MODUI_VAR['theme'].g,
            MODUI_VAR['theme'].b
            )
        end
    end
    -- offset menu buttons a lil bit
    for _, v in pairs(ns.skinmenu) do
        if  v and v:GetObjectType() == 'Texture' and v:GetVertexColor() then
            if  MODUI_VAR['theme'].r < .2 and MODUI_VAR['theme'].g < .2 and MODUI_VAR['theme'].b < .2 then
                v:SetDesaturated(true)
                v:SetVertexColor(.25, .25, .25)
            else
                v:SetDesaturated(false)
                v:SetVertexColor(
                MODUI_VAR['theme'].r < .7 and MODUI_VAR['theme'].r + .2 or .85,
                MODUI_VAR['theme'].g < .7 and MODUI_VAR['theme'].g + .2 or .85,
                MODUI_VAR['theme'].b < .7 and MODUI_VAR['theme'].b + .2 or .85
                )
            end
        end
    end
end

-- colour picker
local ColourPicker = function(r, g, b, a, callback, theme)
    ColorPickerFrame:SetColorRGB(
    theme and MODUI_VAR['theme'].r or MODUI_VAR['theme_bu'].r,
    theme and MODUI_VAR['theme'].g or MODUI_VAR['theme_bu'].g,
    theme and MODUI_VAR['theme'].b or MODUI_VAR['theme_bu'].b
    )
    ColorPickerFrame.hasOpacity = false
    ColorPickerFrame.func = callback
    ColorPickerFrame:Hide()
    ColorPickerFrame:Show()
    ColorPickerFrame:SetPoint'CENTER'
    if  theme then
        ColorPickerFrame.theme  = true
    end
end

ColorPickerFrame.reset = CreateFrame('Button', 'ColorPickerFrameReset', ColorPickerFrame, 'GameMenuButtonTemplate')
ColorPickerFrame.reset:SetSize(144, 24)
ColorPickerFrame.reset:SetText'Reset to Default'
ColorPickerFrame.reset:SetPoint('BOTTOMLEFT', ColorPickerOkayButton, 0, 22)
ColorPickerFrame.reset:Hide()

ColorPickerFrame:HookScript('OnShow', function(self)
    ns.colour[1] = MODUI_VAR['theme'].r
    ns.colour[2] = MODUI_VAR['theme'].g
    ns.colour[3] = MODUI_VAR['theme'].b
    ns.colour_bu[1] = MODUI_VAR['theme_bu'].r
    ns.colour_bu[2] = MODUI_VAR['theme_bu'].g
    ns.colour_bu[3] = MODUI_VAR['theme_bu'].b
    if ColorPickerFrame.theme then
        self:SetHeight(220)
        ColorPickerFrame.reset:Show()
    end
end)

ColorPickerFrame:HookScript('OnHide', function()
    ColorPickerFrame.reset:Hide()
    ColorPickerFrame.theme  = false
    ColorPickerFrame.button = false
end)

ColorPickerFrame.reset:SetScript('OnClick', function()
    MODUI_VAR['theme'].r, MODUI_VAR['theme'].g, MODUI_VAR['theme'].b = 1, 1, 1
    ColorPickerFrame:SetColorRGB(
    MODUI_VAR['theme'].r,
    MODUI_VAR['theme'].g,
    MODUI_VAR['theme'].b
    )
    for _,  v in pairs(ns.skin) do
        if  v and v:GetObjectType() == 'Texture' and v:GetVertexColor() then
            v:SetVertexColor(
            MODUI_VAR['theme'].r,
            MODUI_VAR['theme'].g,
            MODUI_VAR['theme'].b
            )
        end
    end
end)

local icon = CreateFrame('Button', 'modcolourmenu', MainMenuBarBackpackButton)
icon:SetSize(16, 16)
icon:ClearAllPoints()
icon:SetPoint('BOTTOM', MainMenuBarBackpackButton, 'TOP', .5, 1)

local t = icon:CreateFontString(nil, 'ARTWORK')
t:SetFont(STANDARD_TEXT_FONT, 8, 'OUTLINE')
t:SetPoint('TOP', icon, -2, -4)
t:SetJustifyH'CENTER'
t:SetText'M'
t:SetTextColor(1, 1, 1)

local menu = CreateFrame('Frame', 'modoptions', UIParent, 'UIDropDownMenuTemplate')

local ColourFrameFunc = function(colour, cancel)
    if  colour then
        if  cancel then
            MODUI_VAR['theme'].r = ns.colour_bu[1]
            MODUI_VAR['theme'].g = ns.colour_bu[2]
            MODUI_VAR['theme'].b = ns.colour_bu[3]
        else
            MODUI_VAR['theme'].r = colour[1]
            MODUI_VAR['theme'].g = colour[2]
            MODUI_VAR['theme'].b = colour[3]
        end
    else
        MODUI_VAR['theme'].r, MODUI_VAR['theme'].g, MODUI_VAR['theme'].b = ColorPickerFrame:GetColorRGB()
    end
    UpdateSkins()
end

local list = {
    {
        text            = 'modui',
        isTitle         = true,
        notCheckable    = true,
        fontObject      = Game13Font,
    },
    {
        text = 'UI Colour',
        icon = 'Interface\\ICONS\\inv_misc_gem_variety_02',
        func = function()
            ColorPickerFrame:SetColorRGB(
            MODUI_VAR['theme'].r,
            MODUI_VAR['theme'].g,
            MODUI_VAR['theme'].b
            )
            ColorPickerFrame.hasOpacity = false
            ColorPickerFrame.func = function(colour, cancel)
                ColourFrameFunc(colour, cancel, false)
            end
            ColorPickerFrame:Show()
            ColorPickerFrame:SetPoint'CENTER'
        end,
        notCheckable = true,
        fontObject = Game13Font,
    },
    {
        text = 'Toggle Elements',
        icon = 'Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle',
        func = function()
            _G['modui_elementsmenu']:Show()
        end,
        notCheckable = true,
        fontObject = Game13Font,
    }
}

local OnClick = function()
    if  DropDownList1:IsShown() then
        DropDownList1:Hide()
    else
        EasyMenu(list, menu, icon, 3, 111, 'MENU', 5)
    end
end

icon:SetScript('OnClick', OnClick)

SLASH_MODUI1 = '/modui'
SlashCmdList.MODUI = OnClick

local OnShow = function(self)
    for _, v in pairs(
        {
            _G[self:GetName()..'Corner'],
            _G[self:GetName()..'Decoration']
        }
        ) do
        v:SetVertexColor(
        ns.colour[1], ns.colour[2], ns.colour[3]
        )
    end
    self:SetBackdropBorderColor(
    ns.colour[1], ns.colour[2], ns.colour[3]
    )
end

local OnEvent = function(self, event, addon)
    if  event == 'ADDON_LOADED' then
        ADDON_LOADED(self, event, addon)
    end
    if event == 'PLAYER_ENTERING_WORLD' then
        if  not MODUI_VAR['theme'] then
            MODUI_VAR['theme'] = {r = 0, g = 0, b = 0}
        end

        if 	not MODUI_VAR['theme_bu'] then
            MODUI_VAR['theme_bu'] = {r = .9, g = .9, b = .9}
        end
        UpdateSkins()
    end
end

hooksecurefunc('GroupLootFrame_OnShow', OnShow)

UIWidgetTopCenterContainerFrame:ClearAllPoints() 
UIWidgetTopCenterContainerFrame:SetPoint("TOP", 0, -40)

local e = CreateFrame'Frame'
e:RegisterEvent'VARIABLES_LOADED'
e:RegisterEvent'ADDON_LOADED'
e:RegisterEvent'PLAYER_ENTERING_WORLD'
e:SetScript('OnEvent', OnEvent)

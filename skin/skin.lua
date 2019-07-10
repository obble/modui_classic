

    local _, ns = ...

    local f = CreateFrame'Frame'
    local build = tonumber(string.sub(GetBuildInfo() , 1, 2))

    ns.colour = {1, 1, 1, 1}
    ns.skin = {
        MinimapBorder,
        MiniMapTrackingBorder,
        MiniMapMailBorder,
        MiniMapBattlefieldBorder,

        PlayerFrameTexture,
        TargetFrameTextureFrameTexture,
        PetFrameTexture,
        PartyMemberFrame1Texture,
        PartyMemberFrame2Texture,
        PartyMemberFrame3Texture,
        PartyMemberFrame4Texture,
        PartyMemberFrame1PetFrameTexture,
        PartyMemberFrame2PetFrameTexture,
        PartyMemberFrame3PetFrameTexture,
        PartyMemberFrame4PetFrameTexture,

        CastingBarBorder,

        _G['TargetFrameToTTextureFrameTexture'],
    }

    -- 8.0?
    if  build > 1 then
        for _, v in pairs(
            {
                MainMenuBarArtFrameBackground.BackgroundLarge,
                MainMenuBarArtFrameBackground.BackgroundSmall,
                MainMenuBarArtFrame.LeftEndCap,
                MainMenuBarArtFrame.RightEndCap,
                MicroButtonAndBagsBar.MicroBagBar,
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

    for i = 1, 12 do
        local _, a = _G['ContainerFrame'..i]:GetRegions()
        tinsert(ns.skin, a)
    end

    local _, a, b, c, d = ItemTextFrame:GetRegions()
    for _, v in pairs({a, b, c, d}) do
        tinsert(ns.skin, v)
    end

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

    local _, a = LootFrame:GetRegions()
    tinsert(ns.skin, a)

    if  LFGParentFrame then
        local _, a = LFGParentFrame:GetRegions()
        for _, v in pairs({a}) do tinsert(ns.skin, v) end
    end

    local _, a, b, c, d, _, _, _, e, f, g, h, j, k = MerchantFrame:GetRegions()
    for _, v in pairs({a, b, c ,d, e, f, g, h, j, k}) do
        tinsert(ns.skin, v)
    end

    tinsert(ns.skin, MerchantBuyBackItemNameFrame)

    local _, a, b, c, d = OpenMailFrame:GetRegions()
   for _, v in pairs({a, b, c, d}) do
       tinsert(ns.skin, v)
   end

   local _, a, b, c, d = MailFrame:GetRegions()
   for _, v in pairs({a, b, c, d}) do
       tinsert(ns.skin, v)
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

    local _, a, b, c, d = FriendsFrame:GetRegions()
    for _, v in pairs({a, b, c, d}) do
        tinsert(ns.skin, v)
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

    --todo: borders

    -- in classic?
    --[[
    for _, v in pairs(
        {
        QuestFrameGreetingPanel,
        QuestFrameDetailPanel,
        QuestFrameProgressPanel,
        QuestFrameRewardPanel,
        GossipFrameGreetingPanel
        }
    ) do
        for _,  j in pairs({v:GetRegions()}) do
            -- print(j:GetName(), j:GetObjectType(), j:GetDrawLayer())
            if  j:GetObjectType() == 'Texture' and j:GetDrawLayer() == 'BACKGROUND' then
                tinsert(ns.skin, v)
            end
        end
    end
    ]]

    -- initialise
    for _,  v in pairs(ns.skin) do
        if  v and v:GetObjectType() == 'Texture' and v:GetVertexColor() then
            v:SetVertexColor(
                ns.colour[1],
                ns.colour[2],
                ns.colour[3]
            )
        end
    end

    -- colour picker
    local ColourPicker = function(r, g, b, a, callback)
        ColorPickerFrame:SetColorRGB(r, g, b)
        ColorPickerFrame.hasOpacity = false
        ColorPickerFrame.func = callback
        ColorPickerFrame:Hide()
        ColorPickerFrame.modui = true
        ColorPickerFrame:Show()
        ColorPickerFrame:SetPoint'CENTER'
    end

    --[[f.recolourTexture = function(colour, cancel)
        if  colour then
            if  cancel then
                ns.colour[1], ns.colour[2], ns.colour[3] = 0, 0, 0
            else
                ns.colour[1], ns.colour[2], ns.colour[3] = colour[1], colour[2], colour[3] -- ?
            end
        else
            ns.colour[1], ns.colour[2], ns.colour[3] = ColorPickerFrame:GetColorRGB()
        end
        for _,  v in pairs(ns.skin) do
            if  v and v:GetObjectType() == 'Texture' and v:GetVertexColor() then
                v:SetVertexColor(
                    ns.colour[1],
                    ns.colour[2],
                    ns.colour[3]
                )
            end
        end
    end ]]

    ColorPickerFrame.reset = CreateFrame('Button', 'ColorPickerFrameReset', ColorPickerFrame, 'GameMenuButtonTemplate')
    ColorPickerFrame.reset:SetSize(144, 24)
    ColorPickerFrame.reset:SetText'Reset to Default'
    ColorPickerFrame.reset:SetPoint('BOTTOMLEFT', ColorPickerOkayButton, 0, 22)
    ColorPickerFrame.reset:Hide()

    ColorPickerFrame:SetScript('OnShow', function(self)
        if  self.hasOpacity then
            OpacitySliderFrame:Show()
            OpacitySliderFrame:SetValue(self.opacity)
            self:SetWidth(365)
        else
            OpacitySliderFrame:Hide()
            self:SetWidth(305)
            end
        if ColorPickerFrame.modui then
            self:SetHeight(220)
            ColorPickerFrame.reset:Show()
        end
    end)

    ColorPickerFrame:SetScript('OnHide', function()
        ColorPickerFrame.reset:Hide()
        ColorPickerFrame.modui = false
    end)

    ColorPickerFrame.reset:SetScript('OnClick', function()
        ns.colour[1], ns.colour[2], ns.colour[3] = 0, 0, 0
        ColorPickerFrame:SetColorRGB(
            ns.colour[1],
            ns.colour[2],
            ns.colour[3]
        )
        for _,  v in pairs(ns.skin) do
            if  v and v:GetObjectType() == 'Texture' and v:GetVertexColor() then
                v:SetVertexColor(
                    ns.colour[1],
                    ns.colour[2],
                    ns.colour[3]
                )
            end
        end
    end)

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
               ColourPicker(
                   ns.colour[1],
                   ns.colour[2],
                   ns.colour[3],
                   ns.colour[4],
                   f.recolourTexture
               )
           end,
           notCheckable = true,
           fontObject = Game13Font,
       },
       {
           text = 'Toggle Elements',
           icon = 'Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle',
           func = function()
           end,
           notCheckable = true,
           fontObject = Game13Font,
       }
    }

    local icon = CreateFrame('Button', 'modcolourmenu', MainMenuBarBackpackButton)
    icon:SetSize(16, 16)
    icon:ClearAllPoints()
    icon:SetPoint('BOTTOM', MainMenuBarBackpackButton, 'TOP', .5, 1)

    local t = icon:CreateFontString(nil, 'ARTWORK')
    t:SetFont(STANDARD_TEXT_FONT, 36, 'OUTLINE')
    t:SetPoint('CENTER', icon, .5, .5)
    t:SetText'·'
    t:SetTextColor(1, 1, 1)

    local menu = CreateFrame('Frame', 'modoptions', UIParent, 'UIDropDownMenuTemplate')

    icon:SetScript('OnClick', function()
        if  DropDownList1:IsShown() then
            DropDownList1:Hide()
        else
            EasyMenu(list, menu, icon, 3, 111, 'MENU', 5)
        end
    end)

    --

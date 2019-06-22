

    local _, addon = ...

    addon.colour = {1, 1, 1, 1}
    addon.skin = {
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

        -- 8.0?
        MainMenuBarArtFrameBackground.BackgroundLarge,
        MainMenuBarArtFrameBackground.BackgroundSmall,
        MainMenuBarArtFrame.LeftEndCap,
        MainMenuBarArtFrame.RightEndCap,
        MicroButtonAndBagsBar.MicroBagBar,

        -- in classic?
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

        _G['TargetFrameToTTextureFrameTexture'],
    }

    for i = 1, 12 do
        local _, a = _G['ContainerFrame'..i]:GetRegions()
        tinsert(addon.skin, a)
    end

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
                tinsert(addon.skin, v)
            end
        end
    end
    ]]

    -- initialise
    for _,  v in pairs(addon.skin) do
        if  v and v:GetObjectType() == 'Texture' and v:GetVertexColor() then
            v:SetVertexColor(
                addon.colour[1],
                addon.colour[2],
                addon.colour[3]
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

    local f = CreateFrame'Frame'
    f.recolourTexture = function(colour, cancel)
        if  colour then
            if  cancel then
                addon.colour[1], addon.colour[2], addon.colour[3] = 0, 0, 0
            else
                addon.colour[1], addon.colour[2], addon.colour[3] = colour[1], colour[2], colour[3] -- ?
            end
        else
            addon.colour[1], addon.colour[2], addon.colour[3] = ColorPickerFrame:GetColorRGB()
        end
        for _,  v in pairs(addon.skin) do
            if  v and v:GetObjectType() == 'Texture' and v:GetVertexColor() then
                v:SetVertexColor(
                    addon.colour[1],
                    addon.colour[2],
                    addon.colour[3]
                )
            end
        end
    end

    ColorPickerFrame.reset = CreateFrame('Button', 'ColorPickerFrameReset', ColorPickerFrame, 'GameMenuButtonTemplate')
    ColorPickerFrame.reset:SetSize(144, 24)
    ColorPickerFrame.reset:SetText'Reset to Default'
    ColorPickerFrame.reset:SetPoint('BOTTOMLEFT', ColorPickerOkayButton, 0, 22)
    ColorPickerFrame.reset:Hide()

    local icon = CreateFrame('Button', 'modcolourmenu', MainMenuBarBackpackButton)
    icon:SetSize(16, 16)
    icon:ClearAllPoints()
    icon:SetPoint('BOTTOM', MainMenuBarBackpackButton, 'TOP', .5, 1)

    local t = icon:CreateFontString(nil, 'ARTWORK')
    t:SetFont(STANDARD_TEXT_FONT, 36, 'OUTLINE')
    t:SetPoint('CENTER', icon, .5, .5)
    t:SetText'·'
    t:SetTextColor(1, 1, 1)

    icon:SetScript('OnClick', function()
        ColourPicker(
            addon.colour[1],
            addon.colour[2],
            addon.colour[3],
            addon.colour[4],
            f.recolourTexture
        )
    end)

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
        addon.colour[1], addon.colour[2], addon.colour[3] = 0, 0, 0
        ColorPickerFrame:SetColorRGB(
            addon.colour[1],
            addon.colour[2],
            addon.colour[3]
        )
        for _,  v in pairs(addon.skin) do
            if  v and v:GetObjectType() == 'Texture' and v:GetVertexColor() then
                v:SetVertexColor(
                    addon.colour[1],
                    addon.colour[2],
                    addon.colour[3]
                )
            end
        end
    end)

    --

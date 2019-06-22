

    local _, ns = ...

    local _, class = UnitClass'player'
    local build = tonumber(string.sub(GetBuildInfo() , 1, 2))

    local CLASS_ICON_TCOORDS = {
        ['WARRIOR']		= {0, .25, .025, .225},
        ['MAGE']		= {.26, .5, .025, .225},
        ['ROGUE']		= {.49609375, 0.7421875, .025, .225},
        ['DRUID']		= {.7421875, 0.98828125, .025, .225},
        ['HUNTER']		= {.01, .249, .275, .475},
        ['SHAMAN']	 	= {.25, .49609375, .275, .475},
        ['PRIEST']		= {.497, .741, .275, .475},
        ['WARLOCK']		= {.7421875, .98828125, .275, .475},
        ['PALADIN']		= {0, .25, .525, .725},
    }

    local buttons = {
       ['CharacterMicroButton']    = {{-12, 10}, {-12, 10}},
       ['SpellbookMicroButton']    = {{ 12, 10}, { 12, 10}},
       ['TalentMicroButton']       = {{-12, 40}, {-12, 40}},
       ['QuestLogMicroButton']     = {{-12, 40}, { 12, 40}},
       ['SocialsMicroButton']      = {{ 12, 40}, {-12, 70}},
       ['LFGMicroButton']          = {{-12, 70}, { 12, 70}},
       ['MainMenuMicroButton']     = {{ 12, 70}, {-12, 100}},
       ['HelpMicroButton']         = {{-12, 100}, {12, 100}},
   }

   local BFAbuttons = {
       ['CharacterMicroButton']         = {{-12, 10}, {-12, 10}},
       ['SpellbookMicroButton']         = {{ 12, 10}, { 12, 10}},
       ['TalentMicroButton']            = {{-12, 45}, {-12, 45}},
       ['AchievementMicroButton']       = {{-12, 45}, { 12, 45}},
       ['QuestLogMicroButton']          = {{ 12, 45}, {-12, 80}},
       ['GuildMicroButton']             = {{-12, 80}, { 12, 80}},
       ['LFDMicroButton']               = {{ 12, 80}, {-12, 115}},
       ['CollectionsMicroButton']       = {{-12, 115}, {12, 115}},
       ['EJMicroButton']                = {{-12, 150}, {-12, 150}},
       ['MainMenuMicroButton']          = {{-12, 150}, {12, 150}},
   }

   local menu = CreateFrame('Button', 'moduimenuButton', _G['modui_endcaps'])
   menu:SetPoint('CENTER', MainMenuBarArtFrame.LeftEndCap, 10, -5)
   menu:SetSize(21, 21)
   --menu:GetNormalTexture():SetTexture''
   ns.BUElements(menu)
   menu:RegisterForClicks'AnyUp'

   menu.t = menu:CreateTexture(nil, 'ARTWORK')
   menu.t:SetTexture[[Interface\GLUES\CHARACTERCREATE\UI-CHARACTERCREATE-CLASSES]]
   menu.t:SetTexCoord(unpack(CLASS_ICON_TCOORDS[class]))
   menu.t:SetPoint'TOPLEFT'
   menu.t:SetPoint('BOTTOMRIGHT', 0, 5)

   menu.arrow = menu:CreateTexture(nil, 'OVERLAY')
   menu.arrow:SetTexture[[Interface\MoneyFrame\Arrow-Right-Up]]
   menu.arrow:SetSize(16, 16)
   menu.arrow:SetTexCoord(1, 0, 0, 0, 1, 1, 0, 1)
   menu.arrow:SetPoint('BOTTOM', menu, 'TOP', 2, 3)

   menu.mouseover = CreateFrame('Button', nil, menu)
   menu.mouseover:SetWidth(60)
   menu.mouseover:SetHeight(300)
   menu.mouseover:SetPoint('BOTTOM', menu, 'TOP')
   menu.mouseover:SetFrameLevel(10)

   menu.sb = CreateFrame('StatusBar', nil, menu)
   menu.sb:SetStatusBarTexture[[Interface\AddOns\ladyui\art\statusbar.tga]]
   menu.sb:SetSize(22, 3)
   menu.sb:SetPoint('TOP', menu, 'BOTTOM', 1, -5)
   menu.sb:SetStatusBarColor(0, 1, 0)
   menu.sb:SetBackdrop(
       {bgFile = [[Interface\Buttons\WHITE8x8]],
       insets = {
          left     =  -1,
          right    =  -1,
          top      =  -1,
          bottom   =  -1,
           }
       }
   )
   menu.sb:SetBackdropColor(0, 0, 0)
   menu.sb.updateInterval = 0

   local mask = menu:CreateMaskTexture()
   mask:SetTexture[[Interface\Minimap\UI-Minimap-Background]]
   mask:SetPoint('TOPLEFT', -3, 3)
   mask:SetPoint('BOTTOMRIGHT', 3, -3)

   menu.t:AddMaskTexture(mask)

   if  not menu.bo then
       menu.bo = menu:CreateTexture(nil, 'OVERLAY')
       menu.bo:SetSize(36, 36)
       menu.bo:SetTexture[[Interface\Artifacts\Artifacts]]
       menu.bo:SetPoint'CENTER'
       menu.bo:SetTexCoord(.25, .34, .86, .9475)
       menu.bo:SetVertexColor(.7, .7, .7)
   end

   -- only necessary if we end up resizing buttons
   --[[MicroButtonPortrait:SetWidth(14)
   MicroButtonPortrait:SetHeight(21)
   MicroButtonPortrait:SetPoint('TOP', 0, -22)]]

   --[[KeyRingButton:SetParent(ContainerFrame1)
   KeyRingButton:ClearAllPoints()
   KeyRingButton:SetPoint('TOPLEFT', ContainerFrame1, -25, -2)]]

   -- UpdateTalentButton = function() end ??

   local ShowMenu = function()
       menu.arrow:SetPoint('BOTTOM', menu, 'TOP', 2, 6)
       for i, v in pairs(build < 2 and buttons or BFAbuttons) do
           local bu = _G[i]
           if  bu then -- 8.0 buffer
               bu:SetAlpha(1)
               bu:EnableMouse(true)
           end
       end
   end

   local HideMenu = function()
       GameTooltip:Hide()
       menu.arrow:SetPoint('BOTTOM', menu, 'TOP', 2, 3)
       for i, v in pairs(build < 2 and buttons or BFAbuttons) do
           local bu = _G[i]
           if  bu then -- 8.0 buffer
               bu:SetAlpha(0)
               bu:EnableMouse(false)
           end
       end
   end

   local AddMenu = function()
       local l = UnitLevel'player'
       local frames = {

       }
       for i, v in pairs(build < 2 and buttons or BFAbuttons) do
           local bu = _G[i]
           if  bu then
               bu:ClearAllPoints()
               bu:SetPoint('BOTTOM', menu, 'TOP', l < 10 and v[1][1] or v[2][1], l < 10 and v[1][2] or v[2][2])
               bu:SetAlpha(0)
               bu:EnableMouse(false)
               bu:SetFrameLevel(11)

               bu:HookScript('OnEnter', ShowMenu)
               bu:HookScript('OnLeave', HideMenu)
           end
       end
       for _, f in pairs(
            {
                MainMenuBarPerformanceBar,
                StoreMicroButton
            }
       ) do
           if  f then
               f:Hide()
           end
       end
   end

   local AddAlerts = function()
       local focus = GetMouseFocus()
       ShowMenu()
       if  not menu.timer then
           menu.timer = true
           C_Timer.After(5, function()
               menu.timer = false
               if  focus == menu or focus == menu.mouseover or str.find(focus:GetName(), build < 2 and buttons or BFAbuttons) then
                   return
               else
                   HideMenu()
               end
           end)
       end
   end


   menu:SetScript('OnEnter', function()
       ShowMenu()
       GameTooltip:ClearLines()
       GameTooltip:SetOwner(menu, 'ANCHOR_LEFT', -25, 12)
       GameTooltip:AddLine(MAINMENU_BUTTON)

       GameTooltip:AddLine' '

       -- latency
       local _, _, latency = GetNetStats()
       --[[local string = format(MAINMENUBAR_LATENCY_LABEL, latency)
       GameTooltip:AddLine(string, 1, 1, 1)
       if  SHOW_NEWBIE_TIPS == '1' then
           GameTooltip:AddLine(NEWBIE_TOOLTIP_LATENCY, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
       end

       GameTooltip:AddLine'\n'

       -- fps
       local string = format(MAINMENUBAR_FPS_LABEL, GetFramerate())
       GameTooltip:AddLine(string, 1, 1, 1)
       if  SHOW_NEWBIE_TIPS == '1' then
           GameTooltip:AddLine(NEWBIE_TOOLTIP_FRAMERATE, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
       end]]

       GameTooltip:Show()
   end)
   menu:SetScript('OnLeave',      HideMenu)
   menu.mouseover:SetScript('OnEnter', ShowMenu)
   menu.mouseover:SetScript('OnLeave', HideMenu)

   menu:SetScript('OnClick', function()
       ToggleCharacter'PaperDollFrame'
   end)

   menu.sb:SetScript('OnUpdate', function(self, elapsed)
       if  self.updateInterval > 0 then
           self.updateInterval = self.updateInterval - elapsed
       else
           self.updateInterval = PERFORMANCEBAR_UPDATE_INTERVAL
           local _, _, latency = GetNetStats()
           if  latency > PERFORMANCEBAR_MEDIUM_LATENCY then
               menu.sb:SetStatusBarColor(1, 0, 0)
           elseif latency > PERFORMANCEBAR_LOW_LATENCY then
               menu.sb:SetStatusBarColor(1, 1, 0)
           else
               menu.sb:SetStatusBarColor(0, 1, 0)
           end
       end
   end)

   local e = CreateFrame'Frame'
   e:RegisterEvent'PLAYER_LOGIN'
   e:RegisterEvent'PLAYER_LEVEL_UP'
   e:SetScript('OnEvent', AddMenu)

   hooksecurefunc('UpdateMicroButtons', AddMenu)
   -- hooksecurefunc('MainMenuMicroButton_ShowAlert', AddAlerts)

    --

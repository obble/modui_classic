

    local _, ns = ...

    local _, class  = UnitClass'player'
    local active

    local buttons   = {
        ['DRUID']   = {},
        ['HUNTER']  = {},
        ['MAGE']    = {
            ['Winters Chill']    = {
                ['Tab1'] = {        --  arcane
                    1, 2, 5, 6, 7, 12
                },
                ['Tab2'] = {},      --  fire
                ['Tab3'] = {        --  frost
                    2, 3, 4, 7, 8, 10, 11, 12, 14, 16, 17
                },
            },
            ['Arcane Frost']    = {
                ['Tab1'] = {        --  arcane
                    1, 2, 4, 5, 6, 9, 11, 12, 13, 14, 15, 16
                },
                ['Tab2'] = {},      --  fire
                ['Tab3'] = {        --  frost
                    2, 3, 4, 8, 11, 12
                },
            },
            ['PvP Frost']       = { --  http://db.vanillagaming.org/?talent#obhVrobZZVVGuRbtho
                ['Tab1'] = {        --  frost
                    1, 3, 6, 7, 8, 9, 11
                },
                ['Tab2'] = {},      --  fire
                ['Tab3'] = {        --  frost
                    2, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 17
                },
            },
        },
        ['PALADIN'] = {},
        ['PRIEST']  = {},
        ['ROGUE']   = {},
        ['SHAMAN']  = {},
        ['WARLOCK'] = {},
        ['WARRIOR'] = {},
    }

    local OnClick = function(self, bu, t)
       local n = self:GetText()
       local i = PanelTemplates_GetSelectedTab(PlayerTalentFrame)
       local j = buttons[class][n]['Tab'..i]

       --  show relative talent frames
       for k, v in pairs(j) do
           if  bu[v]:IsShown() then
               bu[v]:Hide()
               AutoCastShine_AutoCastStop(bu[v])
               active = nil
           else
               bu[v]:Show()
               AutoCastShine_AutoCastStart(bu[v], 1, 1, 0)
               active = n
           end
       end
   end

    local TabOnClick = function(self)
        if not active then return end
        local j = buttons[class][active]['Tab'..gsub(self:GetName(), 'TalentFrameTab', '')]

        for i = 1, 20 do
            local bu = _G['TalentFrameTalent'..i..'sparkle']
            bu:Hide()
        end

        for k, v in pairs(j) do
            local bu = _G['TalentFrameTalent'..v..'sparkle']
            bu:Show()
        end
    end

    local AddCookieCutters = function()
        local bu    = {}
        local j     = buttons[class]
        local x     = 1

        for i = 1, 20 do
            local talent = _G['TalentFrameTalent'..i]

            bu[i] = CreateFrame('Button', 'TalentFrameTalent'..i..'sparkle', talent, 'AutoCastShineTemplate')
    		bu[i]:RegisterForClicks'NONE'
            bu[i]:EnableMouse(false)
    		bu[i]:SetAllPoints()
            bu[i]:Hide()
        end

        for t, v in pairs(j) do
            local f = CreateFrame('Button', 'modui_sparkletogglebutton_'..t, TalentFrame, 'UIPanelButtonTemplate')
            f:SetSize(80, 20)
            f.Text:SetText(t)
            f.Text:SetFont(STANDARD_TEXT_FONT, 10)
            f:SetPoint('BOTTOMLEFT', TalentFrame, x == 1 and 30 or x == 2 and 127 or 230, 106)
            f:SetScript('OnClick', function(self)
                OnClick(self, bu, t)
            end)
            x = x + 1
        end
    end

    local OnEvent = function(self, event, addon)
        if addon == 'Blizzard_TalentUI' then
            if not MODUI_VAR['elements']['talentbuilds'].enable then
                return
            end
            AddCookieCutters()
            hooksecurefunc('TalentFrameTab_OnClick', TabOnClick)
        end
    end

    local e = CreateFrame'Frame'
    e:RegisterEvent'ADDON_LOADED'
    e:SetScript('OnEvent', OnEvent)

    --

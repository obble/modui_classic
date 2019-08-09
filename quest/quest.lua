

    local _, ns = ...

    local f = {}

    local OnMouseUp = function(self)
    	if  IsShiftKeyDown() then
    		local qID = GetQuestIDFromLogIndex(self.qID)
    		for i, v in ipairs(QUEST_WATCH_LIST) do
    			if v.id == qID then
    				tremove(QUEST_WATCH_LIST, i)
    			end
    		end
    		RemoveQuestWatch(self.qID)
    		QuestWatch_Update()
    	else
    		ShowUIPanel(QuestLogFrame)
    		QuestLog_SetSelection(self.qID)
    	end
    	QuestLog_Update()
    end

    local function SetHighlightColor(self)
    	self.header:SetTextColor(1, .8, 0)
    	for _, t in ipairs(self.objective) do
    		t:SetTextColor(1, 1, 1)
    	end
    end

    local function SetNormalColor(self)
    	self.header:SetTextColor(.75, .61, 0)
    	for _, t in ipairs(self.objective) do
    		t:SetTextColor(.8, .8, .8)
    	end
    end

    local function OnEnter(self)
    	if  not self.completed then
    		SetHighlightColor(self)
    	end
    end

    local function OnLeave(self)
    	SetNormalColor(self)
    end

    local CreateClickFrame = function(watchID, qID, header, objective, completed)
    	if  not f[watchID] then
    		f[watchID] = CreateFrame'Frame'
    		f[watchID]:SetScript('OnMouseUp', OnMouseUp)
    		f[watchID]:SetScript('OnEnter', OnEnter)
    		f[watchID]:SetScript('OnLeave', OnLeave)
    	end
    	local frame = f[watchID]
    	frame:SetAllPoints(header)
    	frame.watchID      = watchID
    	frame.qID          = qID
    	frame.header       = header
    	frame.objective    = objective
    	frame.completed    = completed
    end

    local Update = function()
        local watchID = 1
        for i = 1, GetNumQuestWatches() do
        	local qID = GetQuestIndexForWatch(i)
        	if  qID then
        		local n = GetNumQuestLeaderBoards(qID)
        		if  n > 0 then
        			local header = _G['QuestWatchLine'..watchID]
        			local group = {}
        			local completed = 0

                    watchID = watchID + 1

        			for j = 1, n do
        				local _, _, finished  = GetQuestLogLeaderBoard(j, qID)
        				if  finished then
        					completed = completed + 1
        				end
        				tinsert(group, _G['QuestWatchLine'..watchID])
        				watchID = watchID + 1
        			end
        			CreateClickFrame(i, qID, header, group, completed == n)
                end
        	end
        end
        for _, v in pairs(f) do
        	v[GetQuestIndexForWatch(v.watchID) and 'Show' or 'Hide'](v)
        end
    end

    hooksecurefunc('QuestWatch_Update', Update)

    --


    --

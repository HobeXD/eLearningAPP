module(..., package.seeall)

function new(totleTime)
		local localGroup = display.newGroup()
		
local tmp = {}
tmp.stage = stageNumStage
tmp.quest = stageNumQuest + 1
if tmp.quest <= 10 then
	upstage(tmp)
else
	tmp.stage = stageNumStage
	tmp.quest = 99
	upstage(tmp)
end
local getScore
if totleTime <= 20000 then getScore = 3
elseif totleTime <= 40000 then getScore = 2
else getScore = 1
end

upScore(getScore)

local background = display.newImage("photo/"..stageNumStage.."/stage.png")
localGroup:insert(background)

background:scale(display.contentHeight / background.contentWidth, display.contentWidth / background.contentHeight)
background.x = background.contentHeight / 2
background.y = background.contentWidth / 2
background.rotation = 90

local sound = getMusic()
if sound == 1 then
	media.playEventSound( winSound )
end

local goal = display.newImage("photo/win.png")
localGroup:insert(goal)

goal:scale(display.contentHeight / goal.contentWidth, display.contentWidth / goal.contentHeight)
goal.x = goal.contentHeight / 2
goal.y = goal.contentWidth / 2
goal.rotation = 90

local star = {}

for i = 1, getScore do
	star[i] = display.newImage("photo/big star.png")
	localGroup:insert(star[i])
	star[i].rotation = 90
	star[i].x = 150
	star[i].y = 135 + i * 73
end
local function goalEvent (event)
	star.x = event.x
	star.y = event.y
	if event.phase == "ended" then
		local x = event.x
		local y = event.y
		if x >= 57 and x <= 100 and y >= 186 and y <= 229 then
			director:changeScene ("game")
		elseif x >= 57 and x <= 100 and y >= 262 and y <= 304 then
		print(tmp.quest)
			if tmp.quest == 99 then
				print("@@?")
				director:changeScene ("menu")
			else
				chstage(tmp)
				director:changeScene ("game")
			end
		elseif x >= 57 and x <= 100 and y >= 334 and y <= 377 then
			director:changeScene ("stageMenu", stageNumStage)
		end
	end
end
goal:addEventListener ("touch", goalEvent)


local endground = display.newImage("photo/end.jpg")
localGroup:insert(endground)

endground:scale(display.contentHeight / endground.contentWidth, display.contentWidth / endground.contentHeight)
endground.x = endground.contentHeight / 2
endground.y = endground.contentWidth / 2
endground.isVisible = false
endground.rotation = 90
print(stageNumStage.." "..tmp.quest)

local function endEvent (event)
	if event.phase == "ended" then
		endground.isVisible = false
	end
end

if stageNumStage == 5 and tmp.quest == 99 then
	endground.isVisible = true
	endground:addEventListener ("touch", endEvent)
end
--[[
local text = display.newText(answer, 0, 0, nil, 40)
localGroup:insert(text)
text.x = display.contentWidth * 0.5
text.y = display.contentHeight * 0.3

local botton = display.newRect( display.contentWidth * 0.35, display.contentHeight * 0.6,
								display.contentWidth * 0.3, display.contentHeight * 0.15)

localGroup:insert(botton)
botton:setFillColor(100, 128, 128)
local start = display.newText("Next", 0, 0, nil, 40)
localGroup:insert(start)
start.x = display.contentWidth * 0.5
start.y = display.contentHeight * 0.675

local function goback (event)
local tmp = {}
tmp.stage = stageNumStage
tmp.quest = stageNumQuest + 1
if event.phase == "ended" then
if tmp.quest <= 10 then
	chstage(tmp)
	director:changeScene ("game")
else
	tmp.stage = stageNumStage + 1
	tmp.quest = 1
	chstage(tmp)
	director:changeScene ("menu")
end
end
end

botton:addEventListener ("touch", goback)
--]]
		return localGroup

end
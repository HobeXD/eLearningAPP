module(..., package.seeall)


function new()
		local localGroup = display.newGroup()
		
local background = display.newImage("photo/rank.png")
localGroup:insert(background)

background:scale(display.contentWidth / background.contentWidth, display.contentHeight / background.contentHeight)
background.x = background.contentWidth / 2
background.y = background.contentHeight / 2

local goBackIcon = display.newImage("photo/back.png")
localGroup:insert(goBackIcon)
goBackIcon.x = 30
goBackIcon.y = 520

local function waitBack (event)
	director:changeScene ("start")
end

local function goBack (event)
	if event.phase == "ended" then
	local goBackIcon2 = display.newImage("photo/back01.png")
	localGroup:insert(goBackIcon2)
	goBackIcon2.x = 30
	goBackIcon2.y = 520
	timer.performWithDelay( 100, waitBack )
		--director:changeScene ("start")
	end
end
goBackIcon:addEventListener ("touch", goBack) 

local str = rankStr
local cnt = 0
local line = 1
local ranking = {}
local nameText = {}
local stageText = {}
local scoreText = {}

for word in string.gmatch(str, "[%a%d]+") do 
	if word ~= nil then
		print(word)
		ranking[cnt] = word
		cnt = cnt+1
		--print(cnt)
	end
end

for i = 0,cnt,3 do
	nameText[line] = display.newText("",0,0,nil,18)
	localGroup:insert(nameText[line])
	nameText[line]:setTextColor(0, 0, 0)
	nameText[line].text = ranking[i]
	nameText[line].x = 132
	nameText[line].y = 100 + line * 30
	stageText[line] = display.newText("",0,0,nil,18)
	localGroup:insert(stageText[line])
	stageText[line]:setTextColor(0, 0, 0)
	stageText[line].text = ranking[i+1]
	stageText[line].x = 202
	stageText[line].y = 100 + line * 30
	scoreText[line] = display.newText("",0,0,nil,18)
	localGroup:insert(scoreText[line])
	scoreText[line]:setTextColor(0, 0, 0)
	scoreText[line].text = ranking[i+2]
	scoreText[line].x = 237
	scoreText[line].y = 100 + line * 30
	line = line+1
	
	
end
		return localGroup

end
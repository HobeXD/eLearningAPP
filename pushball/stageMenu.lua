module(..., package.seeall)

function new(stage)
		local localGroup = display.newGroup()

local level --get
if maxStage > stage or maxQuest == 99 then
	level = 10
else
	level = maxQuest
end
local prechoose = 1

local background = display.newImage("photo/"..stage.."/map.png")
localGroup:insert(background)
local scalex = display.contentWidth / background.contentWidth
local scaley = display.contentHeight / background.contentHeight
background:scale(scalex, scaley)
background.x = display.contentWidth / 2
background.y = display.contentHeight / 2

local backlevel = display.newImage("photo/"..stage.."/level.png")
localGroup:insert(backlevel)

backlevel:scale(display.contentWidth / backlevel.contentWidth, display.contentHeight / backlevel.contentHeight)
backlevel.x = display.contentWidth / 2
backlevel.y = display.contentHeight / 2

local levelIcon = {}
local starIcon = {}
local choosedLevel = {}
choosedLevel.stage = stage
choosedLevel.quest = 1
chstage(choosedLevel)

local penguin1 = display.newImage("photo/01.png")
localGroup:insert(penguin1)
penguin1.width = 60
penguin1.height = 70

local penguin2 = display.newImage("photo/02.png")
localGroup:insert(penguin2)
penguin2.isVisible = false
penguin2.width = 60
penguin2.height = 70

local function stepping(event)
	penguin1.isVisible = not penguin1.isVisible
	penguin2.isVisible = not penguin1.isVisible
	tep = timer.performWithDelay( 500, stepping )
end
step = timer.performWithDelay( 500, stepping )
local function choose (event)
	if event.phase == "ended" then
		prechoose = event.target.id
		choosedLevel.stage = stage
		choosedLevel.quest = event.target.id
		chstage(choosedLevel)
		penguin1.x = levelIcon[prechoose].x
		penguin1.y = levelIcon[prechoose].y - 30
		penguin2.x = levelIcon[prechoose].x
		penguin2.y = levelIcon[prechoose].y - 30
	end
end

local goBackIcon = display.newImage("photo/back.png")
localGroup:insert(goBackIcon)
goBackIcon.x = 30
goBackIcon.y = 520

local function waitBack (event)
	director:changeScene ("menu")
end

local tmptimer

local function goBack (event)
	if event.phase == "ended" then
	local goBackIcon2 = display.newImage("photo/back01.png")
	localGroup:insert(goBackIcon2)
	goBackIcon2.x = 30
	goBackIcon2.y = 520
	tmptimer = timer.performWithDelay( 100, waitBack )
	end
end
goBackIcon:addEventListener ("touch", goBack)

local playIcon = display.newImage("photo/startgame.png")
localGroup:insert(playIcon)
playIcon.x = 80
playIcon.y = 520

local function waitPlay (event)
	director:changeScene ("game")
	--director:changeScene ("win", 0)
end

local function play (event)
	if event.phase == "ended" then
	local playIcon2 = display.newImage("photo/startgame01.png")
	localGroup:insert(playIcon2)
	playIcon2.x = 80
	playIcon2.y = 520
	tmptimer = timer.performWithDelay( 100, waitPlay )
	end
end
playIcon:addEventListener ("touch", play)

for i = 1, level do
	levelIcon[i] = display.newImage("photo/"..stage.."/ok.png")
	localGroup:insert(levelIcon[i])
	--levelIcon[i]:scale(scalex, scaley)
	levelIcon[i].width = 53
	levelIcon[i].height = 30
	levelIcon[i].id = i
	levelIcon[i]:addEventListener ("touch", choose)
	if stage == 1 then
		if		i == 1  then levelIcon[i].x = 81 levelIcon[i].y = 90
		elseif	i == 2  then levelIcon[i].x = 36 levelIcon[i].y = 169
		elseif	i == 3  then levelIcon[i].x = 137 levelIcon[i].y = 127
		elseif	i == 4  then levelIcon[i].x = 173 levelIcon[i].y = 198
		elseif	i == 5  then levelIcon[i].x = 66 levelIcon[i].y = 240
		elseif	i == 6  then levelIcon[i].x = 125 levelIcon[i].y = 314
		elseif	i == 7  then levelIcon[i].x = 176 levelIcon[i].y = 368
		elseif	i == 8  then levelIcon[i].x = 198 levelIcon[i].y = 443
		elseif	i == 9  then levelIcon[i].x = 282 levelIcon[i].y = 428
		elseif	i == 10 then levelIcon[i].x = 252 levelIcon[i].y = 508
		end
	elseif stage == 2 then
		if		i == 1  then levelIcon[i].x = 264 levelIcon[i].y = 140
		elseif	i == 2  then levelIcon[i].x = 200 levelIcon[i].y = 207
		elseif	i == 3  then levelIcon[i].x = 164 levelIcon[i].y = 268
		elseif	i == 4  then levelIcon[i].x = 68 levelIcon[i].y = 300
		elseif	i == 5  then levelIcon[i].x = 94 levelIcon[i].y = 413
		elseif	i == 6  then levelIcon[i].x = 46 levelIcon[i].y = 481
		elseif	i == 7  then levelIcon[i].x = 184 levelIcon[i].y = 392
		elseif	i == 8  then levelIcon[i].x = 197 levelIcon[i].y = 482
		elseif	i == 9  then levelIcon[i].x = 281 levelIcon[i].y = 456
		elseif	i == 10 then levelIcon[i].x = 274 levelIcon[i].y = 369
		end
	elseif stage == 3 then
		if		i == 1  then levelIcon[i].x = 60 levelIcon[i].y = 107
		elseif	i == 2  then levelIcon[i].x = 153 levelIcon[i].y = 112
		elseif	i == 3  then levelIcon[i].x = 80 levelIcon[i].y = 166
		elseif	i == 4  then levelIcon[i].x = 64 levelIcon[i].y = 240
		elseif	i == 5  then levelIcon[i].x = 168 levelIcon[i].y = 195
		elseif	i == 6  then levelIcon[i].x = 196 levelIcon[i].y = 268
		elseif	i == 7  then levelIcon[i].x = 96 levelIcon[i].y = 318
		elseif	i == 8  then levelIcon[i].x = 98 levelIcon[i].y = 413
		elseif	i == 9  then levelIcon[i].x = 174 levelIcon[i].y = 358
		elseif	i == 10 then levelIcon[i].x = 262 levelIcon[i].y = 382
		end
	elseif stage == 4 then
		if		i == 1  then levelIcon[i].x = 57 levelIcon[i].y = 100
		elseif	i == 2  then levelIcon[i].x = 149 levelIcon[i].y = 104
		elseif	i == 3  then levelIcon[i].x = 212 levelIcon[i].y = 65
		elseif	i == 4  then levelIcon[i].x = 276 levelIcon[i].y = 99
		elseif	i == 5  then levelIcon[i].x = 209 levelIcon[i].y = 165
		elseif	i == 6  then levelIcon[i].x = 148 levelIcon[i].y = 205
		elseif	i == 7  then levelIcon[i].x = 64 levelIcon[i].y = 152
		elseif	i == 8  then levelIcon[i].x = 65 levelIcon[i].y = 247
		elseif	i == 9 then levelIcon[i].x = 177 levelIcon[i].y = 287
		elseif	i == 10 then levelIcon[i].x = 137 levelIcon[i].y = 372
		end
	elseif stage == 5 then
		if		i == 1  then levelIcon[i].x = 69 levelIcon[i].y = 145
		elseif	i == 2  then levelIcon[i].x = 49 levelIcon[i].y = 208
		elseif	i == 3  then levelIcon[i].x = 87 levelIcon[i].y = 264
		elseif	i == 4  then levelIcon[i].x = 152 levelIcon[i].y = 214
		elseif	i == 5  then levelIcon[i].x = 150 levelIcon[i].y = 147
		elseif	i == 6  then levelIcon[i].x = 233 levelIcon[i].y = 211
		--elseif	i == 7  then levelIcon[i].x = 250 levelIcon[i].y = 278
		elseif	i == 7  then levelIcon[i].x = 174 levelIcon[i].y = 292
		elseif	i == 8  then levelIcon[i].x = 208 levelIcon[i].y = 352
		elseif	i == 9 then levelIcon[i].x = 202 levelIcon[i].y = 425
		elseif	i == 10 then levelIcon[i].x = 267 levelIcon[i].y = 497
		end
	end
	if score[stage * 100 + i] >= 1 then
		starIcon[i*3-3] = display.newImage("photo/star.png")
	else
		starIcon[i*3-3] = display.newImage("photo/star_X.png")
	end
	localGroup:insert(starIcon[i*3-3])
	starIcon[i*3-3].width = 15
	starIcon[i*3-3].height = 15
	starIcon[i*3-3].x = levelIcon[i].x - 15
	starIcon[i*3-3].y = levelIcon[i].y + 25
	
	if score[stage * 100 + i] >= 2 then
		starIcon[i*3-2] = display.newImage("photo/star.png")
	else
		starIcon[i*3-2] = display.newImage("photo/star_X.png")
	end
	localGroup:insert(starIcon[i*3-2])
	starIcon[i*3-2].width = 15
	starIcon[i*3-2].height = 15
	starIcon[i*3-2].x = levelIcon[i].x
	starIcon[i*3-2].y = levelIcon[i].y + 25
	
	if score[stage * 100 + i] >= 3 then
		starIcon[i*3-1] = display.newImage("photo/star.png")
	else
		starIcon[i*3-1] = display.newImage("photo/star_X.png")
	end
	localGroup:insert(starIcon[i*3-1])
	starIcon[i*3-1].width = 15
	starIcon[i*3-1].height = 15
	starIcon[i*3-1].x = levelIcon[i].x + 15
	starIcon[i*3-1].y = levelIcon[i].y + 25
	
end

local starbox = display.newImage("photo/starbox.png")
localGroup:insert(starbox)
starbox.x = 280
starbox.y = 30

--local starText = display.newText(starCnt, 0, 0, "calibri bold", 13)
local starText = display.newText(totleScore[stage], 0, 0, native.systemFont, 13)
localGroup:insert(starText)
starText.x = 263
starText.y = 30


penguin1.x = levelIcon[1].x
penguin1.y = levelIcon[1].y - 30
penguin2.x = levelIcon[1].x
penguin2.y = levelIcon[1].y - 30
penguin1:toFront()
penguin2:toFront()

		return localGroup

end
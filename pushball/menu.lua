module(..., package.seeall)

function new()
		local localGroup = display.newGroup()
		
local level = maxStage --get
local gate = {1, 1, 2, 4, 4, 4, 5, 5}
local background = {}
local lock = {}
--local globlex = 0
local nowx
local targetLevel
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


local function moveBack (event)
	penguin1.x = event.x
	penguin1.y = event.y
	penguin2.x = event.x
	penguin2.y = event.y
	if event.phase == "began" then
		nowx = event.x
	elseif event.phase == "moved" then
		local moving = 0
		if nowx - event.x + globlex < 0 then 
			moving = -globlex
			--globlex = 0
			chX(0)
			nowx = event.x
		elseif nowx - event.x + globlex > 3 * display.contentWidth then
			moving = 3 * display.contentWidth - globlex
			--globlex = 3 * display.contentWidth
			chX(3 * display.contentWidth)
			nowx = event.x
		else
			moving = nowx - event.x
			--globlex = globlex + moving
			chX(globlex + moving)
			nowx = event.x
		end
		for i = 1, 4 do
			background[i].x = (i-0.5) * display.contentWidth - math.floor(globlex)
		end
		lock[2].x = 493 - math.floor(globlex)
		lock[3].x = 510 - math.floor(globlex)
		lock[4].x = 728 - math.floor(globlex)
		lock[5].x = 1078 - math.floor(globlex)
	else 
		local totleX = globlex + event.x
		if math.abs(event.x - event.xStart) + math.abs(event.y - event.yStart)<= 10 then
			if totleX >= 5 and totleX <= 244 and event.y >= 2 and event.y <= 285 then
				targetLevel = 1
			elseif totleX >= 124 and totleX <= 341 and event.y >= 293 and event.y <= 552 then
				targetLevel = 1
			elseif totleX >= 414 and totleX <= 545 and event.y >= 82 and event.y <= 246 then
				targetLevel = 2
			elseif totleX >= 357 and totleX <= 597 and event.y >= 245 and event.y <= 512 then
				targetLevel = 3
			elseif totleX >= 553 and totleX <= 884 and event.y >= 5 and event.y <= 333 then
				targetLevel = 4
			elseif totleX >= 995 and totleX <= 1163 and event.y >= 359 and event.y <= 503 then
				targetLevel = 5
			else targetLevel = 10
			end
			if level >= targetLevel then
				director:changeScene ("stageMenu", targetLevel)
			end
		end
	end
end

for i = 1, 4 do
	local x
	if level < gate[i*2-1] then x = 0
	elseif level > gate[i*2] then x = gate[i*2]
	else x = level
	end
	background[i] = display.newImage("photo/map"..i..x..".png")
	localGroup:insert(background[i])

	background[i]:scale(display.contentWidth / background[i].contentWidth, display.contentHeight / background[i].contentHeight)
	background[i].x = (i-0.5) * display.contentWidth - math.floor(globlex)
	background[i].y = display.contentHeight / 2
	background[i]:addEventListener ("touch", moveBack)
	background[i].id = i
	
end

for i = 2, 5 do
	lock[i] = display.newImage("photo/lock"..i..".png")
	localGroup:insert(lock[i])
	if level >= i then lock[i].isVisible = false
	end
	    if i == 2 then lock[i].x = 493 lock[i].y = 204 
	elseif i == 3 then lock[i].x = 510 lock[i].y = 409
	elseif i == 4 then lock[i].x = 728 lock[i].y = 203 
	elseif i == 5 then lock[i].x = 1078 lock[i].y = 438 
	end
	
	
end

penguin1:toFront()
penguin2:toFront()

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



		return localGroup

end
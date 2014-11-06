module(..., package.seeall)

function new()
		local localGroup = display.newGroup()

local nowtime = system.getTimer()
local cnttime = 0
local maxspeed = 100;
local f = 51/50
local bf = 6/5
local w = display.contentWidth
local h = display.contentHeight
local away = h * 0.1
local objr = h * 0.07
local playerr = 10
local background = display.newImage("photo/"..stageNumStage.."/stage.png")
localGroup:insert(background)
local scalex = h / background.contentWidth
local scaley = w / background.contentHeight
background:scale(scalex, scaley)
background.x = w / 2
background.y = h / 2
background.rotation = 90

local needt = true
--set timer
local lifeBar = display.newImage("photo/lifeBar.png")
localGroup:insert(lifeBar)
lifeBar.rotation = 90
lifeBar.x = w/2
lifeBar.y = h-18

local lifeBox = display.newImage("photo/lifeBox.png")
localGroup:insert(lifeBox)
lifeBox.rotation = 90
lifeBox.x = w/2
lifeBox.y = h-18

local moveObj = {}
if stageNumStage <= 4 then
	moveObj = {display.newImage("photo/"..stageNumStage.."/move1.png"),
					 display.newImage("photo/"..stageNumStage.."/move2.png"),
					 display.newImage("photo/"..stageNumStage.."/move3.png"),
					 display.newImage("photo/"..stageNumStage.."/move4.png"),}
	for i = 1, 4 do
		localGroup:insert(moveObj[i])
		moveObj[i].alpha = 0
		moveObj[i].rotation = 90
	end
else
	moveObj = {display.newImage("photo/5/move1.png"),
					 display.newImage("photo/5/move2.png"),}
	for i = 1, 2 do
		localGroup:insert(moveObj[i])
		moveObj[i].rotation = 90
		moveObj[i].x = w / 2
		moveObj[i].y = h / 2
	end
	moveObj[2].alpha = 0
end

local moveT
local speed = {1, 1, 1, 1}
local dir = {0, 0, 0, 0}
local moveObjShowing = {0,0,0,0}
local tmp

local function moveFun1(event)
	if needt then
		for i = 1, 4 do
			if moveObj[i].alpha <= 0.01 then 
				tmp = math.random(0, 100)
				if tmp == 0 then
					moveObj[i].alpha = 0.02
					speed[i] = math.random(3, 5)
					moveObj[i].rotation = 0
					if stageNumStage == 1 then
						moveObj[i].x = math.random(0, w)
					else
						moveObj[i].x = math.random(w * 0.7, w)
					end
					moveObj[i].y = math.random(0, h)
					moveObjShowing[i] = 1
				end
			elseif moveObj[i].alpha >= 0.95 then
				moveObjShowing[i] = 0
				moveObj[i].alpha = 0.94
			end
			if moveObjShowing[i] == 1 then
				moveObj[i].alpha = moveObj[i].alpha + 0.01
			else
				if moveObj[i].alpha - 0.01 > 0 then
					moveObj[i].alpha = moveObj[i].alpha - 0.01
				end
			end
			moveObj[i].rotation = moveObj[i].rotation + speed[i]
		end
		moveT = timer.performWithDelay( 10, moveFun1 )
	end
end

local function moveFun2(event)
	if needt then
		for i = 1, 4 do
			if moveObj[i].alpha <= 0 then 
				tmp = math.random(0, 100)
				if tmp == 0 then
					moveObj[i].alpha = 0.01
					speed[i] = math.random(3, 5)
					dir[i] = math.random(-3, 3)
					if stageNumStage == 1 then
						moveObj[i].x = math.random(0, w)
					else
						moveObj[i].x = math.random(w * 0.5, w)
					end
					moveObj[i].y = math.random(0, h)
					moveObjShowing[i] = 1
				end
			elseif moveObj[i].alpha >= 0.95 then
				moveObjShowing[i] = 0
				moveObj[i].alpha = 0.94
			end
			if moveObjShowing[i] == 1 then
				moveObj[i].alpha = moveObj[i].alpha + 0.01
			else
				moveObj[i].alpha = moveObj[i].alpha - 0.01
			end
			moveObj[i].y = moveObj[i].y + dir[i] 
		end
		moveT = timer.performWithDelay( 10, moveFun2 )
	end
end

local function moveFun3(event)
	if needt then
		if moveObjShowing[1] == 0 then
			moveObj[1].alpha = moveObj[1].alpha - 0.01
			moveObj[2].alpha = 1 - moveObj[1].alpha 
			if moveObj[1].alpha <= 0 then
				moveObjShowing[1] = 1
			end
		else
			moveObj[1].alpha = moveObj[1].alpha + 0.01
			moveObj[2].alpha = 1 - moveObj[1].alpha
			if moveObj[1].alpha >= 0.95 then
				moveObjShowing[1] = 0
			end
		end
		moveT = timer.performWithDelay( 30, moveFun3 )
	end
end

if stageNumStage <= 2 then
	moveT = timer.performWithDelay( 10, moveFun1 )
elseif stageNumStage <= 4 then
	moveT = timer.performWithDelay( 10, moveFun2 )
else
	moveT = timer.performWithDelay( 10, moveFun3 )
end
--.isVisible = false


--set stage
--local stage = display.newRect( w * 0.1, h * 0.1, w * 0.8, h * 0.8 )
--localGroup:insert(stage)
--stage:setFillColor(136, 0, 21)

--require physics
local physics = require "physics"
physics.start()
physics.setGravity( 0, 0 )

--set goal
local goal = display.newImage("photo/"..stageNumStage.."/goal.png")
localGroup:insert(goal)
goal:setFillColor(255, 255, 0)
goal.x = w * 0.5
goal.y = h * 0.5
goal.rotation = 90

--set player
local player = {}
player.base = display.newImage("photo/"..stageNumStage.."/P.png")
--player.base = display.newRect( w * 0.44, h * 0.84, w * 0.1, w * 0.1 )
localGroup:insert(player.base)
--player.base:scale(scalex, scaley)
player.base.x = w * 0.3
player.base.y = h * 0.5
player.base.width = 120
player.base.height = 90
physics.addBody( player.base, "dynamic",{density=10, friction=0, bounce=0.2 ,radius=45})

--set pause
local pausing = 0
local pausebotton = display.newImage("photo/STOP.png")
localGroup:insert(pausebotton)
pausebotton.rotation = 90
pausebotton.width = 60
pausebotton.height = 60
pausebotton.x = w * 0.9
pausebotton.y = h * 0.1
local pausebotton2 = display.newImage("photo/STOP01.png")
localGroup:insert(pausebotton2)
pausebotton2.rotation = 90
pausebotton2.width = 60
pausebotton2.height = 60
pausebotton2.x = w * 0.9
pausebotton2.y = h * 0.1
pausebotton2.isVisible = false
local stopground = display.newImage("photo/stopground.png")
localGroup:insert(stopground)
stopground:scale(h / stopground.contentWidth, w / stopground.contentHeight)
stopground.x = w / 2
stopground.y = h / 2
stopground.rotation = 90
stopground.isVisible = false
local muteIcon = display.newImage("photo/big music off.png")
localGroup:insert(muteIcon)
muteIcon.x = 148
muteIcon.y = 401
muteIcon.rotation = 90
muteIcon.isVisible = false

local function pause (event)
	if event.phase == "ended"then
		if pausing == 0 then
			cnttime = cnttime + (system.getTimer() - nowtime)
			pausing = 1
			physics.pause()
			pausebotton2.isVisible = true
			stopground.isVisible = true
			local show = getMusic()
			if show == 0 then
				muteIcon.isVisible = true
			end
			stopground:toFront()
			muteIcon:toFront()
		end
	end
end
pausebotton:addEventListener ("touch", pause)

local function stopEvent (event)
	if event.phase == "ended" then
		local x = event.x
		local y = event.y
		if x >= 132 and x <= 166 and y >= 132 and y <= 176 then
			nowtime = system.getTimer()
			pausing = 0
			physics.start()
			pausebotton2.isVisible = false
			stopground.isVisible = false
			muteIcon.isVisible = false
		elseif x >= 132 and x <= 166 and y >= 217 and y <= 260 then
			director:changeScene ("game")
		elseif x >= 132 and x <= 166 and y >= 301 and y <= 345 then
			director:changeScene ("stageMenu", stageNumStage)
		elseif x >= 132 and x <= 166 and y >= 380 and y <= 422 then
			chMusic()
			muteIcon.isVisible = not muteIcon.isVisible
		end
	end
end
stopground:addEventListener ("touch", stopEvent)

--set obj

local obj = {}
local word = {}
local wordbackGround = {}
local questnum
--local questbackGround = display.newRect(0, 0, h * 0.25, h * 0.05)
--localGroup:insert(questbackGround)
local quest = display.newText("", 0, 0, native.systemFontBold, 18)
localGroup:insert(quest)
quest:setTextColor(255, 255, 255)
quest.x = w * 0.5
quest.y = h * 0.5
quest.rotation = 90
local leftcnt
local answer = ""
local totleAns

local function ObjRemove(x)
	obj[x]:removeSelf()
	word[x]:removeSelf()
	wordbackGround[x]:removeSelf()
	table.remove(obj, x)
	table.remove(word, x)
	table.remove(wordbackGround, x)
end

local function disObj()
	questnum = stageNumStage * 100 + stageNumQuest
	quest.text = quests[questnum][3]
	local totle = (quests[questnum][1]) + (quests[questnum][2])
	totleAns = quests[questnum][1]
	for i = 1, totle do
		--display.newCircle( math.random(w * 0.15, w * 0.75) - w * 0.5, math.random(h * 0.15, h * 0.75), objr )
		obj[i] = display.newImage("photo/"..stageNumStage.."/1.png")
		--obj[i].width = 80
		--obj[i].height = 70
		localGroup:insert(obj[i])
		physics.addBody(obj[i], "dynamic", {density=0, friction=0, bounce=0.2 })
		local sidex = math.random(0, 1)
		local sidey = math.random(0, 1)
		if sidex == 0 then obj[i].x = math.random(w * 0.15, w * 0.3) 
		else obj[i].x = math.random(w * 0.6, w * 0.75)end
		if sidey == 0 then obj[i].y = math.random(h * 0.15, h * 0.3) 
		else obj[i].y = math.random(h * 0.6, h * 0.75)end
		obj[i].id = i
		word[i] = display.newText("", 0, 0, native.systemFont, 18)
		localGroup:insert(word[i])
		word[i]:setTextColor(0, 0, 0)		
		word[i].rotation = 90
		word[i].text = quests[questnum][3+i]
		if i <= totleAns then
			answer = answer..word[i].text.." "..quest.text.."\n"
			obj[i].ans = 1
		else 
			obj[i].ans = 0
		end
	end
end

disObj()

local push = 0
local movingLine = nil
local dir = 180

local function GO (event)
	print (event.phase)
	if event.phase == "began" then
		if movingLine ~= nil then
			movingLine:removeSelf()
			movingLine = nil
		end
		movingLine = display.newLine( player.base.x, player.base.y, event.x, event.y )
		localGroup:insert(movingLine)
		movingLine:setStrokeColor( 1, 0, 0 )
		movingLine.strokeWidth = 5
	elseif event.phase == "moved" then
		if movingLine ~= nil then
			movingLine:removeSelf()
			movingLine = nil
		end
		movingLine = display.newLine( player.base.x, player.base.y, event.x, event.y )
		localGroup:insert(movingLine)
		movingLine:setStrokeColor( 1, 0, 0 )
		movingLine.strokeWidth = 5
	else
		if movingLine ~= nil then
			movingLine:removeSelf()
			movingLine = nil
		end
		vx = event.x - player.base.x
		vy = event.y - player.base.y
		player.base:setLinearVelocity(vx, vy)
		dir = math.atan(vy/vx)*180/math.pi + 90
		if vx < 0 then dir = dir + 180 end
	end
end

background:addEventListener ("touch", GO)


local t
local answerBlock = display.newImage("photo/answer.png")
localGroup:insert(answerBlock)
answerBlock.x = w/2
answerBlock.width = 1
answerBlock.y = h/2
answerBlock.height = 1
answerBlock.rotation = 90



local answerWords = display.newText("", 0, 0, native.systemFontBold, 25)
localGroup:insert(answerWords)
answerWords.x = w/2
answerWords.y = h/2
answerWords.size = 1
answerWords.rotation = 90
answerWords:setTextColor(255, 255, 255)

local resumeListener = function(obj)
	nowtime = system.getTimer()
	pausing = 0
	physics.start()
	totleAns = totleAns - 1
					
					if totleAns <= 0 then
						local totleTime = system.getTimer() - nowtime + cnttime
						store(name.." win "..questnum.." "..totleTime.."\n")
						needt = false
						if quests[questnum][1] > 2 then totleTime = totleTime - 20000 end
						director:changeScene ("win", totleTime) 
					end
end

local answerListener = function(obj)
	transition.to( answerBlock, { time=2000, width = 1, height = 1} )
	transition.to( answerWords, { time=2000, size = 1, onComplete=resumeListener } )
end

local function listener(event)
	if needt == false then
		return
	end
	local vx, vy = player.base:getLinearVelocity()
	--print(player.base.rotation)
	player.base.rotation = dir + 180
	for i, v in pairs(obj) do
		if v.id > 0 then
			v.rotation = 90
			local bx, by = v:getLinearVelocity()
			v:setLinearVelocity(bx/bf, by/bf)
			--v:setLinearVelocity(0, 0)
			if v.x > w * 0.8 then v.x = w * 0.8 end
			if v.x < w * 0.2 then v.x = w * 0.2 end
			if v.y > h * 0.8-36 then v.y = h * 0.8-36 end
			if v.y < h * 0.2 then v.y = h * 0.2 end
			if v.x > w * 0.45 and v.x < w * 0.55 and v.y > h * 0.4 and v.y < h * 0.6 then
				if v.ans == 1 then 
					--pause
					cnttime = cnttime + (system.getTimer() - nowtime)
					pausing = 1
					physics.pause()
					answerWords.text = word[i].text.." "..quest.text
					transition.to( answerBlock, { time=2000, width = 259, height = 105} )
					transition.to( answerWords, { time=2000, size = 30, onComplete=answerListener } )
					--resume
					v.x = -100
					v.y = -100
					v.id = -1
					v:setLinearVelocity(0, 0)
				else
					needt = false
					store(name.." lost "..questnum.." "..(system.getTimer() - nowtime + cnttime).."\n")
					director:changeScene ("lost") 
				end
			end
		end
	end
	if player.base.x > w - playerr then player.base.x = w - playerr end
	if player.base.x < 0 + playerr then player.base.x = 0 + playerr end
	if player.base.y > h - playerr then player.base.y = h - playerr end
	if player.base.y < 0 + playerr then player.base.y = 0 + playerr end
	player.base:setLinearVelocity(vx/f, vy/f)
	--[[if push > 0 then
		vx = (vx*2 + maxspeed  * math.sin(dir / 180 * math.pi)) / 3
		vy = (vy*2 - maxspeed  * math.cos(dir / 180 * math.pi)) / 3
		player.base:setLinearVelocity(vx, vy)
		push = push-1
	else
		if pausing == 0 then
			dir = (dir + 4) % 360
			player.base:setLinearVelocity(vx/f, vy/f)
			
		end
	end--]]
	for i, v in pairs(obj) do
		local x = v.x
		local y = v.y
		word[i].x = x
		word[i].y = y
	end
	if pausing == 0 then
		local lifeTime = system.getTimer() - nowtime + cnttime
		lifeBar.x = w/2 - (lifeTime/60000)*w
		if lifeTime > 60000 then
			needt = false
			store(name.." lost "..questnum.." "..(system.getTimer() - nowtime + cnttime).."\n")
			director:changeScene ("lost") 
		end
	end
	if needt then
		t = timer.performWithDelay( 1, listener )
	end
end
t = timer.performWithDelay( 1, listener )

local hintBlock = display.newImage("photo/hint.png")
localGroup:insert(hintBlock)
hintBlock.x = w/2
hintBlock.y = -100
hintBlock.rotation = 90
transition.to( hintBlock, { time=5000, y=h+200} )



local hintWords = display.newText(hints[stageNumStage * 100 + stageNumQuest][1], 0, 0, native.systemFontBold, 25)
localGroup:insert(hintWords)
hintWords.x = w/2
hintWords.y = -100
hintWords.rotation = 90
hintWords:setTextColor(255, 255, 255)
transition.to( hintWords, { time=5000, y=h+200 } )
--]]
		return localGroup

end
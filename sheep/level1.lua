-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"
local math = require "math"
local initGroup = display.newGroup()
local sheepGroup = display.newGroup()
--local localGroup = display.newGroup()

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW , halfH= display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5
local tags = {}
local questionNum = 0
local chinese
local questionSheep

local function nextQuestion( event )
	local tmp = math.random(3)
	questionNum = math.random(vocNum - 1)
	chinese.text = question[questionNum]
	for i = 0, 2 do
		tags[(tmp + i) % 3]:setLabel(answer[(questionNum + i * math.random(vocNum / 2 - 1)) % vocNum])
	end
end

local function onTagsRelease( event )
	local points

	if( event.target:getLabel() == answer[questionNum] )then
		if (questionSheep.x < screenW * 0.45) or (questionSheep.x > screenW * 0.65) then
			points = 20
		elseif (questionSheep.x > screenW * 0.48) and (questionSheep.x < screenW * 0.65) then
			points = 100
		else
			points = 80
		end
	else
		points = -70
	end
	
	score = score + points
	showScore.text = score

	nextQuestion()
	return true	-- indicates successful touch
end

function scene:create( event )
	local sceneGroup = self.view

	-- display a background image
	local background = display.newImageRect( "./level1/background.png", screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	ready_go()
	timer.performWithDelay( 3700, init )
	--init()

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
end

function sheep( event )
	chinese = display.newText(question[questionNum], halfW, 50, native.systemFont, 30, right)
	showScore:setFillColor( 1, 211/255, 0 )

	questionSheep = display.newImage("./level1/sheep.png")
	questionSheep.x = -80
	questionSheep.y = screenH * 0.6
	questionSheep.xScale = 0.05
	questionSheep.yScale = 0.05

	transition.to(questionSheep, {time = 3000, x = screenW * 0.45})
	transition.to(questionSheep, {time = 100, delay = 3000, rotation = -30})
	transition.to(questionSheep, {time = 400, delay = 3100, x = screenW * 0.48, y = screenH * 0.48})
	transition.to(questionSheep, {time = 800, delay = 3500, x = screenW * 0.6, rotation = 30})
	transition.to(questionSheep, {time = 400, delay = 4300, x = screenW * 0.65, y = screenH * 0.6})
	transition.to(questionSheep, {time = 100, delay = 4700, rotation = 0})
	transition.to(questionSheep, {time = 3000, delay = 4800,x = screenW + 80})

	sheepGroup:insert( questionSheep )
end

function init( event )
	initGroup.alpha = 0

	local tmp = math.random(3)
	questionNum = math.random(vocNum - 1)
	for i = 0, 2 do
		tags[(tmp + i) % 3] = widget.newButton{
			label = answer[(questionNum + i * math.random(vocNum / 2 - 1)) % vocNum],
			labelColor = { default={000}, over={159/255, 80/255, 0} },
			fontSize = "18",
			defaultFile="./level1/tag.png",
			overFile="./level1/tag-over.png",
			width=100, height=80,
			onRelease = onTagsRelease
		}
		tags[(tmp + i) % 3].x = display.contentWidth*(0.04 + 0.2 * i) 
		tags[(tmp + i) % 3].y = display.contentHeight*0.85
	end

	local score_logo = display.newImage( "./level1/score.png")
	score_logo.x = screenH * 0.55
	score_logo.y = screenW * 0.05
	score_logo.xScale = 0.1
	score_logo.yScale = 0.1

	score = 0
	showScore = display.newText(score, 280, 20, native.systemFont, 30, right)
	showScore:setFillColor( 1, 211/255, 0 )
	showScore.alpha = 0

	initGroup:insert( tags[0] )
	initGroup:insert( tags[1] )
	initGroup:insert( tags[2] )
	initGroup:insert( score_logo )

	transition.to(initGroup, {time = 300, alpha = 1})
	transition.to(showScore, {time = 300, alpha = 1})
	timer.performWithDelay( 300, sheep )
	--sheep()
end

function ready_go( event )
	local ready = display.newImage("./level1/ready.png")
	ready.xScale = 0.05
	ready.yScale = 0.05
	initGroup:insert(ready)
	ready.x = -150
	ready.y = screenH/2
	transition.to( ready, { time = 300, delay = 800, x = halfW, xScale = 0.2, yScale = 0.2} )
	transition.to( ready, { time = 300, delay = 2100, x = screenW + 150, xScale = 0.05, yScale = 0.05} )

	local go = display.newImage("./level1/go.png")
	go.xScale = 0.1
	go.yScale = 0.1
	initGroup:insert(go)
	go.x = -150
	go.y = screenH/2
	transition.to( go, { time = 300, delay = 2400, x = halfW, xScale = 0.2, yScale = 0.2} )
	transition.to( go, { time = 300, delay = 3700, x = screenW + 150, xScale = 0.05, yScale = 0.05} )
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
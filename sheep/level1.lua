-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"
local math = require "math"
local physics = require "physics"
local initGroup = display.newGroup()
local sheepGroup = display.newGroup()

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW , halfH= display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5
local tags = {}
local questionNum, chinese, questionSheep, livesNum, score, showScore, gameOver, floor, ready, go, retry, score_logo, quit, correct, loss_life, get_life
local life = {}
local perfect, great, good, miss, wrong
local getPoints = {}

local function nextQuestion( event )
	local tmp = math.random(3)
	questionNum = math.random(vocNum - 1)
	chinese.text = question[questionNum]
	for i = 0, 2 do
		tags[(tmp + i) % 3]:setLabel(answer[(questionNum + i * math.random(vocNum / 2 - 1)) % vocNum])
	end
	sheep()
end

local function onRetryRelease( event )
	transition.to(gameOver, {time = 1000, alpha = 0})
	transition.to(retry, {time = 800, alpha = 0})
	transition.to(showScore, {time = 800, alpha = 0})
	transition.to(score_logo, {time = 800, alpha = 0})
	transition.to(quit, {time = 800, alpha = 0})
	ready_go()
	timer.performWithDelay( 3700, init )	
	return true
end

local function onQuitRelease( event )
	physics.stop()	
	composer.removeScene("level1")
	composer.gotoScene( "select_level", "fade", 500 )
	return true
end

local function game_over( event )	
	gameOver.x = halfW
	gameOver.y = -120
	gameOver.rotation = 15
	gameOver.alpha = 1

	physics.addBody( floor, "static", { friction=0.3 })
	physics.addBody( gameOver, { density = 1.0, friction = 1, bounce = 0.7 } )

	tags[0]:setEnabled(false)
	tags[1]:setEnabled(false)
	tags[2]:setEnabled(false)

	showScore:setFillColor( 1, 0, 0 )
	transition.to(initGroup, {time = 1500, alpha = 0})
	transition.to(retry, {time = 1500, alpha = 1})
end

local function onTagsRelease( event )
	local points

	if( event.target:getLabel() == answer[questionNum] )then
		if (questionSheep.x < screenW * 0.45) or (questionSheep.x > screenW * 0.65)then
			--miss
			miss.alpha = 1
			transition.to(miss, {time = 300, delay = 700, alpha = 0})
			points = 0
		elseif (questionSheep.x < screenW * 0.48) or (questionSheep.x > screenW * 0.6) then
			--good
			good.alpha = 1
			transition.to(good, {time = 300, delay = 700, alpha = 0})
			points = 20
		elseif (questionSheep.x > screenW * 0.52) and (questionSheep.x < screenW * 0.56) then
			--perfect
			perfect.alpha = 1
			transition.to(perfect, {time = 300, delay = 700, alpha = 0})
			points = 100
		else
			--great
			great.alpha = 1
			transition.to(great, {time = 300, delay = 700, alpha = 0})
			points = 80
		end
		correct = correct + 1
		if (correct == 10) and (livesNum < 5)then
			livesNum = livesNum + 1
			transition.to(life[livesNum], {time = 300, alpha = 1})
			correct = 0

			get_life.x = 0.05 * (livesNum + 1) * screenW + 10
			transition.to(get_life, {time = 200, alpha = 1})
			transition.to(get_life, {time = 300, delay = 700, alpha = 0})
		end
	else
		--wrong
		wrong.alpha = 1
		transition.to(wrong, {time = 300, delay = 700, alpha = 0})
		
		loss_life.x = 0.05 * livesNum * screenW + 10
		transition.to(loss_life, {time = 200, alpha = 1})
		transition.to(loss_life, {time = 300, delay = 700, alpha = 0})

		life[livesNum].alpha = 0
		livesNum = livesNum - 1
		if (livesNum == 0) then
			game_over()
		end
		points = -70
		correct = 0
	end

	if (points ~= 0) then
		getPoints[points].alpha = 1
		transition.to(getPoints[points], {time = 300, delay = 700, alpha = 0})
	end

	score = score + points
	showScore.text = score

	nextQuestion()
	return true	-- indicates successful touch
end

function sheepMissed( event )
	if (questionSheep.x > screenW * 0.65)then
		--miss
		miss.alpha = 1
		transition.to(miss, {time = 300, delay = 700, alpha = 0})
		nextQuestion()
	end
end

function scene:create( event )
	local sceneGroup = self.view

	-- display a background image
	local background = display.newImageRect( "./level1/background.png", screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	declare()
	ready_go()
	timer.performWithDelay( 3700, init )

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( initGroup )
	sceneGroup:insert( sheepGroup )
	sceneGroup:insert( showScore )
	sceneGroup:insert( gameOver )
	sceneGroup:insert( floor )
	sceneGroup:insert( ready )
	sceneGroup:insert( go )
	sceneGroup:insert( retry )
	sceneGroup:insert( score_logo )
	sceneGroup:insert( quit )
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
		physics.start()
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
		physics.stop()
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
	package.loaded[physics] = nil
	physics = nil
end

function sheep( event )
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

function declare( event )
	gameOver = display.newImage("./level1/game_over.png")
	gameOver.alpha = 0
	gameOver.xScale = 0.45
	gameOver.yScale = 0.45

	floor = display.newRect(halfW, screenH * 1.15, screenW, screenH * 0.1)
	floor.alpha = 0

	for i = 0, 2 do
		tags[i] = widget.newButton{
			labelColor = { default={000}, over={159/255, 80/255, 0} },
			fontSize = "18",
			defaultFile="./level1/tag.png",
			overFile="./level1/tag-over.png",
			width=100, height=80,
			onRelease = onTagsRelease
		}
		tags[i].x = display.contentWidth*(0.04 + 0.2 * i) 
		tags[i].y = display.contentHeight*0.85
	end

	score_logo = display.newImage( "./level1/score.png")
	score_logo.x = screenH * 0.65
	score_logo.y = screenW * 0.05
	score_logo.xScale = 0.1
	score_logo.yScale = 0.1
	score_logo.alpha = 0

	showScore = display.newText(" ", 320, 20, native.systemFont, 30, right)
	showScore.alpha = 0

	chinese = display.newText(" ", halfW, 50, native.systemFont, 30, right)
	showScore:setFillColor( 1, 211/255, 0 )

	initGroup:insert( tags[0] )
	initGroup:insert( tags[1] )
	initGroup:insert( tags[2] )
	initGroup:insert( chinese )
	initGroup.alpha = 0

	ready = display.newImage("./level1/ready.png")
	ready.xScale = 0.05
	ready.yScale = 0.05
	ready.x = -150
	ready.y = screenH/2

	go = display.newImage("./level1/go.png")
	go.xScale = 0.1
	go.yScale = 0.1
	go.x = -150
	go.y = screenH/2

	retry = widget.newButton{
		defaultFile="./level1/retry.png",
		overFile="./level1/retry-over.png",
		width=60, height=60,
		onRelease = onRetryRelease
	}
	retry.alpha = 0
	retry.x = screenW * 0.9
	retry.y = screenH * 0.9

	quit = widget.newButton{
		defaultFile="./level1/quit.png",
		overFile="./level1/quit-over.png",
		width=30, height=30,
		onRelease = onQuitRelease
	}
	quit.alpha = 0
	quit.x = screenW * 0.93
	quit.y = screenH * 0.07

	for i = 1, 5 do
		life[i] = display.newImage("./level1/life.png")
		life[i].xScale = 0.07
		life[i].yScale = 0.07
		life[i].x = 0.05 * i * screenW
		life[i].y = 0.07 * screenH
		life[i].alpha = 0
		initGroup:insert(life[i])
	end

	loss_life = display.newImage("./level1/loss_life.png")
	loss_life.xScale = 0.2
	loss_life.yScale = 0.2
	loss_life.y = 0.07 * screenH
	loss_life.alpha = 0
	initGroup:insert(loss_life)

	get_life = display.newImage("./level1/get_life.png")
	get_life.xScale = 0.2
	get_life.yScale = 0.2
	get_life.y = 0.07 * screenH
	get_life.alpha = 0
	initGroup:insert(get_life)

	perfect = display.newImage("./level1/perfect.png")
	perfect.xScale = 0.15
	perfect.yScale = 0.15
	perfect.x = 0.8 * screenW
	perfect.y = 0.4 * screenH
	perfect.alpha = 0
	initGroup:insert(perfect)

	great = display.newImage("./level1/great.png")
	great.xScale = 0.15
	great.yScale = 0.15
	great.x = 0.8 * screenW
	great.y = 0.4 * screenH
	great.alpha = 0
	initGroup:insert(great)

	good = display.newImage("./level1/good.png")
	good.xScale = 0.15
	good.yScale = 0.15
	good.x = 0.8 * screenW
	good.y = 0.4 * screenH
	good.alpha = 0
	initGroup:insert(good)

	miss = display.newImage("./level1/miss.png")
	miss.xScale = 0.25
	miss.yScale = 0.25
	miss.x = 0.8 * screenW
	miss.y = 0.4 * screenH
	miss.alpha = 0
	initGroup:insert(miss)

	wrong = display.newImage("./level1/wrong.png")
	wrong.xScale = 0.25
	wrong.yScale = 0.25
	wrong.x = 0.8 * screenW
	wrong.y = 0.4 * screenH
	wrong.alpha = 0
	initGroup:insert(wrong)

	getPoints[-70] = display.newImage("./level1/loss_70.png")
	getPoints[-70].xScale = 0.6
	getPoints[-70].yScale = 0.6
	getPoints[-70].x = 0.72 * screenW
	getPoints[-70].y = 0.18 * screenH
	getPoints[-70].alpha = 0
	initGroup:insert(getPoints[-70])

	getPoints[100] = display.newImage("./level1/get_100.png")
	getPoints[100].xScale = 0.6
	getPoints[100].yScale = 0.6
	getPoints[100].x = 0.72 * screenW
	getPoints[100].y = 0.18 * screenH
	getPoints[100].alpha = 0
	initGroup:insert(getPoints[100])

	getPoints[20] = display.newImage("./level1/get_20.png")
	getPoints[20].xScale = 0.6
	getPoints[20].yScale = 0.6
	getPoints[20].x = 0.72 * screenW
	getPoints[20].y = 0.18 * screenH
	getPoints[20].alpha = 0
	initGroup:insert(getPoints[20])

	getPoints[80] = display.newImage("./level1/get_80.png")
	getPoints[80].xScale = 0.6
	getPoints[80].yScale = 0.6
	getPoints[80].x = 0.72 * screenW
	getPoints[80].y = 0.18 * screenH
	getPoints[80].alpha = 0
	initGroup:insert(getPoints[80])
	
end

function init( event )
	livesNum = 3
	correct = 0

	score = 0
	showScore.text = score
	showScore:setFillColor( 1, 211/255, 0 )

	tags[0]:setEnabled(true)
	tags[1]:setEnabled(true)
	tags[2]:setEnabled(true)

	nextQuestion()
	transition.to(life[1], {time = 300, alpha = 1})
	transition.to(life[2], {time = 300, alpha = 1})
	transition.to(life[3], {time = 300, alpha = 1})
	transition.to(initGroup, {time = 300, alpha = 1})
	transition.to(showScore, {time = 300, alpha = 1})
	transition.to(score_logo, {time = 300, alpha = 1})
	transition.to(quit, {time = 300, alpha = 1})
end

function ready_go( event )
	ready.x = -150
	ready.y = screenH/2
	transition.to( ready, { time = 300, delay = 800, x = halfW, xScale = 0.2, yScale = 0.2} )
	transition.to( ready, { time = 300, delay = 2100, x = screenW + 150, xScale = 0.05, yScale = 0.05} )

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
-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local math = require "math"
local physics = require "physics"
--local media = require "media"
--local graphics = require "graphics"
local initGroup = display.newGroup()
local sheepGroup = display.newGroup()

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW , halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5
local tags = {}
local questionNum, chinese, questionSheep, livesNum, score, showScore, gameOver, floor, ready, go, retry, score_logo, quit, correct, loss_life, get_life
local life = {}
--local perfect, great, good, miss, wrong
local getPoints = {}
local options, sheepSheet, sequenceData, tagged, sheepTaggedSheet
local speed = 1
local wrongSound = media.newEventSound( "sounds/Music/wrong.mp3"  )
local correctSound = media.newEventSound( "sounds/Music/correct.mp3"  )
local levelup, level, level_logo, showLevel
local performance = {}
local points = {
	perfect = 100,
	great = 80,
	good = 20,
	miss = 0,
	wrong = -70
}

local function nextQuestion( event )
	local tmp = math.random(0, 2)
	questionNum = math.random(0, vocNum - 1)
	chinese.text = question[class][questionNum]
	tags[tmp]:setLabel(answer[class][questionNum])
	tags[(tmp + 1) % 3]:setLabel(answer[class][(questionNum + math.random(vocNum / 2)) % vocNum])
	tags[(tmp + 2) % 3]:setLabel(answer[class][(questionNum + vocNum / 2 + math.random(vocNum / 2 - 1)) % vocNum])
	sheep()
end

local function onRetryRelease( event )
	transition.to(gameOver, {time = 1000, alpha = 0})
	transition.to(retry, {time = 800, alpha = 0})
	transition.to(showScore, {time = 800, alpha = 0})
	transition.to(score_logo, {time = 800, alpha = 0})
	transition.to(level_logo, {time = 800, alpha = 0})
	transition.to(quit, {time = 800, alpha = 0})
	Runtime:removeEventListener("enterFrame", sheepMissed)
	ready_go()
	timer.performWithDelay( 3700, init )	
	return true
end

local function onQuitRelease( event )
	physics.stop()	
	audio.fadeOut( { channel = backgroundMusicChannel, time = 700} )
	media.stopSound()
	Runtime:removeEventListener("enterFrame", sheepMissed)
	composer.removeScene("game")
	composer.gotoScene( "select", "fade", 500 )
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
	local tagAnimation = display.newImage("game/tag.png")
	transition.to(tagAnimation, {time = 150, x = tagged.x - 12, y = tagged.y - 7, xScale = tagged.xScale, yScale = tagged.yScale, rotation = tagged.rotation})
	transition.to(tagAnimation, {time = 1, delay = 150, alpha = 0})
	transition.to(questionSheep, {time = 1, delay = 150, alpha = 0})
	transition.to(tagged, {time = 1, delay = 150, alpha = 1})

	media.stopSound()
	media.playSound( "sounds/".. string.lower(event.target:getLabel()) ..".mp3" )

	local tmp
	if( event.target:getLabel() == answer[class][questionNum] )then
		media.playEventSound( correctSound )
		if (questionSheep.x < screenW * 0.5) then
			tmp = "miss"
		elseif (questionSheep.x < screenW * 0.55) or (questionSheep.x > screenW * 0.69) then
			tmp = "good"
		elseif (questionSheep.x > screenW * 0.6) and (questionSheep.x < screenW * 0.64) then
			tmp = "perfect"
		else
			tmp = "great"
		end

		correct = correct + 1
		if (correct == 10)then
			nextLevel()
		end

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
		media.playEventSound( wrongSound )
		tmp = "wrong"

		loss_life.x = 0.05 * livesNum * screenW + 10
		transition.to(loss_life, {time = 200, alpha = 1})
		transition.to(loss_life, {time = 300, delay = 700, alpha = 0})

		life[livesNum].alpha = 0
		livesNum = livesNum - 1

		correct = 0
	end
	
	performance[tmp].alpha = 1
	transition.to(performance[tmp], {time = 300, delay = 700, alpha = 0})

	getPoints[tmp].alpha = 1
	transition.to(getPoints[tmp], {time = 300, delay = 700, alpha = 0})

	score = score + points[tmp]
	showScore.text = score

	Runtime:removeEventListener("enterFrame", sheepMissed)

	if (livesNum == 0) then
		game_over()
	else
		nextQuestion()
	end

	return true	-- indicates successful touch
end


function sheepMissed( event )
	if (questionSheep.x > screenW * 0.75)then
		Runtime:removeEventListener("enterFrame", sheepMissed)
		media.stopSound()
		media.playEventSound( wrongSound )
		media.playSound( "sounds/".. string.lower(answer[class][questionNum]) ..".mp3" )
		performance["miss"].alpha = 1
		transition.to(performance["miss"], {time = 300, delay = 700, alpha = 0})

		loss_life.x = 0.05 * livesNum * screenW + 10
		transition.to(loss_life, {time = 200, alpha = 1})
		transition.to(loss_life, {time = 300, delay = 700, alpha = 0})

		life[livesNum].alpha = 0
		livesNum = livesNum - 1
		if (livesNum == 0) then
			game_over()
		else
		correct = 0
		nextQuestion()
		end
	end
end

function scene:create( event )
	local sceneGroup = self.view

	--local backgroundMusic = audio.loadSound( backgroundSound  )
	local backgroundMusicChannel = audio.play( backgroundMusic, { loops = -1 } )
	audio.setVolume( 0, { channel = backgroundMusicChannel } )
	audio.fade( { channel = backgroundMusicChannel, time = 1500, volume = audio.getVolume() } )
	-- display a background image
	local background = display.newImageRect( "game/background.png", screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	--initGroup.alpha = 0
	declare_tags()
	declare_question()
	declare_sheep()
	declare_lives()
	declare_score()
	declare_level()
	declare_ready_go()
	declare_gameover()
	declare_quit()

	ready_go()
	timer.performWithDelay( 3700, init )

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( levelup )
	sceneGroup:insert( level_logo )
	sceneGroup:insert( showLevel )
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
	questionSheep = display.newSprite( sheepSheet, sequenceData )
	questionSheep:play()
	questionSheep.x = screenW * -0.2
	questionSheep.y = screenH * 0.63
	questionSheep.xScale = 0.35
	questionSheep.yScale = 0.35

	transition.to(questionSheep, {time = 3000 / speed, x = screenW * 0.5})
	transition.to(questionSheep, {time = 100 / speed, delay = 3000 / speed, rotation = -30})
	transition.to(questionSheep, {time = 400 / speed, delay = 3100 / speed, x = screenW * 0.55, y = screenH * 0.48})
	transition.to(questionSheep, {time = 800 / speed, delay = 3500 / speed, x = screenW * 0.69, rotation = 30})
	transition.to(questionSheep, {time = 400 / speed, delay = 4300 / speed, x = screenW * 0.75, y = screenH * 0.63})
	transition.to(questionSheep, {time = 100 / speed, delay = 4700 / speed, rotation = 0})
	transition.to(questionSheep, {time = 2500 / speed, delay = 4800 / speed,x = screenW * 1.2})

	tagged = display.newSprite( sheepTaggedSheet, sequenceData )
	tagged:play()
	tagged.x = screenW * -0.2
	tagged.y = screenH * 0.63
	tagged.xScale = 0.35
	tagged.yScale = 0.35
	tagged.alpha = 0

	transition.to(tagged, {time = 3000 / speed, x = screenW * 0.5})
	transition.to(tagged, {time = 100 / speed, delay = 3000 / speed, rotation = -30})
	transition.to(tagged, {time = 400 / speed, delay = 3100 / speed, x = screenW * 0.55, y = screenH * 0.48})
	transition.to(tagged, {time = 800 / speed, delay = 3500 / speed, x = screenW * 0.69, rotation = 30})
	transition.to(tagged, {time = 400 / speed, delay = 4300 / speed, x = screenW * 0.75, y = screenH * 0.63})
	transition.to(tagged, {time = 100 / speed, delay = 4700 / speed, rotation = 0})
	transition.to(tagged, {time = 2500 / speed, delay = 4800 / speed,x = screenW * 1.2})

	--timer.performWithDelay( 3000, questionSheep:pause())
	--timer.performWithDelay( 4700, questionSheep:play())
	
	sheepGroup:insert( questionSheep )
	sheepGroup:insert( tagged )
	Runtime:addEventListener("enterFrame", sheepMissed)
	--animation:setFrame( frame ) --用來指定播放第幾格
	--animation:pause() --用來暫停播放
end

function declare_tags( event )
	for i = 0, 2 do
		tags[i] = widget.newButton{
			labelColor = { default={000}, over={159/255, 80/255, 0} },
			fontSize = "18",
			defaultFile="game/tag.png",
			overFile="game/tag-over.png",
			width=100, height=80,
			onRelease = onTagsRelease
		}
		tags[i].x = display.contentWidth*(0.04 + 0.2 * i) 
		tags[i].y = display.contentHeight*0.85
		initGroup:insert( tags[i] )
	end
end

function declare_sheep( event )
	options = {
	    width = 250, 
	    height = 160, 
	    numFrames = 2
	}
 	sheepSheet = graphics.newImageSheet( "game/running_sheep.png", options )
 	sheepTaggedSheet = graphics.newImageSheet( "game/running_sheep_tagged.png", options )
 	sequenceData = {
	    start=1,
	    count=2,
	    time=300
	}
end

function declare_lives( event )
	for i = 1, 5 do
		life[i] = display.newImage("game/life.png")
		life[i].x = 0.05 * i * screenW
		life[i].y = 0.07 * screenH
		life[i].alpha = 0
		initGroup:insert(life[i])
	end

	loss_life = display.newImage("game/loss_life.png")
	loss_life.y = 0.07 * screenH
	loss_life.alpha = 0
	initGroup:insert(loss_life)

	get_life = display.newImage("game/get_life.png")
	get_life.y = 0.07 * screenH
	get_life.alpha = 0
	initGroup:insert(get_life)
end

function declare_score( event )
	score_logo = display.newImage( "game/score.png")
	score_logo.x = screenH * 0.65
	score_logo.y = screenW * 0.05
	score_logo.alpha = 0

	showScore = display.newText(" ", 320, 20, native.systemFont, 30, right)
	showScore.alpha = 0

	local performanceText = {
	[1] = "perfect", 
	[2] = "great", 
	[3] = "good", 
	[4] = "miss", 
	[5] = "wrong"
	}

	for i = 1, 5 do
		performance[performanceText[i]] = display.newImage("game/" .. performanceText[i] .. ".png")
		performance[performanceText[i]].x = 0.8 * screenW
		performance[performanceText[i]].y = 0.4 * screenH
		performance[performanceText[i]].alpha = 0
		initGroup:insert(performance[performanceText[i]])
	end

	for i = 1, 5 do
		print (i)
		getPoints[performanceText[i]] = display.newImage("game/" .. points[performanceText[i]] .. ".png")
		getPoints[performanceText[i]].xScale = 0.6
		getPoints[performanceText[i]].yScale = 0.6
		getPoints[performanceText[i]].x = 0.72 * screenW
		getPoints[performanceText[i]].y = 0.18 * screenH
		getPoints[performanceText[i]].alpha = 0
		initGroup:insert(getPoints[performanceText[i]])
	end
end

function declare_level( event )
	levelup = display.newImage("game/levelup.png")
	levelup.x = -100
	levelup.y = -100

	level_logo = display.newText("LEVEL", 360, 20, native.systemFont, 20, right)
	level_logo.alpha = 0
	showLevel = display.newText(" ", 400, 20, native.systemFont, 20, right)
end

function declare_ready_go( event )
	ready = display.newImage("game/ready.png")
	ready.x = -150
	ready.y = screenH/2

	go = display.newImage("game/go.png")
	go.x = -150
	go.y = screenH/2
end

function declare_gameover( event )
	gameOver = display.newImage("game/game_over.png")
	gameOver.alpha = 0

	floor = display.newRect(halfW, screenH * 1.15, screenW, screenH * 0.1)
	floor.alpha = 0

	retry = widget.newButton{
		defaultFile="game/retry.png",
		overFile="game/retry-over.png",
		width=60, height=60,
		onRelease = onRetryRelease
	}
	retry.alpha = 0
	retry.x = screenW * 0.9
	retry.y = screenH * 0.9
end

function declare_quit( event )
	quit = widget.newButton{
		defaultFile="game/quit.png",
		overFile="game/quit-over.png",
		width=30, height=30,
		onRelease = onQuitRelease
	}
	--quit.alpha = 0
	quit.x = screenW * 0.93
	quit.y = screenH * 0.07
	initGroup:insert( quit )
end

function declare_question( event )
	chinese = display.newText(" ", halfW, 50, native.systemFont, 30, right)
	initGroup:insert( chinese )
end

function init( event )
	livesNum = 3
	correct = 0
	level = 1

	score = 0
	showScore.text = score
	showScore:setFillColor( 1, 211/255, 0 )

	showLevel.text = level
	--showScore:setFillColor( 1, 211/255, 0 )

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
	transition.to(level_logo, {time = 300, alpha = 1})
	transition.to(quit, {time = 300, alpha = 1})
end

function ready_go( event )
	ready.x = -150
	ready.y = screenH/2
	transition.to( ready, { time = 300, delay = 800, x = halfW} )
	transition.to( ready, { time = 300, delay = 2100, x = screenW + 150} )

	go.x = -150
	go.y = screenH/2
	transition.to( go, { time = 300, delay = 2400, x = halfW} )
	transition.to( go, { time = 300, delay = 3700, x = screenW + 150} )
end

function nextLevel( event )
	speed = speed + 0.15
	level = level + 1
	showLevel.text = level

	levelup.x = -150
	levelup.y = screenH * 0.4
	transition.to( levelup, { time = 300, delay = 800, x = halfW} )
	transition.to( levelup, { time = 300, delay = 2100, x = screenW + 150} )

end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
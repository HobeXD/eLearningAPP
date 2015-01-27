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
local audio = require "audio"
local media = require "media"
local initGroup = display.newGroup()
local sheepGroup = display.newGroup()

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW , halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5
local tags = {}
local label = {}
local questionNum, chinese, questionSheep, livesNum, score, showScore, gameOver, floor, ready, go, retry, score_logo, quit, correct, loss_life, get_life
local life = {}
local getPoints = {}
local options, sheepSheet, sequenceData, tagged, sheepTaggedSheet, rankBtn
local speed = 1
local levelup, level, level_logo, showLevel
local performance = {}
local points = {
	perfect = 100,
	great = 80,
	good = 20,
	miss = 0,
	wrong = -70
}
local backgroundMusicChannel, stopSound, playSound, textBox, quit

local function nextQuestion( event )
	local tmp = math.random(0, 2)
	questionNum = math.random(0, vocNum - 1)
	if TEXT then
		chinese.text = question[class][questionNum]
	else
		media.playSound( "sounds/".. string.lower(answer[class][questionNum]) ..".mp3" )
	end

	tags[tmp]:setLabel(answer[class][questionNum])
	tags[(tmp + 1) % 3]:setLabel(answer[class][(questionNum + math.random(vocNum / 2)) % vocNum])
	tags[(tmp + 2) % 3]:setLabel(answer[class][(questionNum + vocNum / 2 + math.random(vocNum / 2 - 1)) % vocNum])
	
	label[tmp].text = tags[tmp]:getLabel()
	label[(tmp + 1) % 3].text = tags[(tmp + 1) % 3]:getLabel()
	label[(tmp + 2) % 3].text = tags[(tmp + 2) % 3]:getLabel()

	sheep()
end

local function onRetryRelease( event )
	transition.to(gameOver, {time = 1000, alpha = 0})
	transition.to(retry, {time = 800, alpha = 0})
	transition.to(showScore, {time = 800, alpha = 0})
	transition.to(score_logo, {time = 800, alpha = 0})
	transition.to(showLevel, {time = 800, alpha = 0})
	transition.to(level_logo, {time = 800, alpha = 0})
	transition.to(quit, {time = 800, alpha = 0})
	transition.to(textBox, {time = 800, alpha = 0})
	transition.to(rankBtn, {time = 800, alpha = 0})
	transition.to(soundGroup, {time = 800, alpha = 0})
	ready_go()
	timer.performWithDelay( 3700, init )	
	return true
end

local function onQuitRelease( event )
	Runtime:removeEventListener("enterFrame", sheepMissed)
	physics.stop()	
	audio.fadeOut( { channel = backgroundMusicChannel, time = 700} )
	media.stopSound()
	composer.removeScene("game")
	textBox:removeSelf()
	transition.to(soundGroup, {time = 500, alpha = 0})
	transition.to(soundGroup, {time = 500, delay = 700, alpha = 1})
	composer.gotoScene( "select", "fade", 500 )
	return true
end

local function game_over( event )	
	gameOver.x = screenW*0.65
	gameOver.y = -120
	gameOver.rotation = 15
	gameOver.alpha = 1

	physics.addBody( floor, "static", { friction=0.3 })
	physics.addBody( gameOver, { density = 1.0, friction = 1, bounce = 0.5 } )

	tags[0]:setEnabled(false)
	tags[1]:setEnabled(false)
	tags[2]:setEnabled(false)

	textBox.isEditable = true

	rankBtn:setEnabled(true)

	showScore:setFillColor( 1, 0, 0 )
	transition.to(initGroup, {delay = 1000, time = 500, alpha = 0})
	transition.to(retry, {delay = 1000,time = 500, alpha = 1})
	transition.to(textBox, {delay = 1000,time = 500, alpha = 1})
	transition.to(rankBtn, {delay = 1000,time = 500, alpha = 1})
end

local function onTagsRelease( event )
	local tagAnimation = display.newImage("game/tag.png")
	transition.to(tagAnimation, {time = 150, x = tagged.x - 12, y = tagged.y - 7, xScale = tagged.xScale, yScale = tagged.yScale, rotation = tagged.rotation})
	transition.to(tagAnimation, {time = 1, delay = 150, alpha = 0})
	transition.to(questionSheep, {time = 1, delay = 150, alpha = 0})
	transition.to(tagged, {time = 1, delay = 150, alpha = 1})

	--media.stopSound()
	--media.pauseSound()
	local tmp
	if( event.target:getLabel() == answer[class][questionNum] )then
		media.playEventSound( correctSound )
		if TEXT then
			media.playSound( "sounds/".. string.lower(event.target:getLabel()) ..".mp3" )
		end

		if (questionSheep.x < screenW * 0.5) then
			tmp = "miss"
		elseif (questionSheep.x < screenW * 0.55) or (questionSheep.x > screenW * 0.69) then
			tmp = "good"
		elseif (questionSheep.x > screenW * 0.61) and (questionSheep.x < screenW * 0.63) then
			tmp = "perfect"
		else
			tmp = "great"
		end

		correct = correct + 1
		if (correct == 10) then
			nextLevel()
			correct = 0

			if (livesNum < 5) then
				livesNum = livesNum + 1
				transition.to(life[livesNum], {time = 300, alpha = 1})

				get_life.x = 0.05 * (livesNum + 1) * screenW + 15
				transition.to(get_life, {time = 200, alpha = 1})
				transition.to(get_life, {time = 300, delay = 700, alpha = 0})
			end
		end
	else
		--wrong
		media.playEventSound( wrongSound )
		--media.playSound( "sounds/".. string.lower(event.target:getLabel()) ..".mp3" )
		tmp = "wrong"

		loss_life.x = 0.05 * livesNum * screenW + 15
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

local function onRankRelease( event )
	physics.stop()	
	audio.fadeOut( { channel = backgroundMusicChannel, time = 700} )
	media.stopSound()
	textBox:removeSelf()
	fromGame = false
	transition.to(soundGroup, {time = 500, alpha = 0})
	transition.to(soundGroup, {time = 500, delay = 700, alpha = 1})
	composer.removeScene("game")
	composer.gotoScene( "rank", "fade", 500 )
	return true
end

function sheepMissed( event )
	if (questionSheep.x > screenW * 0.75)then
		Runtime:removeEventListener("enterFrame", sheepMissed)
		--media.stopSound()
		--media.pauseSound()
		media.playEventSound( wrongSound )
		--media.playSound( "sounds/".. string.lower(answer[class][questionNum]) ..".mp3" )
		performance["miss"].alpha = 1
		transition.to(performance["miss"], {time = 300, delay = 700, alpha = 0})

		loss_life.x = 0.05 * livesNum * screenW + 15
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

	backgroundMusicChannel = audio.play( backgroundMusic, { loops = -1 } )
	audio.setVolume( 0, { channel = backgroundMusicChannel } )
	currentChannel = backgroundMusicChannel
	if (stopFlag == false) then
		audio.fade( { channel = backgroundMusicChannel, time = 1500, volume = 0.5 } )
	end
	-- display a background image
	local background = display.newImageRect( "game/background.png", screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	soundGroup.alpha = 0

	initGroup.alpha = 0
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
	sceneGroup:insert( textBox )
	sceneGroup:insert( rankBtn )
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

	--timer.performWithDelay( 3000, function() questionSheep:pause() end)
	--timer.performWithDelay( 4700, function() questionSheep:play() end)
	--timer.performWithDelay( 3000, function() tagged:pause() end)
	--timer.performWithDelay( 4700, function() tagged:play() end)
	
	sheepGroup:insert( questionSheep )
	sheepGroup:insert( tagged )
	Runtime:addEventListener("enterFrame", sheepMissed)
	--animation:setFrame( frame ) --用來指定播放第幾格
end

function declare_tags( event )
	for i = 0, 2 do
		tags[i] = widget.newButton{
			labelColor = { default={159/255, 80/255, 0, 0.01}, over={159/255, 80/255, 0, 0} },
			fontSize = "18",
			defaultFile="game/tag.png",
			overFile="game/tag-over.png",
			width=100, height=80,
			onRelease = onTagsRelease
		}
		tags[i].x = display.contentWidth*0.12 + 110 * i
		tags[i].y = display.contentHeight*0.86
		initGroup:insert( tags[i] )

		label[i] = display.newText({text = " ", x = tags[i].x, y = tags[i].y, width = 100, font = native.systemFont, fontSize = 18, align = "center"})
		label[i]:setFillColor( 0, 0, 0 )
		initGroup:insert( label[i] )
	end
end

function declare_sheep( event )
	options = {
	    width = 250, 
	    height = 165, 
	    numFrames = 6
	}
 	sheepSheet = graphics.newImageSheet( "game/running_sheep.png", options )
 	sheepTaggedSheet = graphics.newImageSheet( "game/running_sheep_tagged.png", options )
 	sequenceData = {
	    start=1,
	    count=6,
	    time=700
	}
end

function declare_lives( event )
	for i = 1, 5 do
		life[i] = display.newImage("game/life.png")
		life[i].xScale, life[i].yScale = 0.6, 0.6
		life[i].x = 0.05 * i * screenW
		life[i].y = 0.07 * screenH
		life[i].alpha = 0
		initGroup:insert(life[i])
	end

	loss_life = display.newImage("game/loss_life.png")
	loss_life.xScale, loss_life.yScale = 0.5, 0.5
	loss_life.y = 0.07 * screenH
	loss_life.alpha = 0
	initGroup:insert(loss_life)

	get_life = display.newImage("game/get_life.png")
	get_life.xScale, get_life.yScale = 0.5, 0.5
	get_life.y = 0.07 * screenH
	get_life.alpha = 0
	initGroup:insert(get_life)
end

function declare_score( event )
	score_logo = display.newImage( "game/score.png")
	score_logo.xScale , score_logo.yScale = 0.6, 0.6
	score_logo.x = screenW * 0.4
	score_logo.y = screenH * 0.06
	score_logo.alpha = 0

	showScore = display.newText({text = " ", x = screenW * 0.4 + 90, y = 20, width = 100, font = native.systemFont, fontSize = 30, align = "right"})
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
		performance[performanceText[i]].x = 0.82 * screenW
		performance[performanceText[i]].y = 0.37 * screenH
		performance[performanceText[i]].xScale, performance[performanceText[i]].yScale = 0.7, 0.7 
		performance[performanceText[i]].alpha = 0
		initGroup:insert(performance[performanceText[i]])
	end

	for i = 1, 5 do
		getPoints[performanceText[i]] = display.newImage("game/" .. points[performanceText[i]] .. ".png")
		getPoints[performanceText[i]].xScale = 0.6
		getPoints[performanceText[i]].yScale = 0.6
		getPoints[performanceText[i]].x = 0.7 * screenW
		getPoints[performanceText[i]].y = 0.15 * screenH
		getPoints[performanceText[i]].alpha = 0
		initGroup:insert(getPoints[performanceText[i]])
	end
end

function declare_level( event )
	levelup = display.newImage("game/levelup.png")
	levelup.x = -100
	levelup.y = -100

	level_logo = display.newText("LEVEL", screenW * 0.8, 20, native.systemFont, 20, right)
	level_logo.alpha = 0
	showLevel = display.newText({text = " ", x = screenW * 0.8 + 40, y = 20, width = 30, font = native.systemFont, fontSize = 20, align = "right"})
	showLevel.alpha = 0
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

	floor = display.newRect(halfW, screenH * 0.8, screenW, screenH * 0.1)
	floor.alpha = 0

	retry = widget.newButton{
		defaultFile="game/retry.png",
		overFile="game/retry-over.png",
		width=60, height=60,
		onRelease = onRetryRelease
	}
	retry.alpha = 0
	retry.xScale, retry.yScale = 0.9, 0.9
	retry.x = screenW * 0.75
	retry.y = screenH * 0.65

	textBox = native.newTextField( halfW, screenH * 0.2 , 150, 23 )
	textBox.alpha = 0
	textBox.placeholder = "Enter your name"
	textBox.font = native.newFont( native.systemFontBold, 18 )
	textBox:setTextColor( 0.8, 0.8, 0.8 )
	textBox:addEventListener( "userInput", typing )

	rankBtn = widget.newButton{
		defaultFile = "select/rank.png",
		width = 50, height = 30,
		onRelease = onRankRelease	-- event listener function
	}
	rankBtn.x = display.contentWidth*0.9 - 40
	rankBtn.y = display.contentHeight*0.9
	rankBtn.alpha = 0
end

function typing( event )
	if ( event.phase == "submitted" ) then
       	username = event.target.text
		userscore = score
    	physics.stop()	
		audio.fadeOut( { channel = backgroundMusicChannel, time = 700} )
		media.stopSound()
		textBox:removeSelf()
		fromGame = true
		transition.to(soundGroup, {time = 500, alpha = 0})
		transition.to(soundGroup, {time = 500, delay = 700, alpha = 1})
		composer.removeScene("game")
		composer.gotoScene( "rank", "fade", 500 )
		return true
    end 
end

function declare_quit( event )
	quit = widget.newButton{
		defaultFile="game/quit.png",
		overFile="game/quit-over.png",
		width=30, height=30,
		onRelease = onQuitRelease
	}
	quit.alpha = 0
	quit.xScale, quit.yScale = 0.9, 0.9
	quit.x = screenW * 0.96
	quit.y = screenH * 0.06
	initGroup:insert( quit )
end

function declare_question( event )
	chinese = display.newText(" ", halfW, 60, native.systemFont, 30)
	chinese:setFillColor( 108/255, 108/255, 108/255 )
	initGroup:insert( chinese )
end

function init( event )
	livesNum = 3
	correct = 0

	score = 0
	showScore.text = score
	showScore:setFillColor( 1, 190/255, 0 )

	level = 1
	showLevel.text = level

	tags[0]:setEnabled(true)
	tags[1]:setEnabled(true)
	tags[2]:setEnabled(true)

	textBox.isEditable = false

	rankBtn:setEnabled(false)

	nextQuestion()
	for i = 1, livesNum do
		transition.to(life[i], {time = 300, alpha = 1})
	end
	transition.to(initGroup, {time = 300, alpha = 1})
	transition.to(showScore, {time = 300, alpha = 1})
	transition.to(score_logo, {time = 300, alpha = 1})
	transition.to(level_logo, {time = 300, alpha = 1})
	transition.to(showLevel, {time = 300, alpha = 1})
	transition.to(quit, {time = 300, alpha = 1})
	transition.to(soundGroup, {time = 300, alpha = 1})
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
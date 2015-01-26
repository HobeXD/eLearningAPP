local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"

local centerX, centerY = display.contentWidth/2, display.contentHeight/2
local sea, fish
local fish_left_img, fish_right_img
local question, answerBtn1, answerBtn2, correct_ans
local score, score_word, score_text
local en = {}
local ch = {}
local timeLeft, time_word, time_text, timerid
local theme

local function timerDown()
	timeLeft = timeLeft-1
	time_text.text = timeLeft
	if(timeLeft == 0) then
		composer.gotoScene( "level_complete", "fade", 500 )
	end
end

math.randomseed(os.time())

function string:split( inSplitPattern, outResults )
	if not outResults then
	  outResults = { }
	end
	local theStart = 1
	local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
	while theSplitStart do
		table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
		theStart = theSplitEnd + 1
		theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
	end
	table.insert( outResults, string.sub( self, theStart ) )
	return outResults
end

local function getWrongAnswerIndex( index)
	local wrong_ans_index = math.random(table.getn(en))
	while wrong_ans_index == index do
		wrong_ans_index = math.random(table.getn(en))
	end
	return wrong_ans_index
end

local function setQuestion()
	local index = math.random(table.getn(en))
	question.text = en[index]
	correct_ans = math.random(2)
	if correct_ans == 1 then
		answerBtn1:setLabel(ch[index])
		local wrong_ans_index = getWrongAnswerIndex(index)
		answerBtn2:setLabel(ch[wrong_ans_index])
	else
		answerBtn2:setLabel(ch[index])
		local wrong_ans_index = getWrongAnswerIndex(index)
		answerBtn1:setLabel(ch[wrong_ans_index])
	end
	audio.play(audio.loadSound( "pronounciation/" .. theme .. " sound/" .. question.text .. ".mp3"))
end

local function decreaseSeaHeight()
	local yNew = sea.y + 10
	if ( yNew > sea.height * 1.5  - 2.5 * fish.height) then
		composer.gotoScene( "game_over", "fade", 500 )
	else
		sea.y = yNew + 10
	end
end

local function increaseSeaHeight()
	local yNew = sea.y - 30
	if ( yNew < sea.height / 2 ) then
		sea.y = sea.height / 2
	else
		sea.y = yNew
	end
end

local function onAnswerBtn1Release()
	audio.pause()
	if correct_ans == 1 then
		increaseSeaHeight()
		score = math.floor(score + (sea.height * 1.5  - 2.5 * fish.height - sea.y)/10)
		score_text.text = score
		audio.play(audio.loadSound( "sound/correct.wav"))
	else
		decreaseSeaHeight()
		audio.play(audio.loadSound( "sound/wrong.wav"))
	end
	setQuestion()
end

local function onAnswerBtn2Release()
	audio.pause()
	if correct_ans == 2 then
		increaseSeaHeight()
		score = math.floor(score + (sea.height * 1.5  - 2.5 * fish.height - sea.y)/10)
		score_text.text = score
		audio.play(audio.loadSound( "sound/correct.wav"))
	else
		decreaseSeaHeight()
		audio.play(audio.loadSound( "sound/wrong.wav"))
	end
	setQuestion()
end

function scene:create( event )

	local sceneGroup = self.view
	local sky = display.newImageRect(sceneGroup, "pic/sky.png", display.contentWidth, display.contentHeight )
	sky.x, sky.y = centerX, centerY
	sceneGroup:insert( sky )

	sea = display.newImageRect(sceneGroup, "pic/sea.png", display.contentWidth, display.contentHeight )
	sceneGroup:insert( sea )

	local options = {
		width = 257,
		height = 125,
		numFrames = 2
	}
	local fishSheet = graphics.newImageSheet( "pic/fish.png", options )

	local sequenceData = {
		name = "fish",
		start = 1,
		count = 2,
	}

	fish = display.newSprite( sceneGroup, fishSheet, sequenceData )
	fish:setSequence( "fish" )
	fish:setFrame( 2 )
	fish.width, fish.height = 90, 45

	question = display.newText( {parent=sceneGroup, text="Color", x=display.contentWidth/2, y=70, font=native.systemFont, fontSize=30} )
	score_word = display.newText( {parent=sceneGroup, text="Score: ", font=native.systemFont, fontSize=20} )
	score_word.x, score_word.y = score_word.width/2 + 10, score_word.height/2 + 10
	score_text = display.newText( {parent=sceneGroup, text="0", font=native.systemFont, fontSize=20} )
	score_text.x, score_text.y = score_word.x + score_word.width/2 + score_text.width/2 + 10, score_word.y


	time_word = display.newText( {parent=sceneGroup, text="Timeleft: ", font=native.systemFont, fontSize=20} )
	time_word.x, time_word.y = display.contentWidth*3/4 - time_word.width/2 + 10, time_word.height/2 + 10
	time_text = display.newText( {parent=sceneGroup, text="60", font=native.systemFont, fontSize=20} )
	time_text.x, time_text.y = time_word.x + time_word.width/2 + time_text.width/2 + 10, time_word.y

	answerBtn1 = widget.newButton{
		default="pic/answer.png",
		-- over="pic/button-over.png",
		x, y = display.contentWidth*3/4, 100,
		-- x = display.contentWidth/4,
		-- y = 100,
		onRelease = onAnswerBtn1Release	-- event listener function
	}
	answerBtn1.width, answerBtn1.height = 300, 200

	answerBtn2 = widget.newButton{
		default="pic/answer.png",
		-- over="pic/button-over.png",
		x, y = display.contentWidth*3/4, 100,
		onRelease = onAnswerBtn2Release	-- event listener function
	}
	answerBtn2.width, answerBtn2.height = 300, 200


	sceneGroup:insert( answerBtn1 )
	sceneGroup:insert( answerBtn2 )

end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		theme = event.params.word
		local path = system.pathForFile( "word/" .. theme .. " words.csv" )
		local file = io.open( path, "r" )

		for line in file:lines() do
			local tmp = line:split(",")
			table.insert(en, tmp[1])
			table.insert(ch, tmp[2])
		end

		io.close( file )
		file = nil

		sea.x, sea.y, sea.ydir, sea.yspeed = centerX, centerY, 1, 1
		fish.x, fish.y, fish.xdir, fish.xspeed, fish.ydir, fish.yspeed = centerX, centerY, 1, 1.5, 1, 2
		setQuestion()

	elseif phase == "did" then
		local screenTop = display.screenOriginY
		local screenBottom = display.viewableContentHeight + display.screenOriginY
		local screenLeft = display.screenOriginX
		local screenRight = display.viewableContentWidth + display.screenOriginX

		function sea:enterFrame( event )
			local yNew = sea.y + sea.yspeed

			if ( yNew > sea.height * 1.5 - 2.5 * fish.height) then
				composer.gotoScene( "game_over", "fade", 500 )
			end

			sea:translate( 0, sea.yspeed )
		end

		function fish:enterFrame( event )
			local dy = fish.yspeed * fish.ydir
			local dx = fish.xspeed * fish.xdir 
			local yNew = fish.y + dy
			local xNew = fish.x + dx

			if ( xNew > screenRight - fish.contentWidth/2 or xNew < screenLeft + fish.contentWidth/2 ) then
				fish.xdir = -fish.xdir
				if (fish.xdir < 0) then
					fish:setFrame( 1 )
					fish.width, fish.height = 90, 45
				else
					fish:setFrame( 2 )
					fish.width, fish.height = 90, 45
				end
			end		
			if ( fish.ydir >= 0 and yNew > screenBottom - fish.contentHeight/2 or fish.ydir < 0 and yNew < sea.y - sea.contentHeight / 2 + 2 * fish.contentHeight ) then
				fish.ydir = -fish.ydir
			end

			fish:translate( dx, dy )
		end

		local function onKeyEvent( event )
			if ( event.keyName == "back" ) then
				Runtime:removeEventListener( "key", onKeyEvent )
				composer.gotoScene( "level_selection", "fade", 500 )
				return true
			end
			return false
		end

		Runtime:addEventListener( "key", onKeyEvent )
		Runtime:addEventListener( "enterFrame", sea )
		Runtime:addEventListener( "enterFrame", fish )

		fish.isVisible = true
		score = 0
		score_text.text = score
		timeLeft = 10
		time_text.text = timeLeft
		timerid = timer.performWithDelay(1000, timerDown, timeLeft)
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		fish.isVisible = false
	elseif phase == "did" then
		en = {}
		ch = {}
		timer.pause(timerid)
		audio.pause()
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )
	local sceneGroup = self.view
	for i=1, #sceneGroup do 
		sceneGroup[i]:removeSelf()
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene
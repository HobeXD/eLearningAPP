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
	local yNew = sea.y - 100
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
	sea = display.newImageRect(sceneGroup, "pic/sea.png", display.contentWidth, display.contentHeight )
	sea.x, sea.yspeed = centerX, 3

	question = display.newText( sceneGroup, "Color", centerX, 130, native.systemFont, 80 )
	local score_word = display.newText( sceneGroup, "Score: ", 120, 50, native.systemFont, 55 )
	score_text = display.newText( {parent=sceneGroup, text="", x=350, y=50, width=300, font=native.systemFont, fontSize=55, align="left"} )
	local time_word = display.newText( sceneGroup, "Timeleft: ", 500, 50, native.systemFont, 60 )
	time_text = display.newText( {parent=sceneGroup, text="", x=660, y=50, width=100, font=native.systemFont, fontSize=55, align="left"} )
	
	answerBtn1 = widget.newButton{
		defaultFile="pic/answer.png",
		-- overFile="pic/button-over.png",
		font = native.systemFontBold,
		fontSize=55,
		x = display.contentWidth/4, 
		y = 250,
		onRelease = onAnswerBtn1Release	-- event listener function
	}
	answerBtn1.width, answerBtn1.height = 200, 150

	answerBtn2 = widget.newButton{
		defaultFile="pic/answer.png",
		-- overFile="pic/button-over.png",
		font = native.systemFontBold,
		fontSize = 55,
		x = display.contentWidth*3/4,
		y = 250,
		onRelease = onAnswerBtn2Release	-- event listener function
	}
	answerBtn2.width, answerBtn2.height = 200, 150
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

		local options = {
			width = 407,
			height = 181,
			numFrames = 2
		}
		local fishSheet = graphics.newImageSheet( "pic/fish1.png", options )
		local sequenceData = {
			name = "fish",
			start = 1,
			count = 2,
		}

		fish = display.newSprite( sceneGroup, fishSheet, sequenceData )
		fish:setSequence( "fish" )
		fish:setFrame( 2 )
		fish.width, fish.height = 250, 120


		sea.y = centerY
		fish.x, fish.y, fish.xdir, fish.xspeed, fish.ydir, fish.yspeed = centerX, centerY, 1, 1.5, 1, 2
		setQuestion()

	elseif phase == "did" then
		local screenTop = display.screenOriginY
		local screenBottom = display.viewableContentHeight + display.screenOriginY
		local screenLeft = display.screenOriginX
		local screenRight = display.viewableContentWidth + display.screenOriginX

		function sea:enterFrame( event )
			local yNew = sea.y + sea.yspeed 

			if ( yNew > display.contentHeight*1.1 - fish.height) then
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

		local function timerDown()
			timeLeft = timeLeft-1
			time_text.text = timeLeft
			if(timeLeft == 0) then
				composer.gotoScene( "level_complete", "fade", 500 )
			end
		end

		-- fish.isVisible = true
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

	if phase == "will" then
		en = {}
		ch = {}
		timer.pause(timerid)
		audio.pause()
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
-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()

local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local wave, fish
local fish_left_img, fish_right_img
local question, answerBtn1, answerBtn2, correct_ans
local score, score_word, score_text
local en = {}
local ch = {}
local timeLeft, time_word, time_text, timerid

local function timerDown()
   timeLeft = timeLeft-1
   time_text.text = timeLeft
     if(timeLeft == 0)then
        composer.gotoScene( "level_clear", "fade", 500 )
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
end

local function decreaseWaveHeight()
	local yNew = wave.y + 10
	if ( yNew > wave.height * 1.5  - 2.5 * fish.height) then
		composer.gotoScene( "game_over", "fade", 500 )
	else
		wave.y = yNew + 10
	end
end

local function increaseWaveHeight()
	local yNew = wave.y - 30
	if ( yNew < wave.height / 2 ) then
		wave.y = wave.height / 2
	else
		wave.y = yNew
	end
end

local function onAnswerBtn1Release()
	if correct_ans == 1 then
		increaseWaveHeight()
		score = math.floor(score + (wave.height * 1.5  - 2.5 * fish.height - wave.y)/10)
		score_text.text = score
	else
		decreaseWaveHeight()
	end
	setQuestion()
end

local function onAnswerBtn2Release()
	if correct_ans == 2 then
		increaseWaveHeight()
		score = math.floor(score + (wave.height * 1.5  - 2.5 * fish.height - wave.y)/10)
		score_text.text = score
	else
		decreaseWaveHeight()
	end
	setQuestion()
end

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view


	wave = display.newImageRect( sceneGroup, "wave.png", display.contentWidth, display.contentHeight)
    wave.x, wave.y = display.contentWidth/2, display.contentHeight - wave.contentHeight/2
    wave.ydir = 1
	wave.yspeed = 1

	fish_left_img = { type="image", filename="fish_left.png" }
	fish_right_img = { type="image", filename="fish_right.png" }

	-- local fish = display.newImageRect( sceneGroup, "fish_left.png", 90, 45)
	fish = display.newRect( sceneGroup, display.contentWidth/2, display.contentHeight/2, 90, 45)
	fish.fill = fish_right_img
    -- fish.x, fish.y = display.contentWidth/2, display.contentHeight/2
    fish.xdir = 1
	fish.xspeed = 1.5
    fish.ydir = 1
	fish.yspeed = 2
 
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
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onAnswerBtn1Release	-- event listener function
	}
	answerBtn1.x = display.contentWidth/4
	answerBtn1.y = 100

	answerBtn2 = widget.newButton{
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onAnswerBtn2Release	-- event listener function
	}
	answerBtn2.x = display.contentWidth*3/4
	answerBtn2.y = 100


	sceneGroup:insert( answerBtn1 )
	sceneGroup:insert( answerBtn2 )

	local path = system.pathForFile( "level1 words.csv" )
	local file = io.open( path, "r" )

	for line in file:lines() do
		-- if line == nil then break end
	    local tmp = line:split(",")
	    table.insert(en, tmp[1])
	    table.insert(ch, tmp[2])
	end

	io.close( file )
	file = nil

end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		wave.x, wave.y = display.contentWidth/2, display.contentHeight - wave.contentHeight/2
		fish.x, fish.y = display.contentWidth/2, display.contentHeight/2
		setQuestion()

	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.   
		-- physics.start()
		local screenTop = display.screenOriginY
		local screenBottom = display.viewableContentHeight + display.screenOriginY
		local screenLeft = display.screenOriginX
		local screenRight = display.viewableContentWidth + display.screenOriginX

		function wave:enterFrame( event )
			local yNew = wave.y + wave.yspeed

			if ( yNew > wave.height * 1.5 - 2.5 * fish.height) then
				composer.gotoScene( "game_over", "fade", 500 )
			end

			wave:translate( 0, wave.yspeed )
		end

		function fish:enterFrame( event )
			local dy = fish.yspeed * fish.ydir
			local dx = fish.xspeed * fish.xdir 
			local yNew = fish.y + dy
			local xNew = fish.x + dx

			if ( xNew > screenRight - fish.contentWidth/2 or xNew < screenLeft + fish.contentWidth/2 ) then
				fish.xdir = -fish.xdir
				if (fish.xdir < 0) then
					fish.fill = fish_left_img
				else
					fish.fill = fish_right_img
				end
			end		
			if ( fish.ydir >= 0 and yNew > screenBottom - fish.contentHeight/2 or fish.ydir < 0 and yNew < wave.y - wave.contentHeight / 2 + 2 * fish.contentHeight ) then
				fish.ydir = -fish.ydir
			end

			fish:translate( dx, dy )
		end

		Runtime:addEventListener( "enterFrame", wave )
		Runtime:addEventListener( "enterFrame", fish )

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
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		-- physics.stop()
		timer.pause(timerid)
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
	
	-- package.loaded[physics] = nil
	-- physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
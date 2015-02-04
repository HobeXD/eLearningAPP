local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"

local centerX, centerY = display.contentWidth/2, display.contentHeight/2
local sea, fish
local question, correct_ans
local score, score_text
local answerBtn = {}
local en = {}
local ch = {}
local timeLeft, time_text, timerid
local theme = "school"

math.randomseed(os.time())

function string:split( inSplitPattern, outResults )
	if not outResults then
	  outResults = { }
	end
	local theStart = 1
	local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
	while theSplitStart do
		table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
		theStart = theSplitEnd+1
		theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
	end
	table.insert( outResults, string.sub( self, theStart ) )
	return outResults
end

function setQuestion()
	local index = math.random(table.getn(en))
	while question.text == en[index] do
		index = math.random(table.getn(en))
	end
	local wrong_ans_index = math.random(table.getn(en))
	while wrong_ans_index == index do
		wrong_ans_index = math.random(table.getn(en))
	end
	question.text = en[index]
	correct_ans = math.random(2)
	answerBtn[correct_ans]:setLabel(ch[index])
	if correct_ans == 1 then
		answerBtn[2]:setLabel(ch[wrong_ans_index])
	else
		answerBtn[1]:setLabel(ch[wrong_ans_index])
	end
	audio.play(audio.loadSound( "pronounciation/" .. theme .. " sound/" .. question.text .. ".mp3"))
end

function scene:create( event )

	local sceneGroup = self.view
	local sky = display.newImageRect(sceneGroup, "pic/sky.png", display.contentWidth, display.contentHeight )
	sky.x, sky.y = centerX, centerY
	sea = display.newImageRect(sceneGroup, "pic/sea.png", display.contentWidth, display.contentHeight )
	sea.x, sea.yspeed = centerX, 2

	question = display.newText( sceneGroup, "", centerX, 130, native.systemFont, 80 )
	local score_word = display.newText( sceneGroup, "Score: ", 120, 50, native.systemFont, 55 )
	score_text = display.newText( {parent=sceneGroup, text="", x=350, y=50, width=300, font=native.systemFont, fontSize=55, align="left"} )
	local time_word = display.newText( sceneGroup, "Time Left: ", 500, 50, native.systemFont, 60 )
	time_text = display.newText( {parent=sceneGroup, text="", x=670, y=50, width=100, font=native.systemFont, fontSize=55, align="left"} )
	
	function onAnswerBtnRelease(index)
		audio.stop()
		if correct_ans == index then
			audio.play(audio.loadSound( "sound/correct.wav"))
			sea.y = sea.y-100
			if ( sea.y < centerY ) then
				sea.y = centerY
			end
			score = math.floor(score+(150+display.contentHeight-sea.y)/10)
			score_text.text = score
		else
			audio.play(audio.loadSound( "sound/wrong.wav"))
			sea.y = sea.y+30 
		end
		setQuestion()
	end

	x = {display.contentWidth/4, display.contentWidth*3/4}
	for i=1, #x do
		btn = widget.newButton{
			defaultFile="pic/answer.png",
			-- overFile="pic/button-over.png",
			font = native.systemFontBold,
			fontSize = 55,
			x = x[i], 
			y = 250,
			onRelease = function() return onAnswerBtnRelease(i) end
		}
		btn.width, btn.height = 200, 150
		sceneGroup:insert( btn )
		answerBtn[i] = btn
	end
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		if event.params ~= nil then
			theme = event.params.word
		end
		local path = system.pathForFile( "word/" .. theme .. " words.csv" )
		local file = io.open( path, "r" )

		for line in file:lines() do
			local tmp = line:split(",")
			table.insert(en, tmp[1])
			table.insert(ch, tmp[2])
		end

		io.close( file )
		file = nil

		if fish ~= nil then
			fish:removeSelf()
			fish = nil
		end 

		local fishSheet = graphics.newImageSheet( "pic/fish" .. math.random(4) .. ".png", {width=407, height=181, numFrames=2} )
		fish = display.newSprite( sceneGroup, fishSheet, {name="fish", start=1, count=2} )
		fish:setSequence( "fish" )
		fish:setFrame( 2 )
		fish.width, fish.height = 250, 120

		sea.y = centerY
		fish.x, fish.y, fish.xdir, fish.xspeed, fish.ydir, fish.yspeed = centerX, centerY, 1, 6, 1, 4
		setQuestion()
		backscene = "level_selection"

	elseif phase == "did" then
		function timerDown()
			timeLeft = timeLeft-1
			time_text.text = timeLeft
			if(timeLeft == 0) then
				composer.gotoScene( "level_complete", "fade", 500 )
			end
		end

		function sea:enterFrame( event )
			local yNew = sea.y+sea.yspeed 
			if ( yNew > display.contentHeight*1.1-fish.height/2) then
				composer.gotoScene( "game_over", "fade", 500 )
			end
			sea:translate( 0, sea.yspeed )
		end

		function fish:enterFrame( event )
			local dy = fish.yspeed * fish.ydir
			local dx = fish.xspeed * fish.xdir 
			local yNew = fish.y + dy
			local xNew = fish.x + dx

			if ( xNew > display.contentWidth - fish.width/2 or xNew < fish.width/2 ) then
				fish.xdir = -fish.xdir
				if (fish.xdir < 0) then
					fish:setFrame( 1 )
				else
					fish:setFrame( 2 )
				end
				fish.width, fish.height = 250, 120
			end
			if ( fish.ydir >= 0 and yNew > display.contentHeight-fish.height/2 or fish.ydir < 0 and yNew < sea.y-150+fish.height/2 ) then
				fish.ydir = -fish.ydir
			end

			fish:translate( dx, dy )
		end
		Runtime:addEventListener( "enterFrame", sea )
		Runtime:addEventListener( "enterFrame", fish )

		score = 0
		score_text.text = score
		timeLeft = 60
		time_text.text = timeLeft
		timerid = timer.performWithDelay(1000, timerDown, timeLeft)
	end
end

function scene:hide( event )
	if  event.phase == "did" then
		en = {}
		ch = {}
		if timerid ~= nil then
			timer.pause(timerid)
		end
		audio.stop()
		Runtime:removeEventListener( "enterFrame", sea )
		Runtime:removeEventListener( "enterFrame", fish )
		composer.removeScene( "game" )
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
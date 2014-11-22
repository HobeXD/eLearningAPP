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
local wave

local function onAnswerBtn1Release()
	local yNew = wave.y -10
	if ( yNew < wave.height / 2 ) then
		wave.y = wave.height / 2
	else
		wave.y = yNew
	end
end

local function onAnswerBtn2Release()
	local yNew = wave.y + 10
	if ( yNew > wave.height * 1.5 ) then
		composer.gotoScene( "game_over", "fade", 500 )
	else
		wave.y = yNew + 10
	end
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

	local fish_left_img = { type="image", filename="fish_left.png" }
	local fish_right_img = { type="image", filename="fish_right.png" }

	-- local fish = display.newImageRect( sceneGroup, "fish_left.png", 90, 45)
	local fish = display.newRect( sceneGroup, display.contentWidth/2, display.contentHeight/2, 90, 45)
	fish.fill = fish_right_img
    -- fish.x, fish.y = display.contentWidth/2, display.contentHeight/2
    fish.xdir = 1
	fish.xspeed = 1.5
    fish.ydir = 1
	fish.yspeed = 2
 
	local question = display.newText( {parent=sceneGroup, text="Color", x=display.contentWidth/2, y=50, font=native.systemFont, fontSize=30} )

	answerBtn1 = widget.newButton{
		label="顏色",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onAnswerBtn1Release	-- event listener function
	}
	answerBtn1.x = display.contentWidth/4
	answerBtn1.y = 80

	answerBtn2 = widget.newButton{
		label="大便",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onAnswerBtn2Release	-- event listener function
	}
	answerBtn2.x = display.contentWidth*3/4
	answerBtn2.y = 80


	sceneGroup:insert( answerBtn1 )
	sceneGroup:insert( answerBtn2 )

	-- Get current edges of visible screen (accounting for the areas cropped by "zoomEven" scaling mode in config.lua)
	local screenTop = display.screenOriginY
	local screenBottom = display.viewableContentHeight + display.screenOriginY
	local screenLeft = display.screenOriginX
	local screenRight = display.viewableContentWidth + display.screenOriginX

	function wave:enterFrame( event )
		local yNew = wave.y + wave.yspeed

		if ( yNew > wave.height * 1.5) then
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

	Runtime:addEventListener( "enterFrame", wave );
	Runtime:addEventListener( "enterFrame", fish );
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
		-- physics.start()
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
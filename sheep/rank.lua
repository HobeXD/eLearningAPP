-----------------------------------------------------------------------------------------
--
-- select.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"

--------------------------------------------

local screenW, screenH, halfW , halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5
local quit

local function onQuitRelease( event )
	quit:removeSelf()
	transition.to(soundGroup, {time = 500, alpha = 0})
	transition.to(soundGroup, {time = 500, delay = 700, alpha = 1})
	composer.removeScene("rank")
	composer.gotoScene( "select", "fade", 500 )
	return true
end

function scene:create( event )
	local sceneGroup = self.view

	menuMusicChannel = audio.play( menuMusic, { loops = -1 } )
	audio.setVolume( 0, { channel = menuMusicChannel } )
	currentChannel = menuMusicChannel
	if (stopFlag== false) then
		audio.fade( { channel = menuMusicChannel, time = 1500, volume = 0.5 } )
	end

	local background = display.newImageRect( "select/background.png", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	quit = widget.newButton{
		defaultFile="game/quit.png",
		overFile="game/quit-over.png",
		width=30, height=30,
		onRelease = onQuitRelease
	}
	quit.xScale, quit.yScale = 0.9, 0.9
	quit.x = screenW * 0.96
	quit.y = screenH * 0.06

	local title = display.newText({text = class, x = halfW, y = 30, font = native.systemFont, fontSize = 18})
	title:setTextColor( 0.8, 0.8, 0.8 )

	sceneGroup:insert( background )
	sceneGroup:insert( quit )
	sceneGroup:insert( title )
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
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
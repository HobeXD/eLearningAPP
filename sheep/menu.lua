-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

local playBtn
local menuMusicChannel
soundGroup = display.newGroup()

local function onPlayBtnRelease()
	audio.fadeOut( { channel=menuMusicChannel, time=700 } )
	transition.to(soundGroup, {time = 500, alpha = 0})
	transition.to(soundGroup, {time = 500, delay = 700, alpha = 1})
	composer.gotoScene( "select", "fade", 500 )	
	return true	-- indicates successful touch
end

function scene:create( event )
	local sceneGroup = self.view

	local menuMusic = audio.loadSound( "welcome/Mary_Had_A_Little_Lamb_(vocal).mp3"  )
	menuMusicChannel = audio.play( menuMusic, { loops = -1 } )
	currentChannel = menuMusicChannel
	stopFlag = false
	if (stopFlag) then
		audio.setVolume( 0 , { channel = currentChannel })
	end

	local background = display.newImageRect( "welcome/background.png", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0
	
	-- create/position logo/title image on upper-half of the screen
	--local titleLogo = display.newImageRect( "welcome/logo.png", 264, 70 )
	--titleLogo.x = display.contentWidth * 0.5
	--titleLogo.y = 200
	
	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label="點一下開始遊戲",
		labelColor = { default={255}, over={128} },
		textOnly = true,
		width=display.contentWidth, height=display.contentHeight*2,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight*0.87

	declare_stopSounds()
	declare_playSounds()

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	--sceneGroup:insert( titleLogo )
	sceneGroup:insert( playBtn )
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

function declare_stopSounds( event )
	stopSound = widget.newButton{
		defaultFile="game/stopSound.png",
		width=100, height=80,
		onRelease = onStopRelease
	}
	stopSound.xScale, stopSound.yScale = 0.5, 0.5
	stopSound.x = display.contentWidth - 30
	stopSound.y = display.contentHeight - 30
	soundGroup:insert( stopSound )
end

function onStopRelease( event )
	stopFlag = true
	audio.setVolume( 0, { channel = currentChannel } )
	stopSound:setEnabled(false)
	stopSound.alpha = 0
	playSound:setEnabled(true)
	playSound.alpha = 1
end

function declare_playSounds( event )
	playSound = widget.newButton{
		defaultFile="game/playSound.png",
		width=100, height=80,
		onRelease = onPlayRelease
	}
	playSound.x = display.contentWidth - 30
	playSound.y = display.contentHeight - 30
	playSound.xScale, playSound.yScale = 0.5, 0.5
	playSound.alpha = 0
	playSound:setEnabled(false)
	soundGroup:insert( playSound )
end

function onPlayRelease( event )
	stopFlag = false
	audio.setVolume( 0.5, { channel = currentChannel } )
	stopSound:setEnabled(true)
	stopSound.alpha = 1
	playSound:setEnabled(false)
	playSound.alpha = 0
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
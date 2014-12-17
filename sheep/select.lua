-----------------------------------------------------------------------------------------
--
-- select.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local selectMusicChannel
local btnGroup = display.newGroup()

local function onBtnRelease( event )
	class = event.target:getLabel()
	backgroundMusic = gameMusic[class]
	vocNum = vocNumTable[class]
	audio.fadeOut( { channel = selectMusicChannel, time = 700} )
	composer.gotoScene( "game", "fade", 500 )
	return true	-- indicates successful touch
end

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	local background = display.newImageRect( "select/background.png", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	-- display "select level" logo
	local titleLogo = display.newImageRect( "select/title.png", 264, 70 )
	titleLogo.x = display.contentWidth * 0.5
	titleLogo.y = 30
	
	-- create a widget button (which will loads level1.lua on release)
	for i = 1, classNum do
		classBtn = widget.newButton{
			label = class[i],
			labelColor = { default={255}, over={128} },
			defaultFile = "select/button.png",
			overFile = "select/button-over.png",
			width = 154, height = 40,
			onRelease = onBtnRelease	-- event listener function
		}
		classBtn.x = display.contentWidth*0.5
		classBtn.y = display.contentHeight*(0.1 + i * 0.15)
		btnGroup:insert( classBtn )
	end

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( titleLogo )
	sceneGroup:insert( btnGroup )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	selectMusicChannel = audio.play( selectMusic, { loops = -1 } )	
	audio.setVolume( 0, { channel = selectMusicChannel } )
	audio.fade( { channel = selectMusicChannel, time = 800, volume = audio.getVolume() } )

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
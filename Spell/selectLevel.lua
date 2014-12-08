-- select level scene
local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local common = require "common"
--------------------------------------------
-- forward declarations and other locals

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease(event)
	local options = {
    effect = "fade",
    time = 500,
    params = { level=event.target.id }
}
	composer.gotoScene( "level", options)
	return true	-- indicates successful touch
end

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	local background = display.newImageRect( "background.jpg", display.contentWidth, display.contentHeight )
	background.x, background.y = screenLeft, screenTop
	background.anchorX = 0
	background.anchorY = 0
	sceneGroup:insert( background )
	
	-- create a widget button (which will loads level.lua on release)
	for i = 1,5 do
		local playBtn = widget.newButton{
			label="level"..i,
			id = i,
			labelColor = { default={255}, over={128} },
			default="button.png",
			over="button-over.png",
			width=154, height=40,
			onRelease = onPlayBtnRelease	-- event listener function
		}
		playBtn.x = screencx
		playBtn.anchorX = 0.5
		playBtn.y = screency + (i-3)*50
		playBtn.anchorY = 0.5
		sceneGroup:insert(playBtn)
	end
	
	-- all display objects must be inserted into group
	
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
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


-- 'onRelease' event listener for playBtn
local function onSchoolBtnRelease()
	
	-- go to level1.lua scene
	local options = {
	    effect = "fade",
	    time = 500,
	    params = {word = "school"}
	}
	composer.gotoScene( "game", options )
	
	return true	-- indicates successful touch
end

local function onPlaceLocationBtnRelease()
	
	-- go to level1.lua scene
	local options = {
	    effect = "fade",
	    time = 500,
	    params = {word = "place_location"}
	}
	composer.gotoScene( "game", options )
	
	return true	-- indicates successful touch
end

local function onTransportationBtnRelease()
	
	-- go to level1.lua scene
	local options = {
	    effect = "fade",
	    time = 500,
	    params = {word = "transportation"}
	}
	composer.gotoScene( "game", options )
	
	return true	-- indicates successful touch
end

local function onPersonalCharacteristicsBtnRelease()
	
	-- go to level1.lua scene
	local options = {
	    effect = "fade",
	    time = 500,
	    params = {word = "personal_characteristics"}
	}
	composer.gotoScene( "game", options )
	
	return true	-- indicates successful touch
end

local function onTimeBtnRelease()
	
	-- go to level1.lua scene
	local options = {
	    effect = "fade",
	    time = 500,
	    params = {word = "time"}
	}
	composer.gotoScene( "game", options )
	
	return true	-- indicates successful touch
end

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	local background = display.newImageRect( "background.jpg", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0
	
	-- create a widget button (which will loads level1.lua on release)
	schoolBtn = widget.newButton{
		label="School",
		labelColor = { default={255}, over={128} },
		defaultFile="button.png",
		overFile="button-over.png",
		width=220, height=40,
		onRelease = onSchoolBtnRelease	-- event listener function
	}
	schoolBtn.x = display.contentWidth*0.5
	schoolBtn.y = display.contentHeight - 400

	place_locationBtn = widget.newButton{
		label="Place & Location",
		labelColor = { default={255}, over={128} },
		defaultFile="button.png",
		overFile="button-over.png",
		width=220, height=40,
		onRelease = onPlaceLocationBtnRelease	-- event listener function
	}
	place_locationBtn.x = display.contentWidth*0.5
	place_locationBtn.y = display.contentHeight - 320

	transportationBtn = widget.newButton{
		label="Transportation",
		labelColor = { default={255}, over={128} },
		defaultFile="button.png",
		overFile="button-over.png",
		width=220, height=40,
		onRelease = onTransportationBtnRelease	-- event listener function
	}
	transportationBtn.x = display.contentWidth*0.5
	transportationBtn.y = display.contentHeight - 240

	personal_characteristicsBtn = widget.newButton{
		label="Personal & Characteristics",
		labelColor = { default={255}, over={128} },
		defaultFile="button.png",
		overFile="button-over.png",
		width=220, height=40,
		onRelease = onPersonalCharacteristicsBtnRelease	-- event listener function
	}
	personal_characteristicsBtn.x = display.contentWidth*0.5
	personal_characteristicsBtn.y = display.contentHeight - 160

	timeBtn = widget.newButton{
		label="Time",
		labelColor = { default={255}, over={128} },
		defaultFile="button.png",
		overFile="button-over.png",
		width=220, height=40,
		onRelease = onTimeBtnRelease	-- event listener function
	}
	timeBtn.x = display.contentWidth*0.5
	timeBtn.y = display.contentHeight - 80
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( schoolBtn )
	sceneGroup:insert( place_locationBtn )
	sceneGroup:insert( transportationBtn )
	sceneGroup:insert( personal_characteristicsBtn )
	sceneGroup:insert( timeBtn )
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

end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
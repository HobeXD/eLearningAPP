local composer = require( "composer" )
local widget = require "widget"
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	local background = display.newImageRect( "background.jpg", display.contentWidth, display.contentHeight )
	background.x, background.y = display.contentWidth / 2, display.contentHeight / 2
	sceneGroup:insert( background )

	theme = {"School", "Place & Location", "Transportation", "Personal & Characteristics", "Time"}
	level_name = {"school", "place_location", "transportation", "personal_characteristics", "time"}

	local function onBtnRelease(level)
		local options = {
		    effect = "fade",
		    time = 500,
		    params = {word = level}
		}
		composer.gotoScene( "game", options )
		return true	-- indicates successful touch
	end

	for i=1, #theme do 
		local btn = widget.newButton{
			label = theme[i],
			labelColor = { default={255}, over={128} },
			defaultFile = "button.png",
			overFile = "button-over.png",
			width = 220, height = 40,
			x = display.contentWidth/2,
			y = display.contentHeight - 480 + 80*i,
			onRelease = function() return onBtnRelease(level_name[i]) end
		}
		sceneGroup:insert( btn )
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	for i=1, #sceneGroup do 
		sceneGroup[i]:removeSelf()
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )
return scene
local composer = require( "composer" )
local widget = require "widget"
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	local background = display.newImageRect(sceneGroup, "pic/cover.jpg", display.contentWidth, display.contentHeight )
	background.x, background.y = display.contentWidth / 2, display.contentHeight / 2

	local title = display.newText(sceneGroup, "Spelling Fish", display.contentWidth / 2, display.contentHeight / 4, native.systemFontBold, 40)
	title:setFillColor( 0.2, 0.2, 0.5 )

	local function onStartBtnRelease()		
		composer.gotoScene( "level_selection", "fade", 500 )		
		return true	-- indicates successful touch
	end

	local startBtn = widget.newButton{
		defaultFile = "pic/start.png",
		-- overFile = "pic/button-over.png",
		x = display.contentWidth/2,
		y = display.contentHeight - 125,
		onRelease = onStartBtnRelease
	}
	startBtn.width, startBtn.height = 150, 40

	sceneGroup:insert( background )
	sceneGroup:insert( title )
	sceneGroup:insert( startBtn )
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
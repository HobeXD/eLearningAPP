-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"
local physics = require "physics"
local tagsGroup = display.newGroup()
local localGroup = display.newGroup()

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local tags = {}

local function onTagsRelease()
	

	
	return true	-- indicates successful touch
end

function scene:create( event )
	local sceneGroup = self.view

	-- display a background image
	local background = display.newImageRect( "./level1/background.png", screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	for i = 1, 3 do
		tags[i] = widget.newButton{
			label = "apple",
			labelColor = { default={000}, over={159/255, 80/255, 0} },
			fontSize = "28",
			defaultFile="./level1/tag.png",
			overFile="./level1/tag-over.png",
			width=100, height=80,
			onRelease = onTagRelease,
			--isEnabled = false
		}
		tags[i].x = display.contentWidth*(0.04 + 0.2 * (i - 1)) 
		tags[i].y = display.contentHeight*0.85
	end
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	tagsGroup.alpha = 0
	tagsGroup:insert( tags[1] )
	tagsGroup:insert( tags[2] )
	tagsGroup:insert( tags[3] )
	transition.to( tagsGroup, { time = 500, delay = 3700, alpha = 1 } )
	--sceneGroup:insert( tags[1], tags[2], tags[3] )
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
		physics.start()
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
		physics.stop()
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
	
	package.loaded[physics] = nil
	physics = nil
end

function showTags( event )

	
end

--ready? & go!
local ready = display.newImage("./level1/ready.png")
ready.xScale = 0.05
ready.yScale = 0.05
localGroup:insert(ready)
ready.x = -150
ready.y = screenH/2
transition.to( ready, { time = 300, delay = 800, x = halfW, xScale = 0.2, yScale = 0.2} )
transition.to( ready, { time = 300, delay = 2100, x = screenW + 150, xScale = 0.05, yScale = 0.05} )

local go = display.newImage("./level1/go.png")
go.xScale = 0.1
go.yScale = 0.1
localGroup:insert(go)
go.x = -150
go.y = screenH/2
transition.to( go, { time = 300, delay = 2400, x = halfW, xScale = 0.2, yScale = 0.2} )
transition.to( go, { time = 300, delay = 3700, x = screenW + 150, xScale = 0.05, yScale = 0.05} )

--show three tags
--transition.to( tagsGroup, { time = 300, delay = 3700, isVisible = true, } )

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
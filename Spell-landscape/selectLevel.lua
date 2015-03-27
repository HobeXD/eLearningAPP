-- select level scene
local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local common = require "common"
--------------------------------------------
local choose_Level;
local nowGameType
local sceneGroup = display.newGroup()
local redirectScene = "level"

intolevel = false
choose_Level = function (event)
	if intolevel == false then
		local options = {
			effect = "fromBottom",
			time = 500,
			params = {gametype = nowGameType, category = event.target.id}
		}
		intolevel = true
		--print("gametype = " .. options.params.gametype .. " category = " .. options.params.category)
		composer.gotoScene(redirectScene , options)
		return true	-- indicates successful touch
	end
end

function scene:create( event )
	print("selectlevel create")
	if event.params.caller ~= nil then
		redirectScene = event.params.caller
	end
	sceneGroup = self.view
	
	local background = display.newImageRect( "background.jpg", display.contentWidth, display.contentHeight )
	background.x, background.y = 0, 0
	background.anchorX = 0
	background.anchorY = 0
	sceneGroup:insert( background )
	
	local playBtn = {}
	for i = 1,5 do
		playBtn[i] = widget.newButton{
			label = categoryStr[i],
			id = categoryStr[i],
			fontSize = 23,
			width=300, height=50,
			strokeWidth = 0,
			labelColor = { default={ 0, 0, 0, 1}, over={ 0.4,0.4,0.8, 1 }},
			shape = "roundedRect",
			fillColor = { default={ 1, 1, 1, 0.7}, over={ 1,1,1, 1 }}, --transparent
			onRelease = choose_Level
		}
		playBtn[i].anchorX = 0.5; playBtn[i].anchorY = 0.5
		playBtn[i].x = screencx; playBtn[i].y = screency + (i-3)*65
		print("y = " .. screency + (i-3)*65)
		sceneGroup:insert(playBtn[i])
	end
	-- all display objects must be inserted into group
end
function scene:show( event )
	local phase = event.phase
	
	if phase == "will" then
		intolevel = false
		nowGameType = event.params.gametype
		--print ( "now game type = " .. nowGameType)
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end
function scene:hide( event )
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
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
	--[[if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end]]
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
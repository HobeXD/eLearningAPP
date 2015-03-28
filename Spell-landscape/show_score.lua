-- show score scene

local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local gamedata = require "gamedata"
local sceneGroup

--[[
local function fieldHandler( event )
	print("field handle")
	if ( "began" == event.phase ) then
			-- This is the "keyboard has appeared" event
			event.text = ""
	elseif ( "ended" == event.phase ) then
			-- This event is called when the user stops editing a field:
			-- for example, when they touch a different field or keyboard focus goes away
			--getname = event.target.text
	elseif ( "submitted" == event.phase ) then
			-- This event occurs when the user presses the "return" key
			-- (if available) on the onscreen keyboard
			--getname = event.target.text
			event.target.isVisible = false
			-- Hide keyboard
			native.setKeyboardFocus( nil )
			gameData:updateRank(event.text, gameData:getScore())
	else --editing
			getname = event.target.text
	end
end  ]]

function scene:create( event )
	sceneGroup = self.view

	local background = display.newImageRect( "background.jpg", display.contentWidth, display.contentHeight )
	background.x, background.y = 0, 0
	background.anchorX = 0
	background.anchorY = 0
	sceneGroup:insert( background )
	
	local star_num = event.params.score / 100
	if star_num > 10 then
		star_num = 10
	elseif event.params.score < 0 then
		star_num = 0
	end
	for i = 1, star_num do
		local score_star = display.newImage(sceneGroup, "img/star.png", screenLeft + 20 + (i-1)*40, barH)
		score_star:scale(event.params.star_scale, event.params.star_scale)
	end
	title_text = display.newText(sceneGroup, event.params.msg, screenLeft + 20, barH-80, native.systemFont, 50)
	score_text = display.newText(sceneGroup, event.params.scoremsg, screenLeft + 20, barH + 50, native.systemFont, 40)
	
	local level_btn = widget.newButton
	{
		left = screencx - 180, 
		top = barH + 130,
		fontSize = 25,
		width = 180,
		height = 50,
		label = "select category",
		labelColor = { default={ 0, 0, 0, 1}, over={ 0.4,0.4,0.8, 1 }},
		shape = "roundedRect",
		fillColor = { default={ 1, 1, 1, 0.5}, over={ 1,1,1, 1 }}, --transparent
		onEvent = go_select_gametype
	}
	local home_btn = widget.newButton
	{
		left = screencx + 20, 
		top = barH + 130,
		width = 180,
		height = 50,
		fontSize = 25,
		labelColor = { default={ 0, 0, 0, 1},over={ 0.4,0.4,0.8, 1 }},
		shape = "roundedRect",
		fillColor = { default={ 1, 1, 1, 0.5}, over={ 1,1,1, 1 }}, --transparent
		label = "back to menu",
		onEvent = go_home
	}
	
	sceneGroup:insert(home_btn)
	sceneGroup:insert(level_btn)
end

function getFocus (event)

end

function scene:show( event )
	local phase = event.phase
	
	if phase == "will" then
		
		--title_text.text = titlemsg
		--score_text.text = scoremsg
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
		print("hide")
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end
function scene:destroy( event )
	print("destory")
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.

end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "enterFrame", scene )
scene:addEventListener( "destroy", scene )

return scene
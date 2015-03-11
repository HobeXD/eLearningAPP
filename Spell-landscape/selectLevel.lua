-- select level scene
local composer = require "composer"
local scene = composer.newScene()
local widget = require "widget"
local common = require "common"
--------------------------------------------
local choose_Level;
local recover_gametype_btn, show_gametype_btn;
local sceneGroup = display.newGroup()

local currentShowedLevel
local gametypeBtn = {}

local function choose_Category(event)
	levelname = event.target.id
	if (currentShowedLevel == levelname) then -- do nothing
		return
	end
	if (currentShowedLevel ~= "" and currentShowedLevel ~= levelname) then
		print("do replace")
		recover_gametype_btn(500)
	end
	currentShowedLevel = levelname
	event.target:setFillColor(1, 1, 0)
	-- if there already has gametype_btn, use new to replace
	print("make read and listen btn")
	local gametypeStr = {"Read", "Listen"}
	local gametypeX = {345, 435}
	local gametypeColor = {{default={1, 0, 0, 1}, over={ 0.4,0.4,0.8, 1 }}, { default={ 0, 1, 0, 1}, over={ 0.4,0.4,0.8, 1 }}}
	for i = 1,2 do
		gametypeBtn[i] = widget.newButton{
			label = gametypeStr[i],
			id = {gametypeStr[i], levelname, event.target},
			fontSize = 23,
			width=90, height=50,
			strokeWidth = 0,
			labelColor = { default={ 0, 0, 0, 1}, over={ 0.4,0.4,0.8, 1 }},
			shape = "roundedRect",
			fillColor = gametypeColor[i], --transparent
			onRelease = choose_Level
		}
		gametypeBtn[i].anchorX = 0.5; gametypeBtn[i].anchorY = 0.5
		gametypeBtn[i].x = gametypeX[i]; gametypeBtn[i].y = event.target.y
		gametypeBtn[i].alpha = 0
		sceneGroup:insert(gametypeBtn[i])	
	end
	
	transition.to(event.target, {time = 500, x = 150, transition=easing.outQuad, onComplete=show_gametype_btn()})
end
recover_gametype_btn = function (t)
	print("recover gametype")
	if gametypeBtn[1] == nil then
		print("can't recover")
		return
	end
	transition.to(gametypeBtn[1].id[3], {time = t, x = screencx, transition=easing.outQuad})
	display.remove(gametypeBtn[1])
	display.remove(gametypeBtn[2])
end
show_gametype_btn = function ()
	print("show gametype")
	transition.fadeIn(gametypeBtn[1], {time = 500, alpha = 1, transition=easing.inQuad})
	transition.fadeIn(gametypeBtn[2], {time = 500, alpha = 1, transition=easing.inQuad})
end

intolevel = false
choose_Level = function (event)
	if intolevel == false then
		local options = {
			effect = "fromBottom",
			time = 500
		}
		intolevel = true
		options.gametype = event.target.id[1]
		options.category = event.target.id[2]
		print("gametype = " .. options.gametype .. " category = " .. options.category)
		composer.gotoScene( "level", options)
		return true	-- indicates successful touch
	end
end

function scene:create( event )
	print("selectlevel create")
	sceneGroup = self.view
	currentShowedLevel = ""
	
	local background = display.newImageRect( "background.jpg", display.contentWidth, display.contentHeight )
	background.x, background.y = 0, 0
	background.anchorX = 0
	background.anchorY = 0
	sceneGroup:insert( background )
	
	stage_str = {"School", "Personal Characteristics", "Transportation", "Places and Locations", "Time"}
	local playBtn = {}
	for i = 1,5 do
		playBtn[i] = widget.newButton{
			label = stage_str[i],
			id = stage_str[i],
			fontSize = 23,
			width=300, height=50,
			strokeWidth = 0,
			labelColor = { default={ 0, 0, 0, 1}, over={ 0.4,0.4,0.8, 1 }},
			shape = "roundedRect",
			fillColor = { default={ 1, 1, 1, 0.7}, over={ 1,1,1, 1 }}, --transparent
			onRelease = choose_Category
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
		print("show did")
		currentShowedLevel = ""
		recover_gametype_btn(0) --make the button look as original
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
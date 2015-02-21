-- Ref: Rolly Bear World Project by Christian Peeters
local composer = require "composer"
local common = require "common"
local widget = require "widget"
local scene = composer.newScene()
local params
local group
 
function catchBackgroundOverlay(event)
	--print("catchBackgroundOverlay") --debug message
	return true 
end

local function onSlide(event)
	local self = event.target
	local offset = 0
	if event.phase == "began" then
        self.markY = self.y    -- store y location of object
    elseif event.phase == "moved" then
		if(event.y - event.yStart < 0) then -- no backward sliding
			--self.x, self.y = x, y    -- move object based on calculations above
			offset = (event.y - event.yStart)
			self.y = offset + self.markY-- move object based on calculations above
		end
	elseif event.phase == "ended" then
		--print("swipe ended")
		if self.y < -screency+50 or offset < -54 then --slide up and resume
			transition.to(group, {y = -320, time = 300, onComplete = resume_quiet})
		else --slide not enough! go back
			transition.to(group, {y = 0, time = 150})
		end
		
	end
    return true
end

function scene:create( event )
	group = self.view
	--background overlay
	local backgroundOverlay = display.newRect (screenLeft, screenTop, screenW, screenH)
	backgroundOverlay:setFillColor( black )
	backgroundOverlay.alpha = 0.6
	group:insert(backgroundOverlay)
	-- Allows an object to continue to receive hit events even if it is not visible. If true, objects will receive hit events regardless of visibility; if false, events are only sent to visible objects. Defaults to false.
	backgroundOverlay.isHitTestable = true 
	--prevent the button event be triggered
	--backgroundOverlay:addEventListener ("tap", catchBackgroundOverlay)
	--backgroundOverlay:addEventListener ("touch", catchBackgroundOverlay)
	
	local on_release_fun = go_home
	local home_btn_name = "Menu"
	local yoffset = 0
	--check mode to get proper button
	local mode = event.params.mode
	-- if show, show ans without pause image
	if mode == "show" then 	
		backgroundOverlay:addEventListener ("tap", catchBackgroundOverlay)
		group:addEventListener("touch", onSlide)
		local c = event.params.chinese
		local e = event.params.english

		local textbackground = display.newRect (screenLeft, screenTop, screenW, 140)
		textbackground:setFillColor( 1,1,1 )
		textbackground.alpha = 1
		group:insert(textbackground)
		
		home_btn_name = "OK"
		on_release_fun = resume
		yoffset = 60
		
		local options = 
		{
			parent = group, --not in pause display group
			text = c,
			x = screenLeft,
			y = screenTop+20,
			width = screenW,
			font = native.systemFont,
			fontSize = 40,
			align = "center"  --new alignment parameter
		}
		chi_text = display.newText(options)
		chi_text:setTextColor(0,0.3,0.7)
		
		options.y = screenTop+80
		options.text = e
		eng_text = display.newText(options)
		eng_text:setTextColor(0,0.3,0.7)
		group:insert (chi_text)
		group:insert (eng_text)
	else -- mode == "back" or "pause"
		--background
		backgroundOverlay:addEventListener ("tap", catchBackgroundOverlay)
	    backgroundOverlay:addEventListener ("touch", catchBackgroundOverlay)
		overlay = display.newImage ("img/pausemenu.png", screencx, screency+yoffset)
		overlay.anchorX = 0.5
		overlay.anchorY = 0.5
		group:insert (overlay)
	end
	-- if back, two button
	if mode == "back" then
		local quit_btn = widget.newButton
		{
			left = screencx + 65, 
			top = screency+10,
			width = 120,
			height = 70,
			shape = "roundedRect",
			cornerRadius = 5,
			labelColor = { default={ 0, 0, 0, 1}, over={ 0.4,0.4,0.8, 1 }},
			fillColor = { default={ 1, 1, 1, 0.7}, over={ 1,1,1, 1 }}, --transparent
			--strokeWidth = 4, 
			fontSize = 30, 
			label = "Quit",
			onRelease = quit_game
		}
		quit_btn.anchorX = 0.5
		quit_btn.anchorY = 0.5
		group:insert (quit_btn)
		
		--go home btn
		local home_btn = widget.newButton
		{
			left = screencx - 60, 
			top = screency+ yoffset+10,
			width = 120,
			height = 70,
			shape = "roundedRect",
			cornerRadius = 5,
			labelColor = { default={ 0, 0, 0, 1}, over={ 0.4,0.4,0.8, 1 }},
			fillColor = { default={ 1, 1, 1, 0.7}, over={ 1,1,1, 1 }}, --transparent
			--strokeWidth = 4, 
			fontSize = 30, 
			label = home_btn_name,
			onRelease = on_release_fun
		}
		home_btn.anchorX = 0.5
		home_btn.anchorY = 0.5
		group:insert (home_btn)
	else	
		--go home btn
		local home_btn = widget.newButton
		{
			left = screencx, 
			top = screency+ yoffset,
			width = 150,
			height = 70,
			shape = "roundedRect",
			cornerRadius = 5,
			labelColor = { default={ 0, 0, 0, 1}, over={ 0.4,0.4,0.8, 1 }},
			fillColor = { default={ 1, 1, 1, 0.7}, over={ 1,1,1, 1 }}, --transparent
			--strokeWidth = 4, 
			fontSize = 30, 
			label = home_btn_name,
			onRelease = on_release_fun
		}
		home_btn.anchorX = 0.5
		home_btn.anchorY = 0.5
		group:insert (home_btn)
	end
end
function scene:show( event )

	ispause = true;
end
function scene:hide( event )
	ispause = false;
end
-- Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
end
 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene